# Hệ Thống Quản Lý Viết Tiểu Thuyết Dài Bằng AI — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Dựng một hệ thống thư mục + file + 3 skill Claude Code cho phép AI đóng vai tác giả viết tiểu thuyết dài nhiều chương mà không bị quên nhân vật, mốc thời gian, hay tuyến truyện đang mở — áp dụng cho nhiều dự án tiểu thuyết độc lập trong cùng 1 workspace (`story-1`, `story-2`, ...).

**Architecture:** Một template gốc (`_template-story/`) định nghĩa bộ file chuẩn cho 1 dự án (STATE.md làm nguồn sự thật về vị trí hiện tại của truyện, cộng với lore/characters/timeline/plot/summaries/style). Mỗi dự án thực tế (`story-1/`) là bản sao của template, được điền dần nội dung. Một `CLAUDE.MD` ở gốc workspace (đã tồn tại, đang rỗng) chứa quy tắc bắt buộc AI phải đọc trước/cập nhật sau mỗi chương — đây chính là cơ chế chống quên ngữ cảnh. Ba skill (`next-chapter`, `expand-lore`, `new-story`) đóng gói quy trình thao tác thành lệnh lặp lại được.

**Tech Stack:** Markdown thuần + Claude Code project skills (`.claude/skills/*/SKILL.md`) + git để version-control nội dung truyện.

---

## Bối cảnh hiện có (đã kiểm tra trước khi viết plan)

```
/Users/mac2605005/Desktop/writting-prompt/
├── CLAUDE.MD        (rỗng, cần điền)
├── story-1/         (rỗng — dự án bắt đầu trước)
└── story-2/         (rỗng — dự án sau, tạo bằng skill /new-story khi cần)
```

Chưa phải git repo. Không có `.claude/skills/` nào.

## Ghi chú về việc điều chỉnh khỏi quy trình TDD chuẩn

Dự án này tạo ra **nội dung/cấu hình** (markdown templates + skill definitions), không phải code có logic để unit-test. Vì vậy mỗi bước "test" trong plan dưới đây là bước **verify** (đọc lại file bằng `cat`/`ls`, đối chiếu nội dung đúng như đã viết) thay vì chạy pytest. Nguyên tắc DRY/tính đầy đủ/không placeholder vẫn giữ nguyên: mọi nội dung file dưới đây là nội dung đầy đủ, thật, sẽ được ghi y nguyên — các trường như "(chưa xác định)" bên trong file là **nội dung hợp lệ của template** (chỗ trống để người dùng điền sau), không phải placeholder kiểu "TODO" trong plan.

---

### Task 1: Khởi tạo git & khung thư mục workspace

**Files:**
- Create (dirs): `_template-story/{lore,characters,timeline,plot,chapters,summaries,style}`, `.claude/skills/{next-chapter,expand-lore,new-story}`

- [ ] **Step 1: Kiểm tra chưa có git, rồi init**

Run: `cd /Users/mac2605005/Desktop/writting-prompt && git status`
Expected: `fatal: not a git repository...`

Run:
```bash
cd /Users/mac2605005/Desktop/writting-prompt
git init
```
Expected: `Initialized empty Git repository in .../writting-prompt/.git/`

- [ ] **Step 2: Tạo toàn bộ thư mục cần thiết**

Run:
```bash
cd /Users/mac2605005/Desktop/writting-prompt
mkdir -p _template-story/lore _template-story/characters _template-story/timeline _template-story/plot _template-story/chapters _template-story/summaries _template-story/style
mkdir -p .claude/skills/next-chapter .claude/skills/expand-lore .claude/skills/new-story
```

- [ ] **Step 3: Verify cấu trúc**

Run: `find /Users/mac2605005/Desktop/writting-prompt/_template-story /Users/mac2605005/Desktop/writting-prompt/.claude -type d | sort`
Expected: liệt kê đủ 7 thư mục con của `_template-story/` và 3 thư mục con của `.claude/skills/`.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add -A
git commit -m "chore: scaffold directory structure for novel-writing system"
```

---

### Task 2: Template lõi — STATE.md & chapters/README.md

**Files:**
- Create: `_template-story/STATE.md`
- Create: `_template-story/chapters/README.md`

- [ ] **Step 1: Tạo `_template-story/STATE.md`**

```markdown
# Trạng Thái Truyện Hiện Tại

