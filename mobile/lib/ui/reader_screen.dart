import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../app_services.dart';
import '../core/text_utils.dart' as tu;
import '../data/settings.dart';
import '../tts/reader_audio_handler.dart';
import 'common.dart';
import 'theme.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    required this.storyId,
    required this.storyTitle,
    required this.chapters,
    required this.stem,
  });

  final String storyId;
  final String storyTitle;
  final List<tu.ChapterRef> chapters;
  final String stem;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _tts = services.tts;
  final _settings = services.settings;

  late String _stem = widget.stem;
  late List<tu.ChapterRef> _chapters = widget.chapters;
  late Future<List<tu.TextBlock>> _future;
  List<tu.TextBlock>? _blocks;
  int _initialIndex = 0;

  final _scroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  late TtsState _lastTts = _tts.state.value;
  Timer? _saveTimer;

  String get _storyId => widget.storyId;
  bool get _ttsHere => _tts.state.value.isOn(_storyId, _stem) && _tts.state.value.started;

  tu.ChapterRef? get _chapter => _chapters.where((c) => c.stem == _stem).firstOrNull;

  @override
  void initState() {
    super.initState();
    _load();
    _tts.state.addListener(_onTts);
    _settings.addListener(_onSettings);
    _positions.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _tts.state.removeListener(_onTts);
    _settings.removeListener(_onSettings);
    _positions.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _load() {
    _blocks = null;
    _initialIndex = _ttsHere ? _tts.state.value.index : _settings.progress(_storyId, _stem);
    _future = services.repo.fetchChapter(_storyId, _stem).then((blocks) {
      _blocks = blocks;
      _initialIndex = blocks.isEmpty ? 0 : _initialIndex.clamp(0, blocks.length - 1);
      _settings.saveProgress(_storyId, _stem, _initialIndex);
      return blocks;
    });
  }

  void _goTo(String stem) {
    setState(() {
      _stem = stem;
      _load();
    });
  }

  void _onSettings() => setState(() {});

  void _onTts() {
    final s = _tts.state.value;
    final prev = _lastTts;
    _lastTts = s;
    // Bộ đọc vừa tự sang chương sau trong lúc màn này đang mở chương cũ → đi theo.
    if (prev.isOn(_storyId, _stem) && s.storyId == _storyId && s.stem != null && s.stem != _stem) {
      _chapters = _tts.chapters;
      _goTo(s.stem!);
      return;
    }
    if (s.isOn(_storyId, _stem) && s.started && s.playing && s.index != prev.index) {
      _ensureVisible(s.index);
    }
    if (s.error != null && s.error != prev.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.error!)));
    }
    setState(() {});
  }

  void _ensureVisible(int index) {
    final visible = _positions.itemPositions.value
        .any((p) => p.index == index && p.itemLeadingEdge >= 0 && p.itemTrailingEdge <= 0.85);
    if (!visible && _scroll.isAttached) {
      _scroll.scrollTo(
        index: index,
        alignment: 0.2,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  int _firstVisible() {
    final blocks = _blocks;
    if (blocks == null || blocks.isEmpty) return 0;
    final visible = _positions.itemPositions.value.where((p) => p.itemTrailingEdge > 0.02);
    if (visible.isEmpty) return _initialIndex;
    final i = visible.map((p) => p.index).reduce((a, b) => a < b ? a : b);
    return i.clamp(0, blocks.length - 1);
  }

  void _onScroll() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () {
      // Đang nghe chương này thì bộ đọc tự lưu vị trí đoạn đang đọc.
      if (_ttsHere || _blocks == null) return;
      _settings.saveProgress(_storyId, _stem, _firstVisible());
    });
  }

  // ===== Đọc to =====

  Future<bool> _checkVietnamese() async {
    if (await _tts.hasVietnamese()) return true;
    if (!mounted) return false;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Máy chưa có giọng đọc tiếng Việt'),
        content: const Text(
          'Vào Cài đặt → Chuyển văn bản thành giọng nói, chọn công cụ "Dịch vụ lời nói của Google" '
          'rồi tải dữ liệu giọng nói "Tiếng Việt". Nếu chưa có, cài "Speech Services by Google" từ CH Play.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              openTtsSettings();
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
    );
    return false;
  }

  Future<void> _togglePlay() async {
    final s = _tts.state.value;
    if (_ttsHere) {
      s.playing ? await _tts.pause() : await _tts.play();
      return;
    }
    await _readFrom(_firstVisible());
  }

  Future<void> _readFrom(int index) async {
    final blocks = _blocks;
    if (blocks == null || blocks.isEmpty) return;
    if (_ttsHere) {
      await _tts.jumpTo(index);
      if (!_tts.state.value.playing) await _tts.play();
      return;
    }
    if (!await _checkVietnamese()) return;
    await _tts.startChapter(
      storyId: _storyId,
      storyTitle: widget.storyTitle,
      chapters: _chapters,
      stem: _stem,
      blocks: blocks,
      startIndex: index,
    );
  }

  // ===== Giao diện =====

  @override
  Widget build(BuildContext context) {
    final ch = _chapter;
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ch == null ? _stem : 'Chương ${ch.number}'),
          Text(widget.storyTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: mutedColor(context))),
        ]),
        actions: [
          IconButton(
            tooltip: 'Chữ nhỏ hơn',
            icon: const Text('A-', style: TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () => _settings.fontSize -= 2,
          ),
          IconButton(
            tooltip: 'Chữ lớn hơn',
            icon: const Text('A+', style: TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () => _settings.fontSize += 2,
          ),
        ],
      ),
      bottomNavigationBar: _TtsBar(
        here: _ttsHere,
        state: _tts.state.value,
        onPlay: _togglePlay,
        onSettings: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) => const _TtsSettingsSheet(),
        ),
      ),
      body: FutureBuilder<List<tu.TextBlock>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const LoadingView('Đang tải chương...');
          if (snap.hasError) return ErrorView(error: snap.error!, onRetry: () => setState(_load));
          return _buildList(snap.data!);
        },
      ),
    );
  }

  Widget _buildList(List<tu.TextBlock> blocks) {
    final s = _tts.state.value;
    final current = _ttsHere ? s.index : -1;
    final fontSize = _settings.fontSize;
    return ScrollablePositionedList.builder(
      key: ValueKey(_stem),
      itemScrollController: _scroll,
      itemPositionsListener: _positions,
      initialScrollIndex: _initialIndex,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      itemCount: blocks.length + 1,
      itemBuilder: (context, i) {
        if (i == blocks.length) return _chapterNav();
        return _BlockView(
          block: blocks[i],
          fontSize: fontSize,
          highlighted: i == current,
          onTap: s.playing && _ttsHere ? () => _tts.jumpTo(i) : null,
          onLongPress: () {
            HapticFeedback.selectionClick();
            _readFrom(i);
          },
        );
      },
    );
  }

  Widget _chapterNav() {
    final i = _chapters.indexWhere((c) => c.stem == _stem);
    final prev = i > 0 ? _chapters[i - 1] : null;
    final next = i >= 0 && i < _chapters.length - 1 ? _chapters[i + 1] : null;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Row(children: [
        Expanded(
          child: prev == null
              ? const SizedBox()
              : OutlinedButton(onPressed: () => _goTo(prev.stem), child: Text('← Chương ${prev.number}')),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: next == null
              ? const Center(child: Text('Hết chương mới'))
              : FilledButton(onPressed: () => _goTo(next.stem), child: Text('Chương ${next.number} →')),
        ),
      ]),
    );
  }
}

