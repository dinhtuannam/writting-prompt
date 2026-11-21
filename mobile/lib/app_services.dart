import 'package:flutter/services.dart';

import 'data/library_repository.dart';
import 'data/settings.dart';
import 'tts/reader_audio_handler.dart';

class AppServices {
  AppServices({required this.repo, required this.settings, required this.tts});
  final LibraryRepository repo;
  final Settings settings;
  final ReaderAudioHandler tts;
}

/// Khởi tạo một lần trong main() trước runApp.
late final AppServices services;

const _system = MethodChannel('novel_reader/system');

/// Mở Cài đặt → Chuyển văn bản thành giọng nói của Android.
Future<void> openTtsSettings() async {
  try {
    await _system.invokeMethod('openTtsSettings');
  } catch (_) {}
}

/// Mở danh sách tối ưu pin, để người dùng cho app chạy nền không bị hệ thống tắt.
Future<void> openBatterySettings() async {
  try {
    await _system.invokeMethod('openBatterySettings');
  } catch (_) {}
}