> File này LUÔN được cập nhật sau mỗi chương được duyệt. Đây là nguồn sự thật duy nhất về "truyện đang ở đâu". AI PHẢI đọc toàn bộ file này trước khi viết bất kỳ chương nào.

- **Chương hiện tại đã viết xong:** 0
- **Arc hiện tại:** (chưa bắt đầu)
- **Ngày/thời điểm trong truyện:** (chưa xác định)
- **POV hiện tại:** (chưa xác định)
- **Nhân vật đang có mặt tại hiện trường:** (chưa xác định)
- **Địa điểm hiện tại:** (chưa xác định)
- **Tình huống ngay trước khi chương tiếp theo bắt đầu:** (chưa có — dự án mới khởi tạo)
- **Hook/căng thẳng chưa giải quyết cuối chương gần nhất:** (chưa có)
- **Mục tiêu ngắn hạn của nhân vật chính:** (chưa xác định)

## Ghi chú cho AI khi viết chương tiếp theo
(chưa có ghi chú — sẽ được AI tự cập nhật sau mỗi chương)
```

- [ ] **Step 2: Tạo `_template-story/chapters/README.md`**

```markdown
# Quy Ước Đặt Tên Chương

- Mỗi chương lưu 1 file riêng: `chapter-001.md`, `chapter-002.md`, ... (3 chữ số, tăng dần, không trùng số).
- Tiêu đề đầu file theo format quy định trong `../style/style-guide.md`.
- Không sửa lại chương đã "chốt" (đã được người dùng duyệt) trừ khi người dùng yêu cầu chỉnh sửa rõ ràng.
- Trước khi tạo chương mới, kiểm tra số thứ tự lớn nhất đang có trong thư mục này để đặt số tiếp theo.
```

- [ ] **Step 3: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/_template-story/STATE.md /Users/mac2605005/Desktop/writting-prompt/_template-story/chapters/README.md`
Expected: in ra đúng 2 nội dung ở trên, không rỗng.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/STATE.md _template-story/chapters/README.md
git commit -m "feat: add STATE.md and chapter naming convention template"
```

---

### Task 3: Template nhân vật

**Files:**
- Create: `_template-story/characters/_index.md`
- Create: `_template-story/characters/_template.md`

- [ ] **Step 1: Tạo `_template-story/characters/_index.md`**

```markdown
# Danh Sách Nhân Vật

| Tên | Vai trò | Trạng thái | File chi tiết |
|---|---|---|---|
| (chưa có nhân vật nào) | | | |

> Cập nhật bảng này mỗi khi thêm nhân vật mới. Mỗi nhân vật quan trọng có 1 file riêng trong thư mục này, dùng `_template.md` làm khuôn mẫu (đổi tên thành `<ten-nhan-vat>.md`).
```

- [ ] **Step 2: Tạo `_template-story/characters/_template.md`**

```markdown
# [Tên Nhân Vật]

- **Vai trò trong truyện:** (chính diện / phản diện / phụ...)
- **Ngoại hình:**
- **Tính cách:**
- **Động cơ / mục tiêu:**
- **Arc phát triển dự kiến:**
- **Mối quan hệ với nhân vật khác:**
- **Bí mật / thông tin ẩn (chưa lộ cho người đọc):**
- **Giọng nói / cách nói chuyện đặc trưng:**
- **Trạng thái hiện tại:** còn sống / đã chết / mất tích...
- **Xuất hiện lần cuối:** chương ...

## Lịch sử xuất hiện
| Chương | Sự kiện liên quan đến nhân vật |
|---|---|
```

- [ ] **Step 3: Verify**

Run: `ls /Users/mac2605005/Desktop/writting-prompt/_template-story/characters/`
Expected: `_index.md` và `_template.md` xuất hiện.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/characters/
git commit -m "feat: add character roster and character sheet templates"
```

---

### Task 4: Template timeline

**Files:**
- Create: `_template-story/timeline/timeline.md`

- [ ] **Step 1: Tạo `_template-story/timeline/timeline.md`**

```markdown
# Timeline Sự Kiện

> Ghi lại MỌI sự kiện quan trọng đã xảy ra trong truyện, theo đúng thứ tự thời gian. AI PHẢI đọc ít nhất 10 dòng cuối của bảng này trước khi viết chương mới, và PHẢI thêm dòng mới sau khi 1 chương được duyệt.

| Chương | Thời điểm trong truyện | Sự kiện | Nhân vật liên quan | Hệ quả |
|---|---|---|---|---|
```

