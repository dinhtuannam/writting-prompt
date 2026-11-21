import 'package:audio_service/audio_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_services.dart';
import 'data/library_repository.dart';
import 'data/settings.dart';
import 'tts/reader_audio_handler.dart';
import 'ui/story_list_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repo = LibraryRepository(prefs);
  final settings = Settings(prefs);
  final handler = await AudioService.init(
    builder: () => ReaderAudioHandler(repo, settings),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.dinhtuannam.novel_reader.tts',
      androidNotificationChannelName: 'Nghe truyện',
      androidNotificationChannelDescription: 'Điều khiển đọc truyện khi tắt màn hình',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  await handler.init();
  services = AppServices(repo: repo, settings: settings, tts: handler);
  runApp(const NovelReaderApp());
}

class NovelReaderApp extends StatelessWidget {
  const NovelReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đọc Truyện',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const StoryListScreen(),
    );
  }
}
