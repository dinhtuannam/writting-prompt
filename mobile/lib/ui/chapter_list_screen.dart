import 'package:material_ui/material_ui.dart';

import '../app_services.dart';
import '../core/text_utils.dart';
import '../data/library_repository.dart';
import 'common.dart';
import 'reader_screen.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key, required this.story});
  final StoryInfo story;

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Future<List<ChapterRef>> _future = services.repo.fetchChapters(widget.story.id);

  Future<void> _refresh() async {
    final f = services.repo.fetchChapters(widget.story.id, force: true);
    setState(() => _future = f);
    await f.catchError((_) => <ChapterRef>[]);
  }

  Future<void> _open(List<ChapterRef> chapters, String stem) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReaderScreen(
        storyId: widget.story.id,
        storyTitle: widget.story.title,
        chapters: chapters,
        stem: stem,
      ),
    ));
    if (mounted) setState(() {}); // cập nhật "đọc tiếp"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      bottomNavigationBar: const NowPlayingBar(),
      body: FutureBuilder<List<ChapterRef>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const LoadingView('Đang tải danh sách chương...');
          if (snap.hasError) return ErrorView(error: snap.error!, onRetry: _refresh);
          final chapters = snap.data!;
          final last = services.settings.lastChapter(widget.story.id);
          final lastRef = chapters.where((c) => c.stem == last).firstOrNull;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                if (chapters.isEmpty)
                  const Padding(padding: EdgeInsets.all(24), child: Text('Chưa có chương nào.'))
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: FilledButton.icon(
                      icon: const Icon(Icons.menu_book),
                      label: Text(lastRef == null ? 'Đọc từ đầu' : 'Đọc tiếp: Chương ${lastRef.number}'),
                      onPressed: () => _open(chapters, (lastRef ?? chapters.first).stem),
                    ),
                  ),
                for (final ch in chapters) ...[
                  ListTile(
                    title: Text('Chương ${ch.number}'),
                    trailing: ch.stem == last ? const Icon(Icons.bookmark, size: 20) : null,
                    onTap: () => _open(chapters, ch.stem),
                  ),
                  const Divider(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