- [ ] **Step 2: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/_template-story/timeline/timeline.md`
Expected: nội dung khớp như trên, có header bảng markdown.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/timeline/
git commit -m "feat: add timeline tracking template"
```

---

### Task 5: Template plot (outline & threads)

**Files:**
- Create: `_template-story/plot/outline.md`
- Create: `_template-story/plot/threads.md`

- [ ] **Step 1: Tạo `_template-story/plot/outline.md`**

```markdown
# Outline Tổng Thể

## Ý tưởng gốc (raw idea từ người dùng)
(chưa có — điền khi người dùng cung cấp ý tưởng ban đầu, thường qua skill `/expand-lore`)

## Cấu trúc Act
- **Act 1:** (chưa xác định)
- **Act 2:** (chưa xác định)
- **Act 3:** (chưa xác định)

## Các arc lớn
| Arc | Chương bắt đầu | Chương kết thúc (dự kiến) | Tóm tắt |
|---|---|---|---|
```

- [ ] **Step 2: Tạo `_template-story/plot/threads.md`**

```markdown
# Plot Threads Tracker

> Theo dõi mọi foreshadowing / tuyến truyện đang mở. AI PHẢI đọc file này trước khi viết chương mới (chú ý các thread trạng thái "mở") và PHẢI cập nhật sau khi chương được duyệt (mở thread mới nếu có, đóng thread nếu đã giải quyết).

| Thread | Mở ở chương | Trạng thái | Dự kiến trả (chương) | Ghi chú |
|---|---|---|---|---|
```

- [ ] **Step 3: Verify**

Run: `ls /Users/mac2605005/Desktop/writting-prompt/_template-story/plot/`
Expected: `outline.md` và `threads.md`.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/plot/
git commit -m "feat: add plot outline and open-threads tracker templates"
```

---

### Task 6: Template summaries (chống quên ngữ cảnh — phân tầng)

**Files:**
- Create: `_template-story/summaries/chapter-summaries.md`
- Create: `_template-story/summaries/arc-summaries.md`

- [ ] **Step 1: Tạo `_template-story/summaries/chapter-summaries.md`**

```markdown
# Tóm Tắt Từng Chương

> Sau khi 1 chương được duyệt, thêm 1 mục vào CUỐI file này (150-250 từ, văn xuôi ngắn gọn nêu sự kiện chính + thay đổi trạng thái nhân vật). AI chỉ cần đọc 2-3 mục gần nhất trước khi viết chương mới — không cần đọc toàn bộ manuscript.

Format mỗi mục:
```

```markdown
## Chương N
<tóm tắt 150-250 từ>
```

- [ ] **Step 2: Tạo `_template-story/summaries/arc-summaries.md`**

```markdown
# Tóm Tắt Theo Arc

> Cứ mỗi 5-10 chương (khi 1 arc trong `../plot/outline.md` kết thúc, hoặc chương chia hết cho 5), thêm 1 mục tóm tắt cấp cao (300-500 từ) gộp các chương-summaries tương ứng lại. Dùng để AI nắm bức tranh toàn cục mà không phải đọc lại hàng chục tóm tắt chương lẻ.

Format mỗi mục:
```

```markdown
## Arc: [Tên arc] (Chương X-Y)
<tóm tắt 300-500 từ>
```

- [ ] **Step 3: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/_template-story/summaries/chapter-summaries.md /Users/mac2605005/Desktop/writting-prompt/_template-story/summaries/arc-summaries.md`
Expected: cả 2 file có nội dung hướng dẫn format như trên.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/summaries/
git commit -m "feat: add layered chapter/arc summary templates"
```

---

### Task 7: Template style guide

**Files:**
- Create: `_template-story/style/style-guide.md`

- [ ] **Step 1: Tạo `_template-story/style/style-guide.md`**

```markdown
# Style Guide

