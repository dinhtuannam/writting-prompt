const assert = require('assert');
const { parseStoriesFromTree, parseChaptersFromTree, parseWorldOverview, clamp } = require('../app.js');

// parseStoriesFromTree
{
  const tree = [
    { path: '_template-story', type: 'tree' },
    { path: 'story-1', type: 'tree' },
    { path: 'story-2', type: 'tree' },
    { path: 'story-1/chapters', type: 'tree' },
    { path: 'story-1/chapters/chapter-001.md', type: 'blob' },
    { path: 'CLAUDE.MD', type: 'blob' },
  ];
  const result = parseStoriesFromTree(tree);
  assert.deepStrictEqual(result, ['story-1', 'story-2']);
  console.log('PASS parseStoriesFromTree: finds story-* dirs, excludes _template-story');
}

// parseStoriesFromTree numeric ordering
{
  const tree = [
    { path: 'story-10', type: 'tree' },
    { path: 'story-2', type: 'tree' },
    { path: 'story-1', type: 'tree' },
  ];
  const result = parseStoriesFromTree(tree);
  assert.deepStrictEqual(result, ['story-1', 'story-2', 'story-10']);
  console.log('PASS parseStoriesFromTree: numeric sort (story-10 after story-2)');
}

// parseChaptersFromTree
{
  const tree = [
    { path: 'story-1/chapters/chapter-002.md', type: 'blob' },
    { path: 'story-1/chapters/chapter-001.md', type: 'blob' },
    { path: 'story-1/chapters/chapter-010.md', type: 'blob' },
    { path: 'story-1/chapters/README.md', type: 'blob' },
    { path: 'story-2/chapters/chapter-001.md', type: 'blob' },
  ];
  const result = parseChaptersFromTree(tree, 'story-1');
  assert.deepStrictEqual(result, [
    { stem: 'chapter-001', number: 1 },
    { stem: 'chapter-002', number: 2 },
    { stem: 'chapter-010', number: 10 },
  ]);
  console.log('PASS parseChaptersFromTree: sorts numerically, excludes README.md and other stories');
}

// parseChaptersFromTree: empty when no chapters exist
{
  const tree = [{ path: 'story-3/chapters', type: 'tree' }];
  const result = parseChaptersFromTree(tree, 'story-3');
  assert.deepStrictEqual(result, []);
  console.log('PASS parseChaptersFromTree: empty array when no chapter files');
}

// parseWorldOverview: extracts title and description
{
  const raw = `# World Overview

- **Tên thế giới / bối cảnh:** Vương quốc Elyria
- **Thể loại (fantasy/sci-fi/hiện đại/...):** Fantasy
- **Tổng quan 1 đoạn:** Một vương quốc bị chia cắt bởi phép thuật cổ đại.
- **Chủ đề/tinh thần cốt lõi của câu chuyện:** (chưa xác định)
`;
  const result = parseWorldOverview(raw);
  assert.deepStrictEqual(result, {
    title: 'Vương quốc Elyria',
    description: 'Một vương quốc bị chia cắt bởi phép thuật cổ đại.',
  });
  console.log('PASS parseWorldOverview: extracts title and description');
}

// parseWorldOverview: placeholder values become null
{
  const raw = `# World Overview

- **Tên thế giới / bối cảnh:** (chưa xác định)
- **Tổng quan 1 đoạn:** (chưa xác định)
`;
  const result = parseWorldOverview(raw);
  assert.deepStrictEqual(result, { title: null, description: null });
  console.log('PASS parseWorldOverview: placeholder values become null');
}

// clamp
{
  assert.strictEqual(clamp(10, 14, 28), 14);
  assert.strictEqual(clamp(30, 14, 28), 28);
  assert.strictEqual(clamp(20, 14, 28), 20);
  console.log('PASS clamp: clamps to min/max, passes through in-range values');
}

console.log('All parse.test.js tests passed.');
