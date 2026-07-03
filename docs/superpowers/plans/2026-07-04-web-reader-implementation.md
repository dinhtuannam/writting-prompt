# Web Reader Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a static, dependency-free website in `web/` that reads stories/chapters directly from the public GitHub repo `dinhtuannam/writting-prompt` (branch `main`) and is ready to deploy on Vercel by pointing its Root Directory at `web/`.

**Architecture:** A single `index.html` + `app.js` (vanilla JS, hash-based routing, no framework/build step) + `style.css`. `app.js` is split into a pure-function section (tree parsing, markdown rendering — unit tested with plain Node scripts) and an impure section (GitHub fetch + localStorage caching, DOM rendering/routing, reading-UX features) verified manually in a browser. Story/chapter discovery uses one GitHub Git Trees API call (cached in localStorage, 10 min TTL); actual content is fetched from `raw.githubusercontent.com`, which is not subject to the API's rate limit.

**Tech Stack:** Plain HTML/CSS/JavaScript (ES2017+, `fetch`, `localStorage`), Node.js only for running plain `assert`-based test scripts (no test framework, no npm install).

---

## Reference: full design

See `docs/superpowers/specs/2026-07-04-web-reader-design.md` for the approved design this plan implements.

---

### Task 1: HTML shell and stylesheet

**Files:**
- Create: `web/index.html`
- Create: `web/style.css`

- [ ] **Step 1: Create `web/index.html`**

```html
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Thư viện truyện</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div id="app">
    <p class="loading">Đang tải...</p>
  </div>
  <script src="app.js"></script>
</body>
</html>
```

- [ ] **Step 2: Create `web/style.css`**

```css
:root {
  color-scheme: light dark;
  --bg: #ffffff;
  --fg: #1a1a1a;
  --muted: #666666;
  --accent: #3b5bfd;
  --border: #e2e2e2;
  --reading-font-size: 18px;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #14161a;
    --fg: #e8e8e8;
    --muted: #9a9a9a;
    --accent: #7fa0ff;
    --border: #2a2d33;
  }
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  background: var(--bg);
  color: var(--fg);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  line-height: 1.6;
}

#app {
  max-width: 42rem;
  margin: 0 auto;
  padding: 1.25rem 1rem 4rem;
}

a {
  color: var(--accent);
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

.loading, .error {
  color: var(--muted);
  text-align: center;
  padding: 2rem 0;
}

.error button {
  margin-top: 1rem;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.5rem;
}

.back-link {
  display: inline-block;
  margin-bottom: 1rem;
}

.story-list, .chapter-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.story-list li, .chapter-list li {
  border-bottom: 1px solid var(--border);
}

.story-list a {
  display: block;
  padding: 1rem 0;
}

.story-title {
  display: block;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--fg);
}

.story-desc {
  display: block;
  font-size: 0.9rem;
  color: var(--muted);
  margin-top: 0.25rem;
}

.chapter-list a {
  display: block;
  padding: 0.9rem 0;
  color: var(--fg);
}

button {
  font: inherit;
  background: var(--border);
  color: var(--fg);
  border: none;
  border-radius: 0.4rem;
  padding: 0.4rem 0.8rem;
  cursor: pointer;
}

button:hover {
  opacity: 0.85;
}

.reader-controls {
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
  margin-bottom: 1rem;
}

.chapter-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin: 1.5rem 0;
  font-size: 0.95rem;
}

.chapter-content {
  font-size: var(--reading-font-size);
}

.chapter-content h1, .chapter-content h2 {
  line-height: 1.3;
}

.chapter-content p {
  margin: 0 0 1.1em;
}

@media (max-width: 480px) {
  #app {
    padding: 1rem 0.85rem 3rem;
  }
  .chapter-nav {
    font-size: 0.85rem;
  }
}
```

- [ ] **Step 3: Verify**

Run: `cat web/index.html web/style.css`
Expected: both files print with the exact content above, non-empty.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/index.html web/style.css
git commit -m "feat(web): add reader HTML shell and stylesheet"
```

---

### Task 2: Pure functions — tree parsing and markdown rendering (TDD)

**Files:**
- Create: `web/test/parse.test.js`
- Create: `web/test/markdown.test.js`
- Create: `web/app.js`

- [ ] **Step 1: Write `web/test/parse.test.js`**

```js
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
```

- [ ] **Step 2: Write `web/test/markdown.test.js`**

```js
const assert = require('assert');
const { renderMarkdownToHtml } = require('../app.js');