- **Thể loại:** (chưa xác định)
- **Ngôi kể (POV):** (chưa xác định — vd: ngôi thứ 3 giới hạn, ngôi thứ nhất...)
- **Thì:** (chưa xác định — vd: quá khứ, hiện tại)
- **Giọng văn / tone:** (chưa xác định)
- **Độ dài mỗi chương mục tiêu:** (chưa xác định — vd: 2000-3000 từ)
- **Quy cách format:** tiêu đề chương dạng "Chương N: [Tên chương]", đối thoại dùng dấu gạch ngang —
- **Điều cấm kỵ / cần tránh:** (chưa xác định)
```

- [ ] **Step 2: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/_template-story/style/style-guide.md`
Expected: nội dung khớp như trên.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/style/
git commit -m "feat: add style guide template"
```

---

### Task 8: Template lore (world-building)

**Files:**
- Create: `_template-story/lore/world-overview.md`
- Create: `_template-story/lore/systems.md`
- Create: `_template-story/lore/factions.md`
- Create: `_template-story/lore/geography.md`
- Create: `_template-story/lore/history.md`

- [ ] **Step 1: Tạo `_template-story/lore/world-overview.md`**

```markdown
# World Overview

- **Tên thế giới / bối cảnh:** (chưa xác định)
- **Thể loại (fantasy/sci-fi/hiện đại/...):** (chưa xác định)
- **Tổng quan 1 đoạn:** (chưa xác định)
- **Chủ đề/tinh thần cốt lõi của câu chuyện:** (chưa xác định)
```

- [ ] **Step 2: Tạo `_template-story/lore/systems.md`**

```markdown
# Hệ Thống Vận Hành Thế Giới

> Phép thuật / công nghệ / siêu năng lực / luật lệ vật lý đặc biệt chi phối thế giới truyện.

- **Tên hệ thống:** (chưa xác định)
- **Nguyên lý hoạt động:** (chưa xác định)
- **Giới hạn / cái giá phải trả khi sử dụng:** (chưa xác định)
- **Ai có thể dùng, ai không:** (chưa xác định)
```

- [ ] **Step 3: Tạo `_template-story/lore/factions.md`**

```markdown
# Phe Phái / Tổ Chức

| Tên phe | Mục tiêu | Lãnh đạo | Quan hệ với các phe khác |
|---|---|---|---|
| (chưa có) | | | |
```

- [ ] **Step 4: Tạo `_template-story/lore/geography.md`**

```markdown
# Địa Lý

| Địa danh | Mô tả | Vai trò trong truyện |
|---|---|---|
| (chưa có) | | |
```

- [ ] **Step 5: Tạo `_template-story/lore/history.md`**

```markdown
# Lịch Sử

> Các sự kiện quá khứ (trước khi truyện bắt đầu) vẫn còn ảnh hưởng tới hiện tại.

| Thời điểm | Sự kiện lịch sử | Ảnh hưởng tới hiện tại |
|---|---|---|
| (chưa có) | | |
```

- [ ] **Step 6: Verify**

Run: `ls /Users/mac2605005/Desktop/writting-prompt/_template-story/lore/`
Expected: 5 file `world-overview.md factions.md geography.md history.md systems.md`.

- [ ] **Step 7: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add _template-story/lore/
git commit -m "feat: add lore/world-building templates"
```

---

### Task 9: Nhân bản template thành `story-1/`

**Files:**
- Create: toàn bộ nội dung `story-1/` (copy từ `_template-story/`)

- [ ] **Step 1: Copy template sang story-1 (thư mục story-1 đã tồn tại và rỗng)**

Run:
```bash
cd /Users/mac2605005/Desktop/writting-prompt
cp -r _template-story/. story-1/
```

- [ ] **Step 2: Verify cấu trúc story-1 khớp template**

Run: `diff -rq /Users/mac2605005/Desktop/writting-prompt/_template-story /Users/mac2605005/Desktop/writting-prompt/story-1`
Expected: không có output (2 cây thư mục giống hệt nhau về nội dung ban đầu).

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add story-1/
git commit -m "feat: bootstrap story-1 from template"
```

---

### Task 10: `CLAUDE.MD` gốc & `ACTIVE-STORY.md`

**Files:**
- Modify: `CLAUDE.MD` (hiện đang rỗng)
- Create: `ACTIVE-STORY.md`

- [ ] **Step 1: Ghi nội dung vào `CLAUDE.MD`**

```markdown
# Workspace: Quản Lý Nhiều Dự Án Tiểu Thuyết AI

