# Web Reader — Design Spec

## Overview

A static, dependency-free website for reading the AI-generated novel chapters produced by this workspace's `/next-chapter` skill. The site reads directly from the GitHub repo (`dinhtuannam/writting-prompt`, public, branch `main`) that GitHub Desktop already auto-syncs — no build step, no manual content sync. Deployed to Vercel by the user.

## Goals

- Read any story (`story-1`, `story-2`, ...) and any chapter without editing the site when a new story or chapter is added.
- Comfortable reading on mobile and laptop: adjustable font size, auto dark/light theme, remembered reading position.
- Zero maintenance: writing and pushing a new chapter is the only action needed for the site to show it.
- Minimize GitHub API usage well under the 60 req/hour unauthenticated limit.

## Non-goals

- No user accounts, comments, search, or multi-device sync (localStorage only, per-browser).
- No backend/serverless functions — pure static site.
- No build tooling (no bundler, no framework, no npm dependency for the shipped site).

## Architecture

Single-page app: one `index.html`, hash-based routing, all logic in vanilla JS. Three views:

- `#/` — story list
- `#/<story>` — chapter list for that story (e.g. `#/story-1`)
- `#/<story>/<chapter-stem>` — reader view, where `<chapter-stem>` is the chapter filename without the `.md` extension (e.g. `#/story-1/chapter-001` maps to `story-1/chapters/chapter-001.md`)

`app.js` renders the app's single root `<div id="app">` based on the current hash, re-rendering on `hashchange`.

## Folder structure

```
web/
├── index.html
├── style.css
├── app.js
└── DEPLOY.md
```

This is the Vercel project root (user sets "Root Directory" = `web` when importing the repo in Vercel). No `vercel.json` needed — static files, Framework Preset "Other".

## Data source

Two distinct GitHub endpoints, used for different purposes:

1. **Discovery (rate-limited, 60 req/hour unauthenticated):** `GET https://api.github.com/repos/dinhtuannam/writting-prompt/git/trees/main?recursive=1` — one call returns the entire repo file tree. Used to derive:
   - Which `story-*` directories exist and contain a `chapters/` subfolder.
   - Which `chapter-*.md` files exist per story, for sorting/prev-next.
2. **Content (not rate-limited by the API quota):** `https://raw.githubusercontent.com/dinhtuannam/writting-prompt/main/<path>` — used for actual file contents: chapter text and each story's `lore/world-overview.md` (for title/description on the story list).

Config constants at top of `app.js`:
```js
const GITHUB_OWNER = 'dinhtuannam';
const GITHUB_REPO = 'writting-prompt';
const GITHUB_BRANCH = 'main';
```

### Caching the tree call

The tree result is cached in `localStorage` under `reader:cache:tree` as `{ timestamp, tree }`. On any navigation needing the tree, use the cache if `Date.now() - timestamp < 10 * 60 * 1000` (10 min); otherwise re-fetch. A manual "Làm mới" (refresh) button in the story-list header bypasses the cache and re-fetches immediately (for right after writing a new chapter).

### Deriving stories and chapters from the tree

- Story IDs: tree entries with `type: "tree"` and `path` matching `^story-[^/]+$` (this naturally excludes `_template-story`, which starts with `_`). A story with no `chapter-*.md` files yet still appears in the list, with an empty chapter list ("Chưa có chương nào").
- Chapters for a story: tree entries with `type: "blob"` and `path` matching `^<story>/chapters/chapter-(\d+)\.md$`, sorted numerically by the captured group. This list (in memory, derived from the cached tree) also gives prev/next for the reader view — no extra API call needed.
- Story title/description: fetched lazily per story (raw content of `<story>/lore/world-overview.md`), parsed by matching the known template lines:
  - `- **Tên thế giới / bối cảnh:** <value>` → title (fallback to the story id if value is the placeholder `(chưa xác định)` or line not found)
  - `- **Tổng quan 1 đoạn:** <value>` → description (omit if placeholder/not found)

## Markdown rendering

Chapters are plain prose (a single `# Chương N: ...` heading, paragraphs separated by blank lines, occasional `**bold**`, dialogue lines using em dash). A small dependency-free renderer in `app.js`:

1. Split raw text on blank lines into blocks.
2. A block starting with `#`/`##` → heading element (level = number of `#`).
3. Other blocks → escape HTML special characters, convert `**text**` → `<strong>`, then `*text*` → `<em>`, convert internal single newlines → `<br>`, wrap in `<p>`.

No external markdown library — this keeps the shipped site dependency-free per the "đơn giản" requirement, and the input format is fully controlled by our own chapter-writing convention.

## Reading UX features

- **Theme:** `prefers-color-scheme` media query in CSS only (no toggle button, no JS-managed theme state) — automatically matches the device.
- **Font size:** +/- buttons in the reader view adjust a CSS custom property (`--reading-font-size`) on `<html>`, persisted to `localStorage` as `reader:fontSize` (clamped 14–28px, default 18px). Applied on load from localStorage.
- **Resume position:** on scroll (debounced ~300ms), save `window.scrollY` to `localStorage` under `reader:progress:<story>:<chapter-stem>`. On opening a chapter, restore scroll position if a saved value exists.
- **Prev/next chapter:** nav buttons at top and bottom of the reader view, computed from the sorted chapter list already in memory.

## Responsive layout

Single centered text column, `max-width` tuned for reading (~65ch), fluid padding, comfortable line-height. Same markup serves mobile and laptop; only CSS (media queries / clamp()) adapts spacing and font scaling. No separate mobile template.

## Error handling

- Tree fetch fails (network error or rate-limited 403) → show a plain message with a "Thử lại" button; don't crash the page.
- A story has no chapters yet → chapter list view shows "Chưa có chương nào."
- A chapter fetch fails → reader view shows an inline error message with a retry button, chapter list/nav still usable.

## Testing approach

Vanilla JS, no test framework dependency shipped with the site. The two riskiest pieces of pure logic get plain Node-run test scripts (no npm install, just `node <file>`, using `assert` from Node's standard library):

- Tree → stories/chapters derivation (grouping, regex matching, numeric sort, prev/next computation).
- Markdown → HTML renderer (headings, bold, italic, paragraph/line-break handling, HTML-escaping of raw `<`/`&`).

These pure functions live in `app.js` but are written so they can be `require()`d from a Node test script without a DOM (no direct `document`/`window` references inside them — those stay in separate render/glue functions). UI wiring (routing, DOM rendering, scroll listeners) is not unit tested — verified manually in a browser per the `verify` skill after implementation.

## Deployment

`web/DEPLOY.md` (written as part of this feature) covers:
1. Push to GitHub (already automatic via GitHub Desktop).
2. Vercel → New Project → Import `dinhtuannam/writting-prompt`.
3. Root Directory: `web`.
4. Framework Preset: Other. Build Command: none. Output Directory: `.`.
5. Deploy — no environment variables needed (public repo, unauthenticated fetches).