// heading + paragraph
{
  const input = '# Chương 1: Buổi Sáng Mưa\n\nTrời đổ mưa từ sáng sớm.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(
    result,
    '<h1>Chương 1: Buổi Sáng Mưa</h1>\n<p>Trời đổ mưa từ sáng sớm.</p>'
  );
  console.log('PASS renderMarkdownToHtml: heading + paragraph');
}

// bold and italic
{
  const input = 'Cô ấy **mạnh mẽ** nhưng *cô đơn*.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>Cô ấy <strong>mạnh mẽ</strong> nhưng <em>cô đơn</em>.</p>');
  console.log('PASS renderMarkdownToHtml: bold and italic');
}

// internal newline becomes <br> within a paragraph block
{
  const input = '— Anh đi đâu đấy?\n— Tôi không biết.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>— Anh đi đâu đấy?<br>— Tôi không biết.</p>');
  console.log('PASS renderMarkdownToHtml: internal newline becomes <br>');
}

// HTML special characters are escaped
{
  const input = 'Cô nói "1 < 2 & 3 > 0".';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>Cô nói "1 &lt; 2 &amp; 3 &gt; 0".</p>');
  console.log('PASS renderMarkdownToHtml: escapes <, >, &');
}

// multiple blocks
{
  const input = '# Chương 2\n\nĐoạn một.\n\nĐoạn hai.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(
    result,
    '<h1>Chương 2</h1>\n<p>Đoạn một.</p>\n<p>Đoạn hai.</p>'
  );
  console.log('PASS renderMarkdownToHtml: multiple paragraph blocks');
}

console.log('All markdown.test.js tests passed.');
```

- [ ] **Step 3: Run both test files to verify they fail (app.js doesn't exist yet)**

Run: `cd /Users/mac2605005/Desktop/writting-prompt && node web/test/parse.test.js`
Expected: throws `Error: Cannot find module '../app.js'`

Run: `node web/test/markdown.test.js`
Expected: throws `Error: Cannot find module '../app.js'`

- [ ] **Step 4: Create `web/app.js` with the pure-function section**

```js
// ===== Config =====
const GITHUB_OWNER = 'dinhtuannam';
const GITHUB_REPO = 'writting-prompt';
const GITHUB_BRANCH = 'main';

// ===== Pure functions =====