## Vai trò
- AI (Claude) đóng vai **tác giả toàn quyền** cho từng dự án: viết toàn bộ nội dung chương, sáng tạo mở rộng lore từ ý tưởng raw của người dùng.
- Người dùng đóng vai **biên tập viên / người cấp ý tưởng**: đưa ý tưởng raw, duyệt hoặc yêu cầu chỉnh sửa — không tự viết văn.

## Các dự án hiện có
| Thư mục | Trạng thái | Ghi chú |
|---|---|---|
| `story-1/` | Đang phát triển | Dự án đầu tiên |
| `story-2/` | Chưa khởi tạo | Chạy `/new-story story-2` khi bắt đầu |

## Dự án đang active
Xem `ACTIVE-STORY.md`. Mọi lệnh `/next-chapter` và `/expand-lore` mặc định thao tác trên dự án active này, trừ khi người dùng chỉ định rõ thư mục khác (vd `/next-chapter story-2`).

## Quy tắc đọc file (BẮT BUỘC trước khi viết bất kỳ chương nào)
Thay `<story>` bằng thư mục dự án đang thao tác (vd `story-1`):
1. `<story>/STATE.md` — đọc toàn bộ
2. `<story>/characters/_index.md`, rồi đọc file riêng của các nhân vật dự kiến xuất hiện trong chương
3. `<story>/timeline/timeline.md` — 10 dòng cuối
4. `<story>/plot/threads.md` — chú ý các thread trạng thái "mở"
5. `<story>/plot/outline.md` — xác định chương sắp viết thuộc arc nào
6. `<story>/summaries/chapter-summaries.md` — 2-3 mục gần nhất
7. `<story>/style/style-guide.md`

Nếu `<story>/lore/` còn trống → đây là dự án mới, cần chạy `/expand-lore` trước khi viết chương đầu tiên.

## Quy tắc cập nhật (BẮT BUỘC sau khi 1 chương được người dùng duyệt)
1. Cập nhật `<story>/STATE.md`
2. Thêm dòng mới vào `<story>/timeline/timeline.md`
3. Thêm mục tóm tắt mới vào `<story>/summaries/chapter-summaries.md`
4. Cập nhật `<story>/plot/threads.md` (mở thread mới nếu chương vừa viết tạo ra, đóng thread nếu đã giải quyết)
5. Nếu số chương vừa hoàn thành chia hết cho 5, viết thêm 1 mục vào `<story>/summaries/arc-summaries.md`

Không bước nào ở trên được bỏ qua, kể cả khi chương "có vẻ không thay đổi gì nhiều".

## Số chương gen mỗi lần
Mặc định **1 chương / lần gọi** `/next-chapter`. Lý do: mỗi chương là một điểm kiểm soát chất lượng — nếu AI lệch mạch truyện, người dùng bắt lỗi ngay tại chương đó thay vì để sai sót cộng dồn. Chỉ viết nhiều hơn 1 chương khi người dùng yêu cầu rõ ràng (vd "viết liền 2 chương").

## Cấu trúc mỗi dự án (`story-N/`)
| Thư mục/file | Vai trò |
|---|---|
| `STATE.md` | Trạng thái truyện hiện tại — nguồn sự thật duy nhất |
| `lore/` | Thế giới, hệ thống, phe phái, địa lý, lịch sử |
| `characters/` | Hồ sơ nhân vật + roster (`_index.md`) |
| `timeline/` | Nhật ký sự kiện theo thời gian |
| `plot/` | Outline tổng thể + tracker tuyến truyện đang mở |
| `chapters/` | Nội dung chương đã viết (`chapter-001.md`, ...) |
| `summaries/` | Tóm tắt từng chương + tóm tắt theo arc |
| `style/` | Giọng văn, POV, thì, quy cách format |

## Skills
- `/next-chapter [story]` — sinh chương tiếp theo dựa trên trạng thái hiện tại
- `/expand-lore [story]` — mở rộng ý tưởng raw của người dùng thành lore hoàn chỉnh
- `/new-story <ten>` — tạo 1 dự án tiểu thuyết mới từ `_template-story/`

## Template gốc
`_template-story/` chứa bộ file rỗng chuẩn cho 1 dự án mới. KHÔNG viết nội dung truyện trực tiếp vào đây — chỉ dùng làm khuôn khi tạo story mới qua `/new-story`.
```

- [ ] **Step 2: Tạo `ACTIVE-STORY.md`**

```
story-1
```

- [ ] **Step 3: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/CLAUDE.MD /Users/mac2605005/Desktop/writting-prompt/ACTIVE-STORY.md`
Expected: `CLAUDE.MD` in ra đầy đủ nội dung ở trên, `ACTIVE-STORY.md` in ra `story-1`.

