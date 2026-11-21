import 'package:material_ui/material_ui.dart';

import '../app_services.dart';
import '../data/library_repository.dart';
import 'chapter_list_screen.dart';
import 'common.dart';
import 'theme.dart';

class StoryListScreen extends StatefulWidget {
  const StoryListScreen({super.key});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  late Future<List<StoryInfo>> _future = services.repo.fetchStories();

  Future<void> _refresh() async {
    final f = services.repo.fetchStories(force: true);
    setState(() => _future = f);
    await f.catchError((_) => <StoryInfo>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện truyện'),
        actions: [IconButton(icon: const Icon(Icons.refresh), tooltip: 'Làm mới', onPressed: _refresh)],
      ),
      bottomNavigationBar: const NowPlayingBar(),
      body: FutureBuilder<List<StoryInfo>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const LoadingView('Đang tải danh sách truyện...');
          }
          if (snap.hasError) return ErrorView(error: snap.error!, onRetry: _refresh);
          final stories = snap.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: stories.isEmpty
                ? ListView(children: const [Padding(padding: EdgeInsets.all(24), child: Text('Chưa có truyện nào.'))])
                : ListView.separated(
                    itemCount: stories.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, i) {
                      final s = stories[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                        subtitle: s.description == null
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(s.description!,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: mutedColor(context))),
                              ),
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => ChapterListScreen(story: s))),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
