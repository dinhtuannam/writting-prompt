import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/text_utils.dart';
import '../data/library_repository.dart';
import '../data/settings.dart';

/// Trạng thái đọc to mà giao diện theo dõi (đoạn đang đọc, đang phát hay không).
@immutable
class TtsState {
  const TtsState({
    this.storyId,
    this.stem,
    this.index = 0,
    this.playing = false,
    this.started = false,
    this.loading = false,
    this.error,
  });

  final String? storyId;
  final String? stem;
  final int index;
  final bool playing;

  /// Đã chọn một đoạn để đọc (dùng để tô sáng kể cả khi tạm dừng).
  final bool started;

  /// Đang tải chương kế tiếp.
  final bool loading;
  final String? error;

  bool isOn(String storyId, String stem) => this.storyId == storyId && this.stem == stem;
}

class TtsVoice {
  const TtsVoice(this.name, this.locale);
  final String name;
  final String locale;
}

/// Đọc chương bằng engine TTS của Android bên trong foreground service của
/// audio_service. Service giữ wake lock khi đang phát nên vẫn đọc khi tắt màn
/// hình, và hiện nút điều khiển trên thanh thông báo / màn hình khóa.
class ReaderAudioHandler extends BaseAudioHandler {
  ReaderAudioHandler(this._repo, this._settings);

  final LibraryRepository _repo;
  final Settings _settings;
  final FlutterTts _tts = FlutterTts();

  final ValueNotifier<TtsState> state = ValueNotifier(const TtsState());

  // Chương đang nạp vào bộ đọc.
  String? _storyId;
  String _storyTitle = '';
  List<ChapterRef> _chapters = const [];
  int _chapterPos = -1;
  List<List<String>> _chunks = const [];

  int _index = 0;
  int _chunk = 0;
  bool _playing = false;
  bool _started = false;
  bool _loading = false;
  String? _error;

  /// Tăng mỗi lần dừng/nhảy đoạn để vòng đọc cũ tự thoát.
  int _token = 0;
  Completer<bool>? _speakError;
  AudioSession? _session;
  bool _pausedByInterruption = false;

  static const _chunkLen = 600;

  Future<void> init() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('vi-VN');
    _tts.setErrorHandler((msg) {
      final c = _speakError;
      if (c != null && !c.isCompleted) c.complete(false);
    });