- [ ] **Step 4: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add CLAUDE.MD ACTIVE-STORY.md
git commit -m "docs: define workspace rules and set active story"
```

---

### Task 11: Skill `/next-chapter`

**Files:**
- Create: `.claude/skills/next-chapter/SKILL.md`

- [ ] **Step 1: Tạo `.claude/skills/next-chapter/SKILL.md`**

```markdown
---
name: next-chapter
description: Sinh chương tiếp theo của 1 dự án tiểu thuyết dựa trên trạng thái hiện tại (STATE.md, timeline, nhân vật, plot threads). Dùng khi người dùng muốn AI viết tiếp truyện. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Next Chapter

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/next-chapter story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace để biết story đang active. Gọi thư mục này là `<story>` cho các bước sau.

## Bước 1 — Đọc bối cảnh (bắt buộc, đúng thứ tự, không bỏ qua bước nào)
1. Đọc toàn bộ `<story>/STATE.md`
2. Đọc `<story>/characters/_index.md`, sau đó đọc file chi tiết của các nhân vật dự kiến xuất hiện trong chương sắp viết
3. Đọc 10 dòng cuối `<story>/timeline/timeline.md`
4. Đọc `<story>/plot/threads.md`, chú ý các thread có trạng thái "mở"
5. Đọc `<story>/plot/outline.md` để biết chương này thuộc arc nào
6. Đọc 2-3 mục gần nhất trong `<story>/summaries/chapter-summaries.md`
7. Đọc `<story>/style/style-guide.md`

## Bước 2 — Xác nhận phạm vi trước khi viết
Mặc định chỉ viết **1 chương** mỗi lần chạy skill này, kể cả khi người dùng không nói rõ số lượng. Nếu `<story>/lore/` còn trống hoặc `<story>/STATE.md` chưa có nội dung thực (vẫn là "(chưa xác định)"), dừng lại và đề nghị người dùng chạy `/expand-lore <story>` trước, hoặc cung cấp ý tưởng raw ngay trong hội thoại.

## Bước 3 — Viết chương
- Tuân thủ đúng giọng văn, POV, thì trong `<story>/style/style-guide.md`
- Không mâu thuẫn với bất kỳ sự kiện nào trong `<story>/timeline/timeline.md` hoặc thông tin trong `<story>/characters/`
- Phát triển hoặc giải quyết ít nhất 1 thread từ `<story>/plot/threads.md` nếu hợp lý với mạch truyện
- Kết chương bằng 1 hook hoặc câu hỏi mở để dẫn sang chương sau
- Lưu vào `<story>/chapters/chapter-NNN.md` (số thứ tự tiếp theo, 3 chữ số, dựa trên file số lớn nhất đang có)

## Bước 4 — Trình bày cho người dùng duyệt
Đưa chương vừa viết cho người dùng đọc trực tiếp trong hội thoại. KHÔNG thực hiện Bước 5 cho đến khi người dùng xác nhận đồng ý hoặc đã chỉnh sửa xong.

