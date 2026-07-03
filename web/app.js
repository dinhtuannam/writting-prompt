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