function escapeRegExp(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function parseStoriesFromTree(tree) {
  const ids = tree
    .filter((entry) => entry.type === 'tree' && /^story-[^/]+$/.test(entry.path))
    .map((entry) => entry.path);
  return ids.sort((a, b) => {
    const na = parseInt(a.replace('story-', ''), 10);
    const nb = parseInt(b.replace('story-', ''), 10);
    if (!isNaN(na) && !isNaN(nb)) return na - nb;
    return a.localeCompare(b);
  });
}

function parseChaptersFromTree(tree, storyId) {
  const re = new RegExp('^' + escapeRegExp(storyId) + '/chapters/(chapter-(\\d+))\\.md$');
  const chapters = [];
  for (const entry of tree) {
    if (entry.type !== 'blob') continue;
    const match = entry.path.match(re);
    if (match) {
      chapters.push({ stem: match[1], number: parseInt(match[2], 10) });
    }
  }
  chapters.sort((a, b) => a.number - b.number);
  return chapters;
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function renderInline(text) {
  let escaped = escapeHtml(text);
  escaped = escaped.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  escaped = escaped.replace(/\*(.+?)\*/g, '<em>$1</em>');
  return escaped.replace(/\n/g, '<br>');
}

function renderMarkdownToHtml(text) {
  const blocks = text.trim().split(/\n\s*\n/);
  return blocks
    .map((block) => {
      const headingMatch = block.match(/^(#{1,6})\s+(.*)$/);
      if (headingMatch) {
        const level = headingMatch[1].length;
        return `<h${level}>${escapeHtml(headingMatch[2])}</h${level}>`;
      }
      return `<p>${renderInline(block)}</p>`;
    })
    .join('\n');
}

function extractField(rawText, labelPattern) {
  const re = new RegExp(labelPattern + ':\\*\\*\\s*(.*)');
  const match = rawText.match(re);
  if (!match) return null;
  const value = match[1].trim();
  if (!value || value === '(chưa xác định)') return null;
  return value;
}

function parseWorldOverview(rawText) {
  return {
    title: extractField(rawText, '\\*\\*Tên thế giới / bối cảnh'),
    description: extractField(rawText, '\\*\\*Tổng quan 1 đoạn'),
  };
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

- [ ] **Step 5: Run both test files to verify they pass**

Run: `node web/test/parse.test.js`
Expected:
```
PASS parseStoriesFromTree: finds story-* dirs, excludes _template-story
PASS parseStoriesFromTree: numeric sort (story-10 after story-2)
PASS parseChaptersFromTree: sorts numerically, excludes README.md and other stories
PASS parseChaptersFromTree: empty array when no chapter files
PASS parseWorldOverview: extracts title and description
PASS parseWorldOverview: placeholder values become null
PASS clamp: clamps to min/max, passes through in-range values
All parse.test.js tests passed.
```

Run: `node web/test/markdown.test.js`
Expected:
```
PASS renderMarkdownToHtml: heading + paragraph
PASS renderMarkdownToHtml: bold and italic
PASS renderMarkdownToHtml: internal newline becomes <br>
PASS renderMarkdownToHtml: escapes <, >, &
PASS renderMarkdownToHtml: multiple paragraph blocks
All markdown.test.js tests passed.
```

- [ ] **Step 6: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/app.js web/test/parse.test.js web/test/markdown.test.js
git commit -m "feat(web): add tree-parsing and markdown-rendering pure functions with tests"
```

---

### Task 3: GitHub fetch layer with localStorage caching

**Files:**
- Modify: `web/app.js` (insert before the final `if (typeof module !== 'undefined' ...)` block)

- [ ] **Step 1: Insert the fetch/cache section into `web/app.js`**

Find this exact block at the end of `web/app.js`:

```js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

Replace it with:

```js
// ===== GitHub fetch + cache (impure) =====

const CACHE_KEY = 'reader:cache:tree';
const CACHE_TTL_MS = 10 * 60 * 1000;

function readCache() {
  try {
    const raw = localStorage.getItem(CACHE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    if (Date.now() - parsed.timestamp > CACHE_TTL_MS) return null;
    return parsed.tree;
  } catch (e) {
    return null;
  }
}

function writeCache(tree) {
  try {
    localStorage.setItem(CACHE_KEY, JSON.stringify({ timestamp: Date.now(), tree }));
  } catch (e) {
    // localStorage may be unavailable (e.g. private browsing); ignore.
  }
}

async function fetchTree(forceRefresh) {
  if (!forceRefresh) {
    const cached = readCache();
    if (cached) return cached;
  }
  const url = `https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/git/trees/${GITHUB_BRANCH}?recursive=1`;
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error('Không lấy được danh sách truyện từ GitHub (mã lỗi ' + res.status + ').');
  }
  const data = await res.json();
  const tree = data.tree || [];
  writeCache(tree);
  return tree;
}

async function fetchRaw(path) {
  const url = `https://raw.githubusercontent.com/${GITHUB_OWNER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${path}`;
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error('Không tải được nội dung: ' + path);
  }
  return res.text();
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

- [ ] **Step 2: Verify existing tests still pass (this section isn't unit tested, but must not break the pure-function tests)**

Run: `node web/test/parse.test.js && node web/test/markdown.test.js`
Expected: both print their full `PASS ...` lists and `All ... tests passed.` exactly as in Task 2 Step 5, no errors.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/app.js
git commit -m "feat(web): add GitHub tree/raw fetch with localStorage caching"
```

---

### Task 4: Reading UX helpers — font size, scroll progress, debounce

**Files:**
- Modify: `web/app.js` (insert before the final `if (typeof module !== 'undefined' ...)` block)

- [ ] **Step 1: Insert the reading-UX helper section into `web/app.js`**

Find this exact block at the end of `web/app.js`:

```js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

Replace it with:

```js
// ===== Reading UX helpers (impure) =====

const FONT_SIZE_KEY = 'reader:fontSize';
const FONT_SIZE_MIN = 14;
const FONT_SIZE_MAX = 28;
const FONT_SIZE_DEFAULT = 18;

function getFontSize() {
  const raw = localStorage.getItem(FONT_SIZE_KEY);
  const parsed = raw ? parseInt(raw, 10) : NaN;
  return isNaN(parsed) ? FONT_SIZE_DEFAULT : clamp(parsed, FONT_SIZE_MIN, FONT_SIZE_MAX);
}

function setFontSize(size) {
  const clamped = clamp(size, FONT_SIZE_MIN, FONT_SIZE_MAX);
  localStorage.setItem(FONT_SIZE_KEY, String(clamped));
  document.documentElement.style.setProperty('--reading-font-size', clamped + 'px');
}

function progressKey(storyId, chapterStem) {
  return `reader:progress:${storyId}:${chapterStem}`;
}

function saveProgress(storyId, chapterStem) {
  localStorage.setItem(progressKey(storyId, chapterStem), String(window.scrollY));
}

function restoreProgress(storyId, chapterStem) {
  const raw = localStorage.getItem(progressKey(storyId, chapterStem));
  const y = raw ? parseInt(raw, 10) : NaN;
  if (!isNaN(y)) window.scrollTo(0, y);
}

function debounce(fn, delay) {
  let timer = null;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

- [ ] **Step 2: Verify existing tests still pass**

Run: `node web/test/parse.test.js && node web/test/markdown.test.js`
Expected: same full passing output as Task 2 Step 5, no errors.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/app.js
git commit -m "feat(web): add font-size, scroll-progress, and debounce helpers"
```

---

### Task 5: Routing, DOM rendering, and init

**Files:**
- Modify: `web/app.js` (insert before the final `if (typeof module !== 'undefined' ...)` block)

- [ ] **Step 1: Insert the routing/rendering section into `web/app.js`**

Find this exact block at the end of `web/app.js`:

```js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

Replace it with:

```js
// ===== Routing and DOM rendering (impure) =====

let currentScrollHandler = null;

function getAppEl() {
  return document.getElementById('app');
}

function clearScrollHandler() {
  if (currentScrollHandler) {
    window.removeEventListener('scroll', currentScrollHandler);
    currentScrollHandler = null;
  }
}

async function render() {
  clearScrollHandler();
  const hash = window.location.hash.replace(/^#\/?/, '');
  const parts = hash.split('/').filter(Boolean);
  try {
    if (parts.length === 0) {
      await renderStoryList();
    } else if (parts.length === 1) {
      await renderChapterList(parts[0]);
    } else {
      await renderReader(parts[0], parts[1]);
    }
  } catch (err) {
    renderError(err);
  }
}

function renderError(err) {
  getAppEl().innerHTML = `
    <a href="#/" class="back-link">← Thư viện truyện</a>
    <div class="error">
      <p>${escapeHtml(err.message || 'Đã có lỗi xảy ra.')}</p>
      <button id="retry-btn">Thử lại</button>
    </div>
  `;
  document.getElementById('retry-btn').addEventListener('click', render);
}

async function renderStoryList() {
  getAppEl().innerHTML = '<p class="loading">Đang tải danh sách truyện...</p>';
  const tree = await fetchTree(false);
  const storyIds = parseStoriesFromTree(tree);
  if (storyIds.length === 0) {
    getAppEl().innerHTML = '<p>Chưa có truyện nào.</p>';
    return;
  }
  const items = await Promise.all(
    storyIds.map(async (id) => {
      let title = id;
      let description = '';
      try {
        const raw = await fetchRaw(`${id}/lore/world-overview.md`);
        const parsed = parseWorldOverview(raw);
        if (parsed.title) title = parsed.title;
        if (parsed.description) description = parsed.description;
      } catch (e) {
        // lore chưa có nội dung hoặc chưa tải được — dùng id làm tên tạm.
      }
      return { id, title, description };
    })
  );
  getAppEl().innerHTML = `
    <header class="page-header">
      <h1>Thư viện truyện</h1>
      <button id="refresh-btn">Làm mới</button>
    </header>
    <ul class="story-list">
      ${items
        .map(
          (item) => `
        <li>
          <a href="#/${item.id}">
            <span class="story-title">${escapeHtml(item.title)}</span>
            ${item.description ? `<span class="story-desc">${escapeHtml(item.description)}</span>` : ''}
          </a>
        </li>
      `
        )
        .join('')}
    </ul>
  `;
  document.getElementById('refresh-btn').addEventListener('click', async () => {
    await fetchTree(true);
    render();
  });
}

async function renderChapterList(storyId) {
  getAppEl().innerHTML = '<p class="loading">Đang tải danh sách chương...</p>';
  const tree = await fetchTree(false);
  const chapters = parseChaptersFromTree(tree, storyId);
  const backLink = '<a href="#/" class="back-link">← Thư viện truyện</a>';
  if (chapters.length === 0) {
    getAppEl().innerHTML = `${backLink}<p>Chưa có chương nào.</p>`;
    return;
  }
  getAppEl().innerHTML = `
    ${backLink}
    <h1>${escapeHtml(storyId)}</h1>
    <ul class="chapter-list">
      ${chapters
        .map((ch) => `<li><a href="#/${storyId}/${ch.stem}">Chương ${ch.number}</a></li>`)
        .join('')}
    </ul>
  `;
}

async function renderReader(storyId, chapterStem) {
  getAppEl().innerHTML = '<p class="loading">Đang tải chương...</p>';
  const tree = await fetchTree(false);
  const chapters = parseChaptersFromTree(tree, storyId);
  const index = chapters.findIndex((ch) => ch.stem === chapterStem);
  const raw = await fetchRaw(`${storyId}/chapters/${chapterStem}.md`);
  const html = renderMarkdownToHtml(raw);
  const prev = index > 0 ? chapters[index - 1] : null;
  const next = index >= 0 && index < chapters.length - 1 ? chapters[index + 1] : null;
  const nav = `
    <nav class="chapter-nav">
      ${prev ? `<a href="#/${storyId}/${prev.stem}">← Chương ${prev.number}</a>` : '<span></span>'}
      <a href="#/${storyId}" class="back-link">Danh sách chương</a>
      ${next ? `<a href="#/${storyId}/${next.stem}">Chương ${next.number} →</a>` : '<span></span>'}
    </nav>
  `;
  getAppEl().innerHTML = `
    <div class="reader-controls">
      <button id="font-smaller">A-</button>
      <button id="font-larger">A+</button>
    </div>
    ${nav}
    <article class="chapter-content">${html}</article>
    ${nav}
  `;
  document.getElementById('font-smaller').addEventListener('click', () => setFontSize(getFontSize() - 2));
  document.getElementById('font-larger').addEventListener('click', () => setFontSize(getFontSize() + 2));
  restoreProgress(storyId, chapterStem);
  currentScrollHandler = debounce(() => saveProgress(storyId, chapterStem), 300);
  window.addEventListener('scroll', currentScrollHandler);
}

function init() {
  setFontSize(getFontSize());
  window.addEventListener('hashchange', render);
  render();
}

if (typeof window !== 'undefined') {
  window.addEventListener('DOMContentLoaded', init);
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    parseStoriesFromTree,
    parseChaptersFromTree,
    renderMarkdownToHtml,
    parseWorldOverview,
    clamp,
  };
}
```

- [ ] **Step 2: Verify existing tests still pass**

Run: `node web/test/parse.test.js && node web/test/markdown.test.js`
Expected: same full passing output as Task 2 Step 5, no errors.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/app.js
git commit -m "feat(web): add routing, DOM rendering, and app init"
```

---

### Task 6: Deployment guide

**Files:**
- Create: `web/DEPLOY.md`

- [ ] **Step 1: Create `web/DEPLOY.md`**

```markdown
# Deploy lên Vercel

Trang này là 1 site tĩnh (HTML/CSS/JS thuần), không cần build.

## Các bước

1. Đảm bảo repo đã được push lên GitHub (GitHub Desktop tự động làm việc này mỗi khi có commit mới trên `main`).
2. Vào https://vercel.com → **Add New... → Project**.
3. Chọn **Import Git Repository** → chọn repo `dinhtuannam/writting-prompt`.
4. Trong phần cấu hình project:
   - **Root Directory:** `web`
   - **Framework Preset:** Other
   - **Build Command:** để trống (không cần build)
   - **Output Directory:** `.`
5. Bấm **Deploy**. Không cần khai báo biến môi trường nào — trang chỉ gọi API công khai của GitHub (`api.github.com` và `raw.githubusercontent.com`), repo phải ở chế độ **public**.

## Sau khi deploy

- Mỗi khi có chương mới được `/next-chapter` viết + duyệt và GitHub Desktop tự push, mở lại trang và bấm nút **"Làm mới"** ở trang danh sách truyện để thấy ngay (trang cũng tự làm mới sau tối đa 10 phút nhờ cache).
- Nếu đổi tên repo hoặc chuyển sang tài khoản GitHub khác, cập nhật 3 hằng số đầu file `web/app.js`: `GITHUB_OWNER`, `GITHUB_REPO`, `GITHUB_BRANCH`.
```

- [ ] **Step 2: Verify**

Run: `cat web/DEPLOY.md`
Expected: prints the content above, non-empty.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add web/DEPLOY.md
git commit -m "docs(web): add Vercel deployment guide"
```

---

### Task 7: End-to-end manual verification

**Files:** (none — verification only)

- [ ] **Step 1: Run both automated test files one final time**

Run: `cd /Users/mac2605005/Desktop/writting-prompt && node web/test/parse.test.js && node web/test/markdown.test.js`
Expected: both print their full `PASS ...` lists ending in `All ... tests passed.`, exit code 0.

- [ ] **Step 2: Serve the site locally**

Run (foreground, leave running):
```bash
cd /Users/mac2605005/Desktop/writting-prompt/web
python3 -m http.server 8080
```
Expected: `Serving HTTP on :: port 8080 ...` with no errors.

- [ ] **Step 3: Open in a browser and verify the story list**

Open `http://localhost:8080` in a browser.
Expected:
- Page title "Thư viện truyện" and a "Làm mới" button are visible.
- `story-1` appears in the list (title falls back to the literal text `story-1` since `story-1/lore/world-overview.md` still has placeholder values at this point).
- No error message is shown.

- [ ] **Step 4: Verify the chapter list for an empty story**

Click on `story-1`.
Expected: page shows a "← Thư viện truyện" back link and the text "Chưa có chương nào." (no chapters have been written yet).

- [ ] **Step 5: Verify reading UX controls exist and respond**

Manually create a temporary throwaway file to test the reader view end-to-end (not committed):
```bash
cd /Users/mac2605005/Desktop/writting-prompt
cp story-1/chapters/README.md /tmp/chapter-999-backup-check.md
printf '# Chương 999: Kiểm Tra\n\nĐây là đoạn văn kiểm tra hiển thị, **in đậm** và *in nghiêng*.\n' > story-1/chapters/chapter-999.md
```
Refresh `http://localhost:8080/#/story-1` in the browser.
Expected: "Chương 999" now appears in the chapter list. Click it.
Expected: reader view shows the heading "Chương 999: Kiểm Tra", the paragraph with bold/italic rendered correctly, "A-"/"A+" buttons that visibly change text size when clicked, and a "Danh sách chương" back link (no prev/next since it's the only chapter).

- [ ] **Step 6: Clean up the temporary test chapter**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
rm story-1/chapters/chapter-999.md /tmp/chapter-999-backup-check.md
git status
```
Expected: `git status` shows no pending changes related to `chapter-999.md` (it was never committed, only created for local manual verification).

- [ ] **Step 7: Stop the local server**

Stop the `python3 -m http.server 8080` process (Ctrl+C in its terminal, or `pkill -f "http.server 8080"` from another terminal).

No commit for this task — it's verification only, and Step 6 already confirmed no stray files remain.

---

## Post-plan

Once this plan is executed, `web/` is ready to import into Vercel per `web/DEPLOY.md`. The website will automatically reflect any new story created via `/new-story` and any new chapter approved via `/next-chapter`, with no further code changes needed.
