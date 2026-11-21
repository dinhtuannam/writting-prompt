import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/text_utils.dart';

const githubOwner = 'dinhtuannam';
const githubRepo = 'writting-prompt';
const githubBranch = 'main';

/// Proxy Vercel của bản web (dùng GITHUB_TOKEN, không bị giới hạn 60 request/giờ theo IP).
const treeProxyUrl = 'https://writting-prompt.vercel.app/api/tree';
const _treeDirectUrl =
    'https://api.github.com/repos/$githubOwner/$githubRepo/git/trees/$githubBranch?recursive=1';

/// Thư mục khớp `story-*` nhưng không phải truyện.
const _notStories = {'story-template', 'story-seeds'};

class StoryInfo {
  const StoryInfo({required this.id, required this.title, this.description});
  final String id;
  final String title;
  final String? description;
}

class LoadException implements Exception {
  LoadException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Đọc danh sách truyện/chương từ GitHub. Mọi thứ tải về đều được lưu lại
/// để đọc offline khi mất mạng.
class LibraryRepository {
  LibraryRepository(this._prefs, {http.Client? client}) : _client = client ?? http.Client();

  final SharedPreferences _prefs;
  final http.Client _client;
  Directory? _cacheDir;

  static const _treeKey = 'cache:tree';
  static const _treeTtl = Duration(minutes: 10);
  static const _timeout = Duration(seconds: 15);

  List<TreeEntry>? _memoryTree;

  Future<List<TreeEntry>> fetchTree({bool force = false}) async {
    final cached = _readTreeCache();
    if (!force && cached != null && !cached.stale) return cached.tree;
    try {
      final tree = await _downloadTree();
      _memoryTree = tree;
      await _prefs.setString(
        _treeKey,
        jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'tree': tree.map((e) => e.toJson()).toList(),
        }),
      );
      return tree;
    } catch (e) {
      // Mất mạng: dùng bản cũ nếu có.
      if (cached != null) return cached.tree;
      rethrow;
    }
  }

  Future<List<TreeEntry>> _downloadTree() async {
    Object? lastError;
    for (final url in [treeProxyUrl, _treeDirectUrl]) {
      try {
        final res = await _client
            .get(Uri.parse(url), headers: {'Accept': 'application/vnd.github+json'})
            .timeout(_timeout);
        if (res.statusCode != 200) {
          lastError = LoadException('Không lấy được danh sách truyện (mã lỗi ${res.statusCode}).');
          continue;
        }
        final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final list = (data['tree'] as List?) ?? const [];
        return list.map((e) => TreeEntry.fromJson(e as Map<String, dynamic>)).toList();
      } on LoadException catch (e) {
        lastError = e;
      } catch (e) {
        lastError = LoadException('Không kết nối được tới máy chủ. Kiểm tra mạng rồi thử lại.');
      }
    }
    throw lastError ?? LoadException('Không lấy được danh sách truyện.');
  }

  ({List<TreeEntry> tree, bool stale})? _readTreeCache() {
    final raw = _prefs.getString(_treeKey);
    if (raw == null) return null;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final ts = DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int);
      final tree = _memoryTree ??
          (data['tree'] as List).map((e) => TreeEntry.fromJson(e as Map<String, dynamic>)).toList();
      _memoryTree = tree;
      return (tree: tree, stale: DateTime.now().difference(ts) > _treeTtl);
    } catch (_) {
      return null;
    }
  }

  /// Tải file thô trong repo. Ưu tiên bản mới trên mạng, mất mạng thì dùng bản đã lưu.
  Future<String> fetchRaw(String path) async {
    final file = await _cacheFile(path);
    try {
      final url = 'https://raw.githubusercontent.com/$githubOwner/$githubRepo/$githubBranch/$path';
      final res = await _client.get(Uri.parse(url)).timeout(_timeout);
      if (res.statusCode == 200) {
        final text = utf8.decode(res.bodyBytes);
        await file.parent.create(recursive: true);
        await file.writeAsString(text);
        return text;
      }
      if (res.statusCode == 404) throw LoadException('Không tìm thấy: $path');
    } on LoadException {
      rethrow;
    } catch (_) {
      // lỗi mạng → thử bản lưu bên dưới
    }
    if (await file.exists()) return file.readAsString();
    throw LoadException('Không tải được nội dung (đang offline và chưa lưu bản nào).');
  }

  Future<File> _cacheFile(String path) async {
    _cacheDir ??= Directory('${(await getApplicationSupportDirectory()).path}/repo');
    return File('${_cacheDir!.path}/$path');
  }

  Future<List<StoryInfo>> fetchStories({bool force = false}) async {
    final tree = await fetchTree(force: force);
    final ids = parseStoriesFromTree(tree).where((id) => !_notStories.contains(id)).toList();
    return Future.wait(ids.map((id) async {
      try {
        final o = parseWorldOverview(await fetchRaw('$id/lore/world-overview.md'));
        return StoryInfo(id: id, title: o.title ?? id, description: o.description);
      } catch (_) {
        return StoryInfo(id: id, title: id);
      }
    }));
  }

  Future<List<ChapterRef>> fetchChapters(String storyId, {bool force = false}) async =>
      parseChaptersFromTree(await fetchTree(force: force), storyId);

  Future<List<TextBlock>> fetchChapter(String storyId, String stem) async =>
      parseMarkdownBlocks(await fetchRaw('$storyId/chapters/$stem.md'));
}
