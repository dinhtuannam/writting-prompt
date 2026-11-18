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

// Gom các mảnh liền nhau thành đoạn không dài quá maxLen.
function packPieces(pieces, maxLen, joiner) {
  const out = [];
  let current = '';
  for (const piece of pieces) {
    if (!piece) continue;
    if (current && (current + joiner + piece).length > maxLen) {
      out.push(current);
      current = piece;
    } else {
      current = current ? current + joiner + piece : piece;
    }
  }
  if (current) out.push(current);
  return out;
}

// Chia một đoạn văn thành các đoạn ngắn để đọc to. Chrome hay tự dừng giữa chừng
// với câu nói dài, nên cắt theo câu, rồi theo dấu phẩy, cuối cùng theo từ.
function splitForSpeech(text, maxLen) {
  const clean = text.replace(/\s+/g, ' ').trim();
  if (!clean) return [];
  if (clean.length <= maxLen) return [clean];
  const sentences = clean.match(/[^.!?…]+(?:[.!?…]+["'”»)]*|$)/g) || [clean];
  const pieces = [];
  for (const raw of sentences) {
    const sentence = raw.trim();
    if (sentence.length <= maxLen) {
      pieces.push(sentence);
      continue;
    }
    const clauses = sentence.replace(/([,;:])\s+/g, '$1\n').split('\n');
    for (const clause of packPieces(clauses, maxLen, ' ')) {
      if (clause.length <= maxLen) pieces.push(clause);
      else pieces.push(...packPieces(clause.split(' '), maxLen, ' '));
    }
  }
  return packPieces(pieces, maxLen, ' ');
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

// ===== Đọc to (sách nói) bằng Web Speech API (impure) =====

const TTS_RATE_KEY = 'reader:ttsRate';
const TTS_VOICE_KEY = 'reader:ttsVoice';
const TTS_AUTONEXT_KEY = 'reader:ttsAutoNext';
const TTS_RATES = [0.8, 1, 1.2, 1.4, 1.6, 2];
const TTS_CHUNK_LEN = 220;

const tts = { blocks: [], index: 0, chunk: 0, playing: false, started: false, token: 0, nextHref: null };
let ttsResumeOnLoad = false;

function ttsSupported() {
  return typeof window !== 'undefined' && 'speechSynthesis' in window && 'SpeechSynthesisUtterance' in window;
}

function readSetting(key, fallback) {
  try {
    const value = localStorage.getItem(key);
    return value === null ? fallback : value;
  } catch (e) {
    return fallback;
  }
}

function writeSetting(key, value) {
  try {
    localStorage.setItem(key, value);
  } catch (e) {
    // localStorage may be unavailable; the setting just won't persist.
  }
}

function ttsVoices() {
  const all = window.speechSynthesis.getVoices();
  const vi = all.filter((v) => v.lang.toLowerCase().startsWith('vi'));
  // Giọng "Online (Natural)" của Edge nghe tự nhiên hơn hẳn, đưa lên đầu.
  vi.sort((a, b) => Number(/natural|online/i.test(b.name)) - Number(/natural|online/i.test(a.name)));
  return { vi, all };
}

function ttsSelectedVoice() {
  const { vi } = ttsVoices();
  const saved = readSetting(TTS_VOICE_KEY, '');
  return vi.find((v) => v.name === saved) || vi[0] || null;
}

// Máy đã nạp danh sách giọng mà không có giọng tiếng Việt nào. Danh sách rỗng
// thì chưa kết luận được (Chrome nạp giọng trễ; vài trình duyệt Android trả rỗng
// nhưng vẫn đọc được theo lang).
function ttsMissingVietnamese() {
  const { vi, all } = ttsVoices();
  return all.length > 0 && vi.length === 0;
}

function ttsFillVoices() {
  const select = document.getElementById('tts-voice');
  const note = document.getElementById('tts-note');
  if (!select) return;
  const { vi } = ttsVoices();
  const current = ttsSelectedVoice();
  select.innerHTML = vi
    .map((v) => `<option value="${escapeHtml(v.name)}"${current && v.name === current.name ? ' selected' : ''}>${escapeHtml(v.name)}</option>`)
    .join('');
  select.hidden = vi.length === 0;
  note.hidden = !ttsMissingVietnamese();
}

function ttsHighlight() {
  document.querySelectorAll('.tts-current').forEach((el) => el.classList.remove('tts-current'));
  const block = tts.blocks[tts.index];
  if (!block || !tts.started) return;
  block.el.classList.add('tts-current');
  const rect = block.el.getBoundingClientRect();
  if (rect.top < 0 || rect.bottom > window.innerHeight - 120) {
    block.el.scrollIntoView({ block: 'center', behavior: 'smooth' });
  }
}

function ttsUpdateButton() {
  const btn = document.getElementById('tts-play');
  if (!btn) return;
  btn.textContent = tts.playing ? 'Tạm dừng' : tts.started ? 'Đọc tiếp' : 'Nghe chương';
  btn.setAttribute('aria-pressed', tts.playing ? 'true' : 'false');
}

function ttsSpeakCurrent() {
  const token = ++tts.token;
  const block = tts.blocks[tts.index];
  if (!block) {
    ttsFinish();
    return;
  }
  ttsHighlight();
  const utterance = new SpeechSynthesisUtterance(block.chunks[tts.chunk]);
  const voice = ttsSelectedVoice();
  if (voice) utterance.voice = voice;
  utterance.lang = voice ? voice.lang : 'vi-VN';
  utterance.rate = parseFloat(readSetting(TTS_RATE_KEY, '1')) || 1;
  utterance.onend = () => {
    if (token !== tts.token || !tts.playing) return;
    if (tts.chunk < block.chunks.length - 1) {
      tts.chunk += 1;
    } else {
      tts.index += 1;
      tts.chunk = 0;
    }
    ttsSpeakCurrent();
  };
  utterance.onerror = (event) => {
    if (token !== tts.token || event.error === 'interrupted' || event.error === 'canceled') return;
    tts.playing = false;
    ttsUpdateButton();
  };
  window.speechSynthesis.speak(utterance);
}

function ttsFirstVisibleIndex() {
  const i = tts.blocks.findIndex((b) => b.el.getBoundingClientRect().bottom > 0);
  return i < 0 ? 0 : i;
}

function ttsPlay() {
  if (!tts.blocks.length) return;
  // Không có giọng Việt thì trình duyệt sẽ đọc bằng giọng Anh, nghe sai hoàn toàn.
  if (ttsMissingVietnamese()) {
    ttsFillVoices();
    return;
  }
  if (!tts.started) {
    tts.index = ttsFirstVisibleIndex();
    tts.chunk = 0;
    tts.started = true;
  }
  window.speechSynthesis.cancel();
  tts.playing = true;
  ttsUpdateButton();
  ttsSpeakCurrent();
}

// Tạm dừng bằng cancel rồi đọc lại đoạn hiện tại: pause()/resume() của trình duyệt
// không ổn định (nhất là Chrome Android).
function ttsPause() {
  tts.playing = false;
  tts.token += 1;
  if (ttsSupported()) window.speechSynthesis.cancel();
  ttsUpdateButton();
}

function ttsJump(index) {
  tts.index = clamp(index, 0, tts.blocks.length - 1);
  tts.chunk = 0;
  tts.started = true;
  if (tts.playing) {
    window.speechSynthesis.cancel();
    ttsSpeakCurrent();
  } else {
    ttsHighlight();
    ttsUpdateButton();
  }
}

function ttsFinish() {
  tts.playing = false;
  tts.started = false;
  ttsHighlight();
  ttsUpdateButton();
  if (tts.nextHref && readSetting(TTS_AUTONEXT_KEY, '1') === '1') {
    ttsResumeOnLoad = true;
    window.location.hash = tts.nextHref;
  }
}

function ttsStop() {
  ttsPause();
  tts.blocks = [];
  tts.started = false;
}

function ttsBarHtml() {
  if (!ttsSupported()) return '';
  const rate = readSetting(TTS_RATE_KEY, '1');
  const autoNext = readSetting(TTS_AUTONEXT_KEY, '1') === '1';
  return `
    <div class="tts-bar" role="region" aria-label="Nghe đọc chương">
      <div class="tts-main">
        <button id="tts-prev" aria-label="Đoạn trước">‹‹</button>
        <button id="tts-play" class="tts-play" aria-pressed="false">Nghe chương</button>
        <button id="tts-next" aria-label="Đoạn sau">››</button>
        <select id="tts-rate" aria-label="Tốc độ đọc">
          ${TTS_RATES.map((r) => `<option value="${r}"${String(r) === rate ? ' selected' : ''}>${r}×</option>`).join('')}
        </select>
      </div>
      <div class="tts-extra">
        <select id="tts-voice" aria-label="Giọng đọc"></select>
        <label><input type="checkbox" id="tts-autonext"${autoNext ? ' checked' : ''}> Tự sang chương sau</label>
      </div>
      <p id="tts-note" class="tts-note" role="alert" hidden><strong>Trình duyệt này chưa có giọng đọc tiếng Việt.</strong> Trên máy tính, mở trang bằng Microsoft Edge (có sẵn giọng HoaiMy, NamMinh). Trên điện thoại Android, dùng Chrome và cài "Tiếng Việt" trong Cài đặt → Chuyển văn bản thành giọng nói. Trên iPhone, thêm giọng "Linh" trong Cài đặt → Trợ năng → Nội dung được đọc.</p>
    </div>
  `;
}

function setupTts(nextHref) {
  if (!ttsSupported()) return;
  const blocks = Array.from(document.querySelectorAll('.chapter-content > h1, .chapter-content > h2, .chapter-content > h3, .chapter-content > p'));
  tts.blocks = blocks
    .map((el) => ({ el, chunks: splitForSpeech(el.innerText, TTS_CHUNK_LEN) }))
    .filter((b) => b.chunks.length);
  tts.index = 0;
  tts.chunk = 0;
  tts.started = false;
  tts.nextHref = nextHref;

  ttsFillVoices();
  window.speechSynthesis.onvoiceschanged = ttsFillVoices;

  document.getElementById('tts-play').addEventListener('click', () => (tts.playing ? ttsPause() : ttsPlay()));
  document.getElementById('tts-prev').addEventListener('click', () => ttsJump(tts.index - 1));
  document.getElementById('tts-next').addEventListener('click', () => ttsJump(tts.index + 1));
  document.getElementById('tts-rate').addEventListener('change', (e) => {
    writeSetting(TTS_RATE_KEY, e.target.value);
    if (tts.playing) ttsJump(tts.index);
  });
  document.getElementById('tts-voice').addEventListener('change', (e) => {
    writeSetting(TTS_VOICE_KEY, e.target.value);
    if (tts.playing) ttsJump(tts.index);
  });
  document.getElementById('tts-autonext').addEventListener('change', (e) => {
    writeSetting(TTS_AUTONEXT_KEY, e.target.checked ? '1' : '0');
  });
  // Đang nghe mà bấm vào một đoạn thì đọc từ đoạn đó.
  tts.blocks.forEach((block, i) => {
    block.el.addEventListener('click', () => {
      if (tts.playing && !window.getSelection().toString()) ttsJump(i);
    });
  });

  if (ttsResumeOnLoad) {
    ttsResumeOnLoad = false;
    window.scrollTo(0, 0);
    tts.started = true;
    ttsPlay();
  }
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
  ttsStop();
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
    ${ttsBarHtml()}
  `;
  document.getElementById('font-smaller').addEventListener('click', () => setFontSize(getFontSize() - 2));
  document.getElementById('font-larger').addEventListener('click', () => setFontSize(getFontSize() + 2));
  if (!ttsResumeOnLoad) restoreProgress(storyId, chapterStem);
  setupTts(next ? `#/${storyId}/${next.stem}` : null);
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
    splitForSpeech,
  };
}