## Bước 5 — Sau khi được duyệt, cập nhật hệ thống (bắt buộc, không bỏ qua)
1. Cập nhật `<story>/STATE.md` (chương hiện tại, POV, địa điểm, hook cuối chương, mục tiêu ngắn hạn mới)
2. Thêm dòng mới vào `<story>/timeline/timeline.md`
3. Thêm mục tóm tắt mới vào `<story>/summaries/chapter-summaries.md`
4. Cập nhật `<story>/plot/threads.md` (mở thread mới nếu chương vừa viết tạo ra, đóng thread nếu đã giải quyết)
5. Nếu số chương vừa hoàn thành chia hết cho 5, viết thêm mục vào `<story>/summaries/arc-summaries.md`
```

- [ ] **Step 2: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/.claude/skills/next-chapter/SKILL.md`
Expected: nội dung khớp như trên, frontmatter có `name` và `description`.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add .claude/skills/next-chapter/
git commit -m "feat: add /next-chapter skill"
```

---

### Task 12: Skill `/expand-lore`

**Files:**
- Create: `.claude/skills/expand-lore/SKILL.md`

- [ ] **Step 1: Tạo `.claude/skills/expand-lore/SKILL.md`**

```markdown
---
name: expand-lore
description: Mở rộng một ý tưởng raw của người dùng thành lore hoàn chỉnh cho thế giới tiểu thuyết (world-building, hệ thống, phe phái, lịch sử, địa lý). Dùng khi người dùng đưa ý tưởng mới hoặc khởi tạo dự án. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Expand Lore

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/expand-lore story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>` cho các bước sau.

## Bước 1 — Nhận ý tưởng raw
Đọc ý tưởng raw người dùng cung cấp trong tin nhắn hiện tại (thể loại, nhân vật chính, bối cảnh sơ bộ, hoặc chỉ một câu ý tưởng ngắn).

## Bước 2 — Đọc lore hiện có để không mâu thuẫn
Đọc toàn bộ `<story>/lore/world-overview.md`, `<story>/lore/systems.md`, `<story>/lore/factions.md`, `<story>/lore/geography.md`, `<story>/lore/history.md` nếu đã có nội dung thực (khác "(chưa xác định)"/"(chưa có)").

## Bước 3 — Sáng tạo mở rộng
Từ ý tưởng raw, phát triển đầy đủ các khía cạnh còn thiếu:
- Bối cảnh tổng thể, thể loại, tone, chủ đề cốt lõi → `<story>/lore/world-overview.md`
- Hệ thống phép thuật/công nghệ/luật lệ vận hành thế giới → `<story>/lore/systems.md`
- Các phe phái/tổ chức lớn → `<story>/lore/factions.md`
- Địa lý, địa danh chính → `<story>/lore/geography.md`
- Lịch sử/quá khứ ảnh hưởng đến hiện tại → `<story>/lore/history.md`
- Cấu trúc Act và ý tưởng gốc → `<story>/plot/outline.md`

## Bước 4 — Trình bày cho người dùng duyệt
Tóm tắt toàn bộ phần lore vừa mở rộng ngay trong hội thoại, hỏi người dùng có muốn chỉnh sửa gì trước khi ghi chính thức vào file không.

## Bước 5 — Ghi vào file sau khi được duyệt
Cập nhật các file lore và `plot/outline.md` tương ứng với nội dung đã được duyệt. Nếu `<story>/STATE.md` vẫn còn ở trạng thái khởi tạo, cập nhật các trường liên quan (arc hiện tại, mục tiêu ngắn hạn) để chuẩn bị cho `/next-chapter`.
```

- [ ] **Step 2: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/.claude/skills/expand-lore/SKILL.md`
Expected: nội dung khớp như trên.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add .claude/skills/expand-lore/
git commit -m "feat: add /expand-lore skill"
```

---

### Task 13: Skill `/new-story`

**Files:**
- Create: `.claude/skills/new-story/SKILL.md`

- [ ] **Step 1: Tạo `.claude/skills/new-story/SKILL.md`**

```markdown
---
name: new-story
description: Tạo 1 dự án tiểu thuyết mới trong workspace bằng cách nhân bản _template-story/ thành story-<ten>/, và cập nhật CLAUDE.MD. Dùng khi người dùng muốn bắt đầu 1 cuốn tiểu thuyết mới độc lập với các dự án hiện có.
---

# New Story

## Bước 1 — Xác định tên
Nhận tên story từ tham số lệnh (vd `/new-story 2` → thư mục `story-2`). Nếu không có tham số, hỏi người dùng tên/số thứ tự muốn dùng.

## Bước 2 — Kiểm tra chưa tồn tại
Kiểm tra thư mục `story-<ten>/` chưa tồn tại hoặc đang rỗng trước khi ghi đè. Nếu đã có nội dung, dừng lại và hỏi người dùng.

## Bước 3 — Nhân bản template
Copy toàn bộ nội dung `_template-story/` thành `story-<ten>/`, giữ nguyên cấu trúc thư mục con và nội dung mẫu, không tự ý sửa nội dung template trong bước này.

## Bước 4 — Cập nhật `CLAUDE.MD`
Thêm 1 dòng vào bảng "Các dự án hiện có" trong `CLAUDE.MD` gốc: `| story-<ten>/ | Chưa khởi tạo | Mới tạo |`.

## Bước 5 — Hỏi người dùng có muốn chuyển active sang story mới
Nếu có, cập nhật nội dung `ACTIVE-STORY.md` thành `story-<ten>`. Nếu không, giữ nguyên story đang active.

## Bước 6 — Đề nghị bước tiếp theo
Nhắc người dùng cung cấp ý tưởng raw cho dự án mới và chạy `/expand-lore story-<ten>` để khởi tạo lore trước khi dùng `/next-chapter`.
```

