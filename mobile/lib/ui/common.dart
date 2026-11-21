import 'package:material_ui/material_ui.dart';

import '../app_services.dart';
import '../tts/reader_audio_handler.dart';
import 'reader_screen.dart';
import 'theme.dart';

class LoadingView extends StatelessWidget {
  const LoadingView(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: mutedColor(context))),
        ]),
      );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$error', textAlign: TextAlign.center, style: TextStyle(color: mutedColor(context))),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onRetry, child: const Text('Thử lại')),
          ]),
        ),
      );
}

/// Thanh "đang nghe" ở đáy các màn danh sách khi bộ đọc đang có chương.
class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tts = services.tts;
    return ValueListenableBuilder<TtsState>(
      valueListenable: tts.state,
      builder: (context, s, _) {
        if (s.storyId == null || s.stem == null || !s.started) return const SizedBox.shrink();
        final chapter = tts.chapters.where((c) => c.stem == s.stem).firstOrNull;
        return Material(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: SafeArea(
            top: false,
            child: ListTile(
              leading: const Icon(Icons.headphones),
              title: Text(chapter == null ? 'Đang nghe' : 'Chương ${chapter.number}'),
              subtitle: Text(tts.storyTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton.filled(
                icon: Icon(s.playing ? Icons.pause : Icons.play_arrow),
                tooltip: s.playing ? 'Tạm dừng' : 'Đọc tiếp',
                onPressed: s.playing ? tts.pause : tts.play,
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ReaderScreen(
                  storyId: s.storyId!,
                  storyTitle: tts.storyTitle,
                  chapters: tts.chapters,
                  stem: s.stem!,
                ),
              )),
            ),
          ),
        );
      },
    );
  }
}
