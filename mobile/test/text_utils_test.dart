import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/core/text_utils.dart';

void main() {
  group('parseStoriesFromTree', () {
    test('finds story-* dirs only', () {
      final tree = [
        const TreeEntry('_template-story', 'tree'),
        const TreeEntry('story-template', 'tree'),
        const TreeEntry('story-1', 'tree'),
        const TreeEntry('story-2', 'tree'),
        const TreeEntry('story-1/chapters', 'tree'),
        const TreeEntry('story-seeds', 'tree'),
        const TreeEntry('CLAUDE.MD', 'blob'),
      ];
      // story-template và story-seeds khớp mẫu story-* giống bản web; sắp sau các số.
      expect(parseStoriesFromTree(tree), ['story-1', 'story-2', 'story-seeds', 'story-template']);
    });

    test('numeric sort', () {
      final tree = [
        const TreeEntry('story-10', 'tree'),
        const TreeEntry('story-2', 'tree'),
        const TreeEntry('story-1', 'tree'),
      ];
      expect(parseStoriesFromTree(tree), ['story-1', 'story-2', 'story-10']);
    });
  });

  group('parseChaptersFromTree', () {
    test('sorts numerically, excludes other files and stories', () {
      final tree = [
        const TreeEntry('story-1/chapters/chapter-2.md', 'blob'),
        const TreeEntry('story-1/chapters/chapter-1.md', 'blob'),
        const TreeEntry('story-1/chapters/chapter-10.md', 'blob'),
        const TreeEntry('story-1/chapters/README.md', 'blob'),
        const TreeEntry('story-1/manuscript/chapters/chapter-001.md', 'blob'),
        const TreeEntry('story-2/chapters/chapter-1.md', 'blob'),
      ];
      expect(parseChaptersFromTree(tree, 'story-1'), const [
        ChapterRef('chapter-1', 1),
        ChapterRef('chapter-2', 2),
        ChapterRef('chapter-10', 10),
      ]);
    });

    test('empty when no chapters', () {
      expect(parseChaptersFromTree([const TreeEntry('story-3/chapters', 'tree')], 'story-3'), isEmpty);
    });
  });

  group('parseWorldOverview', () {
    test('extracts title and description', () {
      const raw = '''# World Overview

- **Tên thế giới / bối cảnh:** Vương quốc Elyria
- **Tổng quan 1 đoạn:** Một vương quốc bị chia cắt bởi phép thuật cổ đại.
- **Chủ đề/tinh thần cốt lõi của câu chuyện:** (chưa xác định)
''';
      final r = parseWorldOverview(raw);
      expect(r.title, 'Vương quốc Elyria');
      expect(r.description, 'Một vương quốc bị chia cắt bởi phép thuật cổ đại.');
    });

    test('placeholders become null', () {
      const raw = '- **Tên thế giới / bối cảnh:** (chưa xác định)\n- **Tổng quan 1 đoạn:** (chưa xác định)\n';
      final r = parseWorldOverview(raw);
      expect(r.title, isNull);
      expect(r.description, isNull);
    });
  });

  group('parseMarkdownBlocks', () {
    test('heading + paragraph', () {
      final blocks = parseMarkdownBlocks('# Chương 1: Buổi Sáng Mưa\r\n\r\nTrời đổ mưa từ sáng sớm.');
      expect(blocks, hasLength(2));
      expect(blocks[0].headingLevel, 1);
      expect(blocks[0].plainText, 'Chương 1: Buổi Sáng Mưa');
      expect(blocks[1].headingLevel, 0);
      expect(blocks[1].plainText, 'Trời đổ mưa từ sáng sớm.');
    });

    test('bold and italic', () {
      expect(parseInline('Cô ấy **mạnh mẽ** nhưng *cô đơn*.'), const [
        InlineSpan('Cô ấy '),
        InlineSpan('mạnh mẽ', bold: true),
        InlineSpan(' nhưng '),
        InlineSpan('cô đơn', italic: true),
        InlineSpan('.'),
      ]);
    });
  });

  group('splitForSpeech', () {
    test('short paragraph stays whole', () {
      expect(splitForSpeech('— Anh đi đâu đấy?\n— Tôi không biết.', 220), ['— Anh đi đâu đấy? — Tôi không biết.']);
    });

    test('empty text', () {
      expect(splitForSpeech('   \n ', 220), isEmpty);
    });

    test('splits at sentence ends', () {
      const input = 'Sương bạc phủ mặt sông. Quạ kêu trên cây cháy! Cán giáo gõ vào nhau… Ai đó ho.';
      final r = splitForSpeech(input, 50);
      expect(r, ['Sương bạc phủ mặt sông. Quạ kêu trên cây cháy!', 'Cán giáo gõ vào nhau… Ai đó ho.']);
    });

    test('long sentence splits at commas then words', () {
      const input = 'Hennes đếm cọc, đếm người, đếm từng tiếng ho trong sương sớm của bến lội Haselfurt lạnh ngắt';
      final r = splitForSpeech(input, 30);
      for (final c in r) {
        expect(c.length, lessThanOrEqualTo(30), reason: c);
      }
      expect(r.join(' '), input);
      expect(r.first, 'Hennes đếm cọc, đếm người,');
    });
  });
}