- [ ] **Step 2: Verify**

Run: `cat /Users/mac2605005/Desktop/writting-prompt/.claude/skills/new-story/SKILL.md`
Expected: nội dung khớp như trên.

- [ ] **Step 3: Commit**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git add .claude/skills/new-story/
git commit -m "feat: add /new-story skill"
```

---

### Task 14: Verify toàn hệ thống end-to-end

**Files:** (không tạo mới — chỉ kiểm tra toàn bộ)

- [ ] **Step 1: Kiểm tra toàn bộ cây thư mục workspace**

Run: `find /Users/mac2605005/Desktop/writting-prompt -type f \( -name "*.md" -o -name "*.MD" \) | grep -v "/.git/" | sort`
Expected: liệt kê đủ:
```
ACTIVE-STORY.md
CLAUDE.MD
_template-story/STATE.md
_template-story/chapters/README.md
_template-story/characters/_index.md
_template-story/characters/_template.md
_template-story/lore/factions.md
_template-story/lore/geography.md
_template-story/lore/history.md
_template-story/lore/systems.md
_template-story/lore/world-overview.md
_template-story/plot/outline.md
_template-story/plot/threads.md
_template-story/style/style-guide.md
_template-story/summaries/arc-summaries.md
_template-story/summaries/chapter-summaries.md
_template-story/timeline/timeline.md
story-1/STATE.md
story-1/chapters/README.md
story-1/characters/_index.md
story-1/characters/_template.md
story-1/lore/factions.md
story-1/lore/geography.md
story-1/lore/history.md
story-1/lore/systems.md
story-1/lore/world-overview.md
story-1/plot/outline.md
story-1/plot/threads.md
story-1/style/style-guide.md
story-1/summaries/arc-summaries.md
story-1/summaries/chapter-summaries.md
story-1/timeline/timeline.md
```

- [ ] **Step 2: Kiểm tra 3 skill đã đăng ký đúng vị trí**

Run: `find /Users/mac2605005/Desktop/writting-prompt/.claude/skills -name "SKILL.md"`
Expected:
```
.../.claude/skills/next-chapter/SKILL.md
.../.claude/skills/expand-lore/SKILL.md
.../.claude/skills/new-story/SKILL.md
```

- [ ] **Step 3: Kiểm tra mọi đường dẫn nhắc trong CLAUDE.MD đều tồn tại thật**

Run: `grep -oE '`[a-zA-Z0-9_/.<>-]+\.md`' /Users/mac2605005/Desktop/writting-prompt/CLAUDE.MD | tr -d '`' | grep -v '<story>' | while read f; do test -e "/Users/mac2605005/Desktop/writting-prompt/$f" && echo "OK $f" || echo "MISSING $f"; done`
Expected: mọi dòng đều `OK ...`, không có `MISSING`.

- [ ] **Step 4: Kiểm tra git log đầy đủ các commit theo từng task**

Run: `git -C /Users/mac2605005/Desktop/writting-prompt log --oneline`
Expected: 13 commit tương ứng 13 task trên (từ "scaffold directory structure" đến "add /new-story skill").

- [ ] **Step 5: Commit cuối (nếu Step 3 phát hiện lệch, sửa rồi mới commit)**

```bash
cd /Users/mac2605005/Desktop/writting-prompt
git status
```
Expected: `nothing to commit, working tree clean` (nếu có thay đổi từ bước sửa lỗi ở Step 3, add + commit với message `fix: correct path references in CLAUDE.MD`).

---

## Sau khi hoàn thành plan này

Hệ thống đã sẵn sàng để:
1. Người dùng cung cấp ý tưởng raw cho `story-1` trong hội thoại.
2. Chạy `/expand-lore` để AI sáng tạo lore hoàn chỉnh từ ý tưởng đó.
3. Chạy `/next-chapter` để sinh từng chương một (mặc định 1 chương/lần), duyệt, rồi lặp lại.
4. Khi cần bắt đầu `story-2`, chạy `/new-story story-2`.