class _BlockView extends StatelessWidget {
  const _BlockView({
    required this.block,
    required this.fontSize,
    required this.highlighted,
    required this.onTap,
    required this.onLongPress,
  });

  final tu.TextBlock block;
  final double fontSize;
  final bool highlighted;
  final VoidCallback? onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final scale = switch (block.headingLevel) { 0 => 1.0, 1 => 1.5, 2 => 1.3, _ => 1.12 };
    final base = TextStyle(
      fontSize: fontSize * scale,
      height: block.isHeading ? 1.3 : 1.6,
      fontWeight: block.isHeading ? FontWeight.w700 : FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: fontSize * 1.1),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: highlighted ? highlightColor(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text.rich(
          TextSpan(
            style: base,
            children: [
              for (final span in block.spans)
                TextSpan(
                  text: span.text,
                  style: TextStyle(
                    fontWeight: span.bold ? FontWeight.w700 : null,
                    fontStyle: span.italic ? FontStyle.italic : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TtsBar extends StatelessWidget {
  const _TtsBar({required this.here, required this.state, required this.onPlay, required this.onSettings});

  final bool here;
  final TtsState state;
  final VoidCallback onPlay;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final tts = services.tts;
    final settings = services.settings;
    final playing = here && state.playing;
    final label = playing ? 'Tạm dừng' : (here ? 'Đọc tiếp' : 'Nghe chương');
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(children: [
            IconButton(
              tooltip: 'Đoạn trước',
              icon: const Icon(Icons.fast_rewind),
              onPressed: here ? tts.skipToPrevious : null,
            ),
            Expanded(
              child: FilledButton.icon(
                icon: state.loading && here
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(playing ? Icons.pause : Icons.headphones),
                label: Text(label),
                onPressed: onPlay,
              ),
            ),
            IconButton(
              tooltip: 'Đoạn sau',
              icon: const Icon(Icons.fast_forward),
              onPressed: here ? tts.skipToNext : null,
            ),
            PopupMenuButton<double>(
              tooltip: 'Tốc độ đọc',
              initialValue: settings.ttsRate,
              onSelected: (r) {
                settings.ttsRate = r;
                tts.restartCurrent();
              },
              itemBuilder: (_) => [
                for (final r in Settings.ttsRates) PopupMenuItem(value: r, child: Text('${_fmt(r)}×')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text('${_fmt(settings.ttsRate)}×', style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            IconButton(tooltip: 'Cài đặt đọc', icon: const Icon(Icons.tune), onPressed: onSettings),
          ]),
        ),
      ),
    );
  }

  static String _fmt(double r) => r == r.roundToDouble() ? r.toStringAsFixed(0) : '$r';
}

class _TtsSettingsSheet extends StatefulWidget {
  const _TtsSettingsSheet();

  @override
  State<_TtsSettingsSheet> createState() => _TtsSettingsSheetState();
}

class _TtsSettingsSheetState extends State<_TtsSettingsSheet> {
  final _voices = services.tts.vietnameseVoices();

  @override
  Widget build(BuildContext context) {
    final settings = services.settings;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Giọng đọc'),
            subtitle: FutureBuilder<List<TtsVoice>>(
              future: _voices,
              builder: (context, snap) {
                final voices = snap.data ?? const <TtsVoice>[];
                final selected = voices.any((v) => v.name == settings.ttsVoice) ? settings.ttsVoice : null;
                return DropdownButton<String?>(
                  isExpanded: true,
                  value: selected,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Mặc định (Tiếng Việt)')),
                    for (final v in voices)
                      DropdownMenuItem(value: v.name, child: Text(v.name, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (v) {
                    setState(() => settings.ttsVoice = v);
                    services.tts.restartCurrent();
                  },
                );
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Tự sang chương sau'),
            value: settings.autoNext,
            onChanged: (v) => setState(() => settings.autoNext = v),
          ),
          const ListTile(
            dense: true,
            leading: Icon(Icons.info_outline),
            title: Text('Nhấn giữ một đoạn để đọc từ đoạn đó. Khi đang nghe, chạm vào đoạn khác để nhảy tới.'),
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Cài đặt giọng nói của máy'),
            subtitle: const Text('Tải giọng Tiếng Việt, chọn công cụ đọc'),
            onTap: openTtsSettings,
          ),
          ListTile(
            leading: const Icon(Icons.battery_saver),
            title: const Text('Cho phép chạy nền'),
            subtitle: const Text('Nếu máy tự dừng đọc khi tắt màn hình, tắt "tối ưu pin" cho app Đọc Truyện'),
            onTap: openBatterySettings,
          ),
        ],
      ),
    );
  }
}