    final session = await AudioSession.instance;
    _session = session;
    await session.configure(const AudioSessionConfiguration.speech());
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          _pausedByInterruption = true;
          pause();
        }
      } else if (_pausedByInterruption && event.type != AudioInterruptionType.unknown) {
        _pausedByInterruption = false;
        play();
      }
    });
    // Rút tai nghe thì dừng, tránh đọc to ra loa ngoài.
    session.becomingNoisyEventStream.listen((_) => pause());
    _publish();
  }

  // ===== Giọng đọc =====

  Future<List<TtsVoice>> vietnameseVoices() async {
    try {
      final raw = await _tts.getVoices as List?;
      final voices = (raw ?? const [])
          .map((v) => Map<String, dynamic>.from(v as Map))
          .where((v) => (v['locale'] as String? ?? '').toLowerCase().startsWith('vi'))
          .map((v) => TtsVoice(v['name'] as String, v['locale'] as String))
          .toList();
      // Giọng không cần mạng lên trước; giữ thứ tự ổn định theo tên.
      voices.sort((a, b) => a.name.compareTo(b.name));
      return voices;
    } catch (_) {
      return const [];
    }
  }

  Future<bool> hasVietnamese() async {
    try {
      final r = await _tts.isLanguageAvailable('vi-VN');
      return r == true || r == 1;
    } catch (_) {
      return true; // không xác định được thì cứ thử đọc
    }
  }

  Future<void> _applyVoiceAndRate() async {
    await _tts.setSpeechRate(_settings.ttsRate / 2); // flutter_tts: 0.5 = tốc độ thường trên Android
    final name = _settings.ttsVoice;
    if (name != null) {
      final voices = await vietnameseVoices();
      final match = voices.where((v) => v.name == name);
      if (match.isNotEmpty) {
        await _tts.setVoice({'name': match.first.name, 'locale': match.first.locale});
        return;
      }
    }
    await _tts.setLanguage('vi-VN');
  }

  // ===== Điều khiển từ giao diện =====

  /// Nạp một chương vào bộ đọc và bắt đầu đọc từ đoạn [startIndex].
  Future<void> startChapter({
    required String storyId,
    required String storyTitle,
    required List<ChapterRef> chapters,
    required String stem,
    required List<TextBlock> blocks,
    int startIndex = 0,
  }) async {
    await _halt();
    _storyId = storyId;
    _storyTitle = storyTitle;
    _chapters = chapters;
    _load(chapters.indexWhere((c) => c.stem == stem), blocks, startIndex);
    await play();
  }

  /// Nhảy tới đoạn [index] của chương đang nạp.
  Future<void> jumpTo(int index) async {
    if (_chunks.isEmpty) return;
    final wasPlaying = _playing;
    await _halt();
    _index = index.clamp(0, _chunks.length - 1);
    _chunk = 0;
    _started = true;
    _saveProgress();
    if (wasPlaying) {
      await play();
    } else {
      _publish();
    }
  }

  /// Đọc lại đoạn hiện tại (sau khi đổi giọng hoặc tốc độ).
  Future<void> restartCurrent() async {
    if (_playing) await jumpTo(_index);
  }

  // ===== AudioHandler (thông báo, màn hình khóa, nút tai nghe) =====

  @override
  Future<void> play() async {
    if (_chunks.isEmpty || _playing) return;
    _error = null;
    _started = true;
    _playing = true;
    final token = ++_token;
    _publish();
    await _session?.setActive(true);
    await _applyVoiceAndRate();
    unawaited(_run(token));
  }

  @override
  Future<void> pause() async {
    if (!_playing) return;
    await _halt();
    _publish();
  }

  @override
  Future<void> stop() async {
    await _halt();
    _started = false;
    _publish();
    await _session?.setActive(false);
    await super.stop();
  }

  @override
  Future<void> skipToNext() => jumpTo(_index + 1);

  @override
  Future<void> skipToPrevious() => jumpTo(_index - 1);

  @override
  Future<void> onTaskRemoved() => stop();

  // ===== Vòng đọc =====

  Future<void> _halt() async {
    _playing = false;
    _token++;
    final c = _speakError;
    if (c != null && !c.isCompleted) c.complete(false);
    await _tts.stop();
  }

  Future<void> _run(int token) async {
    while (token == _token && _playing) {
      if (_index >= _chunks.length) {
        if (await _advanceChapter(token)) continue;
        if (token == _token) await _finish();
        return;
      }
      _publish();
      final ok = await _speak(_chunks[_index][_chunk]);
      if (token != _token) return;
      if (!ok) {
        _playing = false;
        _error = 'Không đọc được đoạn này. Kiểm tra giọng đọc tiếng Việt trong cài đặt máy.';
        _publish();
        return;
      }
      if (_chunk < _chunks[_index].length - 1) {
        _chunk++;
      } else {
        _index++;
        _chunk = 0;
        if (_index < _chunks.length) _saveProgress();
      }
    }
  }

  Future<bool> _speak(String text) async {
    final err = Completer<bool>();
    _speakError = err;
    final done = _tts.speak(text).then((r) => r == 1, onError: (_) => false);
    return Future.any([done, err.future]);
  }

  /// Hết chương: tự nạp chương sau nếu được bật.
  Future<bool> _advanceChapter(int token) async {
    final storyId = _storyId;
    if (!_settings.autoNext || storyId == null) return false;
    var next = _chapterPos + 1;
    if (next >= _chapters.length) {
      // Có thể vừa có chương mới được publish.
      try {
        final fresh = await _repo.fetchChapters(storyId, force: true);
        if (token != _token) return false;
        final cur = _chapterPos >= 0 ? _chapters[_chapterPos].stem : null;
        _chapters = fresh;
        next = fresh.indexWhere((c) => c.stem == cur) + 1;
      } catch (_) {
        return false;
      }
      if (next <= 0 || next >= _chapters.length) return false;
    }
    _loading = true;
    _publish();
    try {
      final blocks = await _repo.fetchChapter(storyId, _chapters[next].stem);
      if (token != _token) return false;
      _load(next, blocks, 0);
      _started = true;
      _saveProgress();
      return true;
    } catch (e) {
      _error = 'Không tải được chương ${_chapters[next].number}: $e';
      return false;
    } finally {
      _loading = false;
    }
  }

  Future<void> _finish() async {
    _playing = false;
    _started = false;
    _index = 0;
    _chunk = 0;
    _publish(completed: true);
    await _session?.setActive(false);
  }

  void _load(int chapterPos, List<TextBlock> blocks, int startIndex) {
    _chapterPos = chapterPos;
    _chunks = blocks.map((b) => splitForSpeech(b.plainText, _chunkLen)).toList();
    // Đoạn rỗng (không có chữ) vẫn giữ chỗ để chỉ số khớp với giao diện.
    for (var i = 0; i < _chunks.length; i++) {
      if (_chunks[i].isEmpty) _chunks[i] = const [' '];
    }
    _index = _chunks.isEmpty ? 0 : startIndex.clamp(0, _chunks.length - 1);
    _chunk = 0;
    _started = false;
    // Tải sẵn chương sau để vẫn đọc tiếp được nếu mất mạng giữa chừng.
    final storyId = _storyId;
    if (storyId != null && chapterPos >= 0 && chapterPos + 1 < _chapters.length) {
      unawaited(_repo.fetchChapter(storyId, _chapters[chapterPos + 1].stem).then((_) {}, onError: (_) {}));
    }
  }

  String get storyTitle => _storyTitle;
  List<ChapterRef> get chapters => _chapters;

  ChapterRef? get _currentChapter =>
      _chapterPos >= 0 && _chapterPos < _chapters.length ? _chapters[_chapterPos] : null;

  void _saveProgress() {
    final ch = _currentChapter;
    if (_storyId != null && ch != null) _settings.saveProgress(_storyId!, ch.stem, _index);
  }

  void _publish({bool completed = false}) {
    final ch = _currentChapter;
    state.value = TtsState(
      storyId: _storyId,
      stem: ch?.stem,
      index: _index,
      playing: _playing,
      started: _started,
      loading: _loading,
      error: _error,
    );
    if (ch != null) {
      final item = MediaItem(
        id: '$_storyId/${ch.stem}',
        title: 'Chương ${ch.number}',
        album: _storyTitle,
        artist: _storyTitle,
        displayDescription: _chunks.isEmpty ? null : 'Đoạn ${_index + 1}/${_chunks.length}',
      );
      if (mediaItem.value?.id != item.id || mediaItem.value?.displayDescription != item.displayDescription) {
        mediaItem.add(item);
      }
    }
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {MediaAction.play, MediaAction.pause, MediaAction.stop},
      androidCompactActionIndices: const [0, 1, 2],
      processingState: completed
          ? AudioProcessingState.completed
          : (_loading ? AudioProcessingState.loading : AudioProcessingState.ready),
      playing: _playing,
    ));
  }
}
