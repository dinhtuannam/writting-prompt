// Các hàm thuần (không I/O), port từ web/app.js để app và web hiểu repo giống nhau.

class TreeEntry {
  const TreeEntry(this.path, this.type);

  factory TreeEntry.fromJson(Map<String, dynamic> json) =>
      TreeEntry(json['path'] as String, json['type'] as String);

  final String path;
  final String type; // 'tree' (thư mục) hoặc 'blob' (file)

  Map<String, String> toJson() => {'path': path, 'type': type};
}

class ChapterRef {
  const ChapterRef(this.stem, this.number);

  final String stem; // ví dụ 'chapter-12'
  final int number;

  @override
  bool operator ==(Object other) =>
      other is ChapterRef && other.stem == stem && other.number == number;

  @override
  int get hashCode => Object.hash(stem, number);

  @override
  String toString() => 'ChapterRef($stem, $number)';
}

final _storyDir = RegExp(r'^story-[^/]+$');

List<String> parseStoriesFromTree(List<TreeEntry> tree) {
  final ids = tree
      .where((e) => e.type == 'tree' && _storyDir.hasMatch(e.path))
      .map((e) => e.path)
      .toList();
  ids.sort((a, b) {
    final na = int.tryParse(a.replaceFirst('story-', ''));
    final nb = int.tryParse(b.replaceFirst('story-', ''));
    if (na != null && nb != null) return na.compareTo(nb);
    return a.compareTo(b);
  });
  return ids;
}

List<ChapterRef> parseChaptersFromTree(List<TreeEntry> tree, String storyId) {
  final re = RegExp('^${RegExp.escape(storyId)}/chapters/(chapter-(\\d+))\\.md\$');
  final chapters = <ChapterRef>[];
  for (final entry in tree) {
    if (entry.type != 'blob') continue;
    final m = re.firstMatch(entry.path);
    if (m != null) chapters.add(ChapterRef(m.group(1)!, int.parse(m.group(2)!)));
  }
  chapters.sort((a, b) => a.number.compareTo(b.number));
  return chapters;
}

String? _extractField(String raw, String label) {
  final m = RegExp(RegExp.escape('**$label:**') + r'\s*(.*)').firstMatch(raw);
  if (m == null) return null;
  final value = m.group(1)!.trim();
  if (value.isEmpty || value == '(chưa xác định)') return null;
  return value;
}

class WorldOverview {
  const WorldOverview(this.title, this.description);
  final String? title;
  final String? description;
}

WorldOverview parseWorldOverview(String raw) => WorldOverview(
      _extractField(raw, 'Tên thế giới / bối cảnh'),
      _extractField(raw, 'Tổng quan 1 đoạn'),
    );

// ===== Markdown tối giản: tiêu đề, đoạn văn, **đậm**, *nghiêng* =====

class InlineSpan {
  const InlineSpan(this.text, {this.bold = false, this.italic = false});
  final String text;
  final bool bold;
  final bool italic;

  @override
  bool operator ==(Object other) =>
      other is InlineSpan && other.text == text && other.bold == bold && other.italic == italic;

  @override
  int get hashCode => Object.hash(text, bold, italic);

  @override
  String toString() => 'InlineSpan("$text"${bold ? ', bold' : ''}${italic ? ', italic' : ''})';
}

class TextBlock {
  const TextBlock({required this.headingLevel, required this.spans});

  /// 0 = đoạn văn, 1..6 = tiêu đề.
  final int headingLevel;
  final List<InlineSpan> spans;

  bool get isHeading => headingLevel > 0;

  /// Văn bản thuần (không dấu markdown) để đọc to.
  String get plainText => spans.map((s) => s.text).join();
}

final _inline = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');

List<InlineSpan> parseInline(String text) {
  final spans = <InlineSpan>[];
  var last = 0;
  for (final m in _inline.allMatches(text)) {
    if (m.start > last) spans.add(InlineSpan(text.substring(last, m.start)));
    if (m.group(1) != null) {
      spans.add(InlineSpan(m.group(1)!, bold: true));
    } else {
      spans.add(InlineSpan(m.group(2)!, italic: true));
    }
    last = m.end;
  }
  if (last < text.length) spans.add(InlineSpan(text.substring(last)));
  return spans;
}

final _heading = RegExp(r'^(#{1,6})\s+(.*)$', dotAll: true);

List<TextBlock> parseMarkdownBlocks(String text) {
  final trimmed = text.replaceAll('\r\n', '\n').trim();
  if (trimmed.isEmpty) return const [];
  return trimmed.split(RegExp(r'\n\s*\n')).map((block) {
    final h = _heading.firstMatch(block);
    if (h != null) {
      return TextBlock(headingLevel: h.group(1)!.length, spans: [InlineSpan(h.group(2)!)]);
    }
    return TextBlock(headingLevel: 0, spans: parseInline(block));
  }).toList();
}

// ===== Chia đoạn để đọc to =====

List<String> _packPieces(Iterable<String> pieces, int maxLen, String joiner) {
  final out = <String>[];
  var current = '';
  for (final piece in pieces) {
    if (piece.isEmpty) continue;
    if (current.isNotEmpty && (current + joiner + piece).length > maxLen) {
      out.add(current);
      current = piece;
    } else {
      current = current.isEmpty ? piece : current + joiner + piece;
    }
  }
  if (current.isNotEmpty) out.add(current);
  return out;
}

final _sentence = RegExp('[^.!?…]+(?:[.!?…]+["\'”»)]*|\$)');

/// Cắt văn bản thành các đoạn ≤ [maxLen]: theo câu, rồi theo dấu phẩy, cuối cùng theo từ.
List<String> splitForSpeech(String text, int maxLen) {
  final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (clean.isEmpty) return const [];
  if (clean.length <= maxLen) return [clean];
  final sentences = _sentence.allMatches(clean).map((m) => m.group(0)!).toList();
  final pieces = <String>[];
  for (final raw in sentences.isEmpty ? [clean] : sentences) {
    final sentence = raw.trim();
    if (sentence.length <= maxLen) {
      pieces.add(sentence);
      continue;
    }
    final clauses = sentence.replaceAllMapped(RegExp(r'([,;:])\s+'), (m) => '${m[1]}\n').split('\n');
    for (final clause in _packPieces(clauses, maxLen, ' ')) {
      if (clause.length <= maxLen) {
        pieces.add(clause);
      } else {
        pieces.addAll(_packPieces(clause.split(' '), maxLen, ' '));
      }
    }
  }
  return _packPieces(pieces, maxLen, ' ');
}
