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
