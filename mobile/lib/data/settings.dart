import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cài đặt người đọc + tiến độ đọc, lưu trong SharedPreferences.
class Settings extends ChangeNotifier {
  Settings(this._prefs);

  final SharedPreferences _prefs;

  static const fontSizeMin = 14.0;
  static const fontSizeMax = 28.0;
  static const ttsRates = [0.8, 1.0, 1.2, 1.4, 1.6, 2.0];

  double get fontSize => (_prefs.getDouble('fontSize') ?? 18).clamp(fontSizeMin, fontSizeMax);
  set fontSize(double v) {
    _prefs.setDouble('fontSize', v.clamp(fontSizeMin, fontSizeMax));
    notifyListeners();
  }

  /// Tốc độ đọc theo nghĩa người dùng: 1.0 = bình thường.
  double get ttsRate => _prefs.getDouble('ttsRate') ?? 1.0;
  set ttsRate(double v) {
    _prefs.setDouble('ttsRate', v);
    notifyListeners();
  }

  /// Tên giọng đọc đã chọn (null = giọng tiếng Việt mặc định của máy).
  String? get ttsVoice => _prefs.getString('ttsVoice');
  set ttsVoice(String? v) {
    v == null ? _prefs.remove('ttsVoice') : _prefs.setString('ttsVoice', v);
    notifyListeners();
  }

  bool get autoNext => _prefs.getBool('ttsAutoNext') ?? true;
  set autoNext(bool v) {
    _prefs.setBool('ttsAutoNext', v);
    notifyListeners();
  }

  /// Chỉ số đoạn đang đọc dở trong một chương.
  int progress(String storyId, String stem) => _prefs.getInt('progress:$storyId:$stem') ?? 0;
  void saveProgress(String storyId, String stem, int blockIndex) {
    _prefs.setInt('progress:$storyId:$stem', blockIndex);
    _prefs.setString('last:$storyId', stem);
  }

  /// Chương đọc gần nhất của một truyện.
  String? lastChapter(String storyId) => _prefs.getString('last:$storyId');
}
