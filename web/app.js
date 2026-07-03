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
  const res = await fetch('/api/tree');
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
