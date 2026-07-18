# Story Pipeline v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Triển khai Story Pipeline v2 theo spec `docs/superpowers/specs/2026-07-19-story-pipeline-v2-design.md`: 2 skill mới (`/story-skeleton`, `/plan-arc`), viết lại 2 skill (`/expand-lore`, `/next-chapter`), tái cấu trúc `_template-story/` theo mô hình index + per-entity, cập nhật `CLAUDE.MD`, tạo `README.md`.

**Architecture:** Toàn bộ dự án là markdown (không có code chạy). Mỗi task = ghi file markdown + kiểm chứng bằng lệnh shell (find/grep) + commit. Template `_template-story/` là "schema" của mọi story mới; 4 SKILL.md là "logic"; CLAUDE.MD + README.md là tài liệu điều phối. Thứ tự task: template trước (skills tham chiếu đường dẫn trong template), skills sau, tài liệu cuối, chốt bằng task kiểm tra chéo.

**Tech Stack:** Markdown, Claude Code skills (`.claude/skills/*/SKILL.md`), bash để kiểm chứng.

**Lưu ý chung cho mọi task:**
- Workspace: `/Users/mac2605005/Desktop/writting-prompt`. Mọi đường dẫn dưới đây tương đối từ gốc này.
- File hướng dẫn dự án tên là `CLAUDE.MD` (chữ hoa), không phải `CLAUDE.md`.
- KHÔNG đụng vào `story-1/`, `story-2/`, `web/` — ngoài phạm vi.
- Commit message tiếng Việt theo kiểu conventional đang dùng trong repo (`feat(...)`, `docs(...)`), kết bằng dòng `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.

---

## Task 1: Tái cấu trúc `_template-story/lore/`

**Files:**
- Delete: `_template-story/lore/systems.md`, `_template-story/lore/factions.md`, `_template-story/lore/geography.md`
- Create: `_template-story/lore/systems/_index.md`, `_template-story/lore/systems/_template.md`, `_template-story/lore/factions/_index.md`, `_template-story/lore/factions/_template.md`, `_template-story/lore/geography/_index.md`, `_template-story/lore/geography/_template.md`, `_template-story/lore/conflict-engines.md`, `_template-story/lore/daily-life.md`
- Modify: `_template-story/lore/world-overview.md` (thay toàn bộ nội dung)
- Keep nguyên: `_template-story/lore/raw-idea.md`, `_template-story/lore/history.md`

- [ ] **Step 1: Xóa 3 file lore gộp cũ**

```bash
git rm _template-story/lore/systems.md _template-story/lore/factions.md _template-story/lore/geography.md
```

- [ ] **Step 2: Ghi `_template-story/lore/world-overview.md`** (thay toàn bộ nội dung cũ):

```markdown
# World Overview

> File này giữ NHỎ có chủ đích — chỉ tổng quan + con trỏ tới các mảng chi tiết. Không viết chi tiết phe/địa danh/hệ thống vào đây.

- **Tên thế giới / bối cảnh:** (chưa xác định)
- **Thể loại (fantasy/sci-fi/hiện đại/...):** (chưa xác định)
- **Tổng quan 1 đoạn:** (chưa xác định)
- **Chủ đề/tinh thần cốt lõi của câu chuyện:** (chưa xác định)
- **Tone sơ bộ:** (chưa xác định — tone CHÍNH THỨC do `/story-skeleton` chốt trong `../style/style-guide.md`)

## Con trỏ tới các mảng chi tiết
| Mảng | Nơi đọc |
|---|---|
| Hệ thống sức mạnh / luật lệ | `systems/_index.md` |
| Phe phái / tổ chức | `factions/_index.md` |
| Địa lý / địa danh | `geography/_index.md` |
| Lịch sử | `history.md` |
| Đời sống thường dân | `daily-life.md` |
| Động cơ xung đột của thế giới | `conflict-engines.md` |
```

- [ ] **Step 3: Ghi `_template-story/lore/systems/_index.md`**

```markdown
# Hệ Thống — Index

> Mỗi hệ thống sức mạnh/luật lệ lớn có 1 file riêng trong thư mục này (tên file = slug kebab-case, dùng `_template.md` làm khuôn). AI đọc index này trước, CHỈ mở file chi tiết của hệ thống xuất hiện trong beat chương đang viết.

| Slug | Tên hệ thống | Tóm tắt 1 dòng | Trạng thái |
|---|---|---|---|
| (chưa có) | | | |
```

- [ ] **Step 4: Ghi `_template-story/lore/systems/_template.md`**

```markdown
---
loại: hệ-thống
trạng-thái: đang-hoạt-động
xuất-hiện-đầu: (chương ...)
cập-nhật-cuối: (chương ...)
---

# [Tên Hệ Thống]

- **Nguyên lý hoạt động:**
- **Chi phí / giới hạn khi sử dụng:**
- **Lỗ hổng khai thác được (nguồn kịch tính — BẮT BUỘC có):**
- **Ai dùng được, ai không:**
- **Câu hỏi công khai (điều thế giới CHƯA biết — đáp án nằm trong `../../plot/secrets/`, KHÔNG ghi ở đây):**

## Diễn biến qua các chương
| Chương | Thông tin mới được thiết lập |
|---|---|
```

- [ ] **Step 5: Ghi `_template-story/lore/factions/_index.md`**

```markdown
# Phe Phái — Index

> Mỗi phe 1 file riêng (slug kebab-case, khuôn `_template.md`). AI đọc index + bảng quan hệ trước, CHỈ mở file chi tiết của phe xuất hiện trong beat chương đang viết.

| Slug | Tên phe | Tóm tắt 1 dòng | Trạng thái |
|---|---|---|---|
| (chưa có) | | | |

## Bảng quan hệ phe-phe
> 1 dòng cho mỗi cặp phe có tương tác đáng kể. Chi tiết nằm trong file từng phe.

| Phe A | Phe B | Quan hệ hiện tại |
|---|---|---|
```

- [ ] **Step 6: Ghi `_template-story/lore/factions/_template.md`**

```markdown
---
loại: phe-phái
trạng-thái: đang-hoạt-động
xuất-hiện-đầu: (chương ...)
cập-nhật-cuối: (chương ...)
---

# [Tên Phe]

- **Lãnh đạo (tên riêng + tính cách — CẤM để "(chưa xác định)"):**
- **Mục tiêu công khai:**
- **Mục tiêu ngầm:**
- **Nguồn lực (quân sự / tài chính / thông tin / tôn giáo...):**
- **Mâu thuẫn nội bộ:**
- **Quan hệ với từng phe khác:**

## Diễn biến qua các chương
| Chương | Hành động / thay đổi |
|---|---|
```

- [ ] **Step 7: Ghi `_template-story/lore/geography/_index.md`**

```markdown
# Địa Lý — Index

> Địa danh CHÍNH có file riêng (slug kebab-case, khuôn `_template.md`); địa danh phụ chỉ cần 1 dòng trong bảng này (cột File để trống). AI chỉ mở file chi tiết của địa danh xuất hiện trong beat.

| Slug | Địa danh | Tóm tắt 1 dòng | File chi tiết |
|---|---|---|---|
| (chưa có) | | | |
```

- [ ] **Step 8: Ghi `_template-story/lore/geography/_template.md`**

```markdown
---
loại: địa-danh
trạng-thái: đang-tồn-tại
xuất-hiện-đầu: (chương ...)
cập-nhật-cuối: (chương ...)
---

# [Tên Địa Danh]

- **Đặc trưng kinh tế / văn hóa:**
- **Chất liệu cảm quan (mùi, âm thanh, ánh sáng đặc trưng — tối thiểu 2 chi tiết):**
- **Vai trò trong truyện:**
- **Phe phái hiện diện:**

## Diễn biến qua các chương
| Chương | Sự kiện tại đây |
|---|---|
```

- [ ] **Step 9: Ghi `_template-story/lore/conflict-engines.md`**

```markdown
# Động Cơ Xung Đột (Conflict Engines)

> Tối thiểu 3 mâu thuẫn CẤU TRÚC của thế giới — tự sinh chuyện kể cả khi nhân vật chính đứng yên. `/plan-arc` rút "world turn" mỗi arc từ các engine này. `/expand-lore` bắt buộc điền đủ ≥3 engine.

## Engine 1: [Tên ngắn gọn]
- **Hai bên:**
- **Vật tranh chấp:**
- **Vì sao không thể thỏa hiệp:**
- **Leo thang ra sao nếu không ai can thiệp:**

## Engine 2: [Tên ngắn gọn]
- **Hai bên:**
- **Vật tranh chấp:**
- **Vì sao không thể thỏa hiệp:**
- **Leo thang ra sao nếu không ai can thiệp:**

## Engine 3: [Tên ngắn gọn]
- **Hai bên:**
- **Vật tranh chấp:**
- **Vì sao không thể thỏa hiệp:**
- **Leo thang ra sao nếu không ai can thiệp:**
```

- [ ] **Step 10: Ghi `_template-story/lore/daily-life.md`**

```markdown
# Đời Sống Thường Dân

> Kho chất liệu texture cho chương: thường dân ăn gì, thờ gì, sợ gì, tiền tệ, luật lệ, tục lệ. Chia mục theo vùng văn hóa. `/next-chapter` lấy chi tiết cảm quan từ đây và `geography/` — mỗi chương phải có texture đời sống, không chỉ thoại.

## Vùng: [Tên vùng văn hóa]
- **Ăn uống:**
- **Tín ngưỡng / thờ cúng:**
- **Nỗi sợ phổ biến:**
- **Tiền tệ / mua bán:**
- **Luật lệ / tục lệ đáng chú ý:**

(lặp lại format trên cho từng vùng văn hóa lớn)
```

- [ ] **Step 11: Kiểm chứng cấu trúc lore mới**

Run: `find _template-story/lore -type f | sort`
Expected — đúng 11 file, không còn `lore/systems.md`, `lore/factions.md`, `lore/geography.md` dạng file đơn:
```
_template-story/lore/conflict-engines.md
_template-story/lore/daily-life.md
_template-story/lore/factions/_index.md
_template-story/lore/factions/_template.md
_template-story/lore/geography/_index.md
_template-story/lore/geography/_template.md
_template-story/lore/history.md
_template-story/lore/raw-idea.md
_template-story/lore/systems/_index.md
_template-story/lore/systems/_template.md
_template-story/lore/world-overview.md
```

- [ ] **Step 12: Commit**

```bash
git add _template-story/lore && git commit -m "feat(template): tái cấu trúc lore theo mô hình index + per-entity

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 2: Tái cấu trúc `_template-story/plot/`

**Files:**
- Delete: `_template-story/plot/outline.md`
- Create: `_template-story/plot/story-skeleton.md`, `_template-story/plot/secrets/_index.md`, `_template-story/plot/secrets/_template.md`, `_template-story/plot/threads-archive.md`, `_template-story/plot/arc-plans/_template.md`
- Modify: `_template-story/plot/threads.md` (thay câu ghi chú)

- [ ] **Step 1: Xóa outline cũ**

```bash
git rm _template-story/plot/outline.md
```

- [ ] **Step 2: Ghi `_template-story/plot/story-skeleton.md`**

```markdown
# Xương Sống Toàn Truyện (Story Skeleton)

> Sinh 1 LẦN bởi `/story-skeleton` sau khi lore được duyệt. Chỉ sửa khi người dùng chủ động đổi hướng lớn (qua đề xuất của `/plan-arc` Phần A). `/plan-arc` bám file này khi lên kế hoạch từng arc.

## Kết thúc đã chốt
(2-3 đoạn: cảnh kết + trạng thái thế giới và từng nhân vật chính lúc đó — cụ thể, không "sẽ tính sau")

## Cấu trúc 3 Act
- **Act 1:** (chưa xác định) — **Bước ngoặt chuyển Act 2:** (chưa xác định)
- **Act 2:** (chưa xác định) — **Bước ngoặt chuyển Act 3:** (chưa xác định)
- **Act 3:** (chưa xác định)

## Danh sách arc dự kiến (~8-15 arc, mỗi arc ~10-15 chương)
| Arc | Chương (ước) | Mục tiêu tự sự | Xung đột chính | Thay đổi khi arc đóng | Bí ẩn tiến triển |
|---|---|---|---|---|---|

## Đích đến nhân vật chính
| Nhân vật | Họ là ai ở cuối truyện |
|---|---|

## Lịch trả bí ẩn
| Bí ẩn (slug trong `secrets/`) | Arc hé lộ từng phần | Arc trả trọn |
|---|---|---|
```

- [ ] **Step 3: Ghi `_template-story/plot/secrets/_index.md`**

```markdown
# Sổ Bí Mật — Index

> CHỈ AI ĐỌC khi lên kế hoạch và viết chương. KHÔNG BAO GIỜ trích nguyên văn vào chương. KHÔNG reveal vượt lịch. Mỗi bí ẩn 1 file riêng (slug kebab-case, khuôn `_template.md`).

| Slug | Câu hỏi công khai | Trạng thái (chưa hé / hé một phần / đã trả trọn) | Arc dự kiến trả trọn |
|---|---|---|---|
| (chưa có) | | | |
```

- [ ] **Step 4: Ghi `_template-story/plot/secrets/_template.md`**

```markdown
# Bí ẩn: [Câu hỏi công khai]

- **Đáp án thật (đầy đủ, viết sẵn từ ngày 0):**
- **Ai biết gì (nhân vật nào nắm mảnh nào của sự thật):**
- **Lịch reveal (arc nào hé phần nào, trả trọn ở arc nào):**
- **Foreshadow cần gieo:**
  - [ ] (chi tiết cần cài — chương dự kiến gieo)

## Nhật ký reveal thực tế
| Chương | Phần đã hé lộ |
|---|---|
```

- [ ] **Step 5: Ghi `_template-story/plot/threads.md`** (thay toàn bộ nội dung):

```markdown
# Plot Threads Tracker — CHỈ THREAD ĐANG MỞ

> AI PHẢI đọc file này trước khi viết chương mới và PHẢI cập nhật sau khi chương được duyệt. File này CHỈ chứa thread đang mở — thread vừa đóng phải chuyển ngay sang `threads-archive.md` (giữ file này nhỏ để đọc mỗi chương).

| Thread | Mở ở chương | Trạng thái | Dự kiến trả (chương) | Ghi chú |
|---|---|---|---|---|
```

- [ ] **Step 6: Ghi `_template-story/plot/threads-archive.md`**

```markdown
# Threads Đã Đóng (Archive)

> Thread đã giải quyết được chuyển từ `threads.md` sang đây. AI KHÔNG cần đọc file này mỗi chương — chỉ tra khi cần kiểm tra lịch sử một tuyến truyện cũ.

| Thread | Mở ở chương | Đóng ở chương | Cách giải quyết |
|---|---|---|---|
```

- [ ] **Step 7: Ghi `_template-story/plot/arc-plans/_template.md`**

```markdown
# Arc NN: [Tên Arc]

> Sinh bởi `/plan-arc` (đổi tên file thành `arc-NN.md`, NN = 2 chữ số). Beat là KIM CHỈ NAM, không phải xiềng xích: `/next-chapter` được lệch dàn cảnh nhưng PHẢI giữ "Điểm kết chương"; muốn lệch cả điểm kết → hỏi người dùng trước.

- **Khớp mục skeleton:** (arc nào trong `../story-skeleton.md`)
- **Trạng thái mở đầu arc:**
- **Trạng thái khi arc đóng:**

## Nhìn lại arc trước (bỏ qua nếu là arc 1)
- **Lệch so với beat kế hoạch:**
- **Tone drift so với anchor sample:**
- **Threads bị bỏ quên:**
- **Nhân vật giậm chân so với đích skeleton:**

## World turn (các phe làm gì offscreen trong arc này)
| Phe | Đang làm gì | Có thể rò rỉ vào chương qua (tin đồn / giá cả / quân lính / nhân vật phụ...) |
|---|---|---|

## Bí ẩn trong arc
| Secret (slug) | Reveal phần nào trong arc này | Foreshadow gieo ở chương |
|---|---|---|

## Beat từng chương
(lặp format dưới đây cho TỪNG chương của arc)

### Chương N: [tên tạm]
- **Mục tiêu chương:**
- **Xung đột / trở ngại:**
- **Bước ngoặt / thông tin mới:**
- **Thread tiến/đóng:**
- **Cảm xúc chủ đạo:**
- **Xuất hiện:** nhân vật: ... | phe: ... | địa danh: ... | hệ thống: ...
- **Điểm kết chương (bắt buộc giữ):**
- **Trạng thái beat:** chưa viết
```

- [ ] **Step 8: Kiểm chứng**

Run: `find _template-story/plot -type f | sort`
Expected:
```
_template-story/plot/arc-plans/_template.md
_template-story/plot/secrets/_index.md
_template-story/plot/secrets/_template.md
_template-story/plot/story-skeleton.md
_template-story/plot/threads-archive.md
_template-story/plot/threads.md
```

- [ ] **Step 9: Commit**

```bash
git add _template-story/plot && git commit -m "feat(template): thêm story-skeleton, secrets, arc-plans, threads-archive vào plot

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 3: Cập nhật `_template-story/` — timeline, summaries, style, characters

**Files:**
- Create: `_template-story/timeline/world-events.md`, `_template-story/summaries/chapters/README.md`
- Delete: `_template-story/summaries/chapter-summaries.md`
- Modify: `_template-story/style/style-guide.md` (thay toàn bộ), `_template-story/characters/_template.md` (thêm header), `_template-story/summaries/arc-summaries.md` (sửa câu tham chiếu outline)

- [ ] **Step 1: Ghi `_template-story/timeline/world-events.md`**

```markdown
# Sự Kiện Thế Giới Offscreen

> Thế giới chuyển động ngoài tầm nhìn nhân vật chính. `/plan-arc` thêm mục "## Arc NN" khi plan arc mới; `/next-chapter` CHỈ đọc mục của arc hiện tại, và điền cột "Đã lộ" khi sự kiện rò rỉ vào chương.

## Arc NN
| Phe / thế lực | Sự kiện offscreen | Đã lộ vào chương nào (nếu có) |
|---|---|---|
```

- [ ] **Step 2: Xóa file tóm tắt gộp cũ và tạo cấu trúc chia theo arc**

```bash
git rm _template-story/summaries/chapter-summaries.md
```

Ghi `_template-story/summaries/chapters/README.md`:

```markdown
# Tóm Tắt Chương — Chia Theo Arc

- Mỗi arc 1 file: `arc-01.md`, `arc-02.md`, ... (khớp số arc trong `../../plot/arc-plans/`). `/plan-arc` tạo file rỗng khi mở arc mới.
- Sau khi 1 chương được duyệt, thêm mục `## Chương N` (150-250 từ: sự kiện chính + thay đổi trạng thái nhân vật) vào CUỐI file arc hiện tại.
- AI chỉ đọc file arc hiện tại (2-3 mục cuối) trước khi viết chương mới; bức tranh dài hạn đọc `../arc-summaries.md`.
```

- [ ] **Step 3: Sửa `_template-story/summaries/arc-summaries.md`** — thay câu ghi chú đầu file (tham chiếu `outline.md` đã xóa):

Nội dung mới toàn file:

```markdown
# Tóm Tắt Theo Arc

> Khi 1 arc trong `../plot/story-skeleton.md` kết thúc (hoặc chương chia hết cho 5), thêm 1 mục tóm tắt cấp cao (300-500 từ) gộp các tóm tắt chương của arc đó lại. Dùng để AI nắm bức tranh toàn cục mà không phải đọc lại hàng chục tóm tắt chương lẻ.

Format mỗi mục:

## Arc: [Tên arc] (Chương X-Y)
<tóm tắt 300-500 từ>
```

- [ ] **Step 4: Ghi `_template-story/style/style-guide.md`** (thay toàn bộ):

```markdown
# Style Guide

> Phần Tone & Giọng văn do `/story-skeleton` chốt (người dùng chọn từ 2-3 phương án kèm văn mẫu). `/next-chapter` PHẢI đọc lại Anchor Sample ngay trước khi viết và tự đối chiếu trước khi nộp chương.

## Thông số cơ bản
- **Thể loại:** (chưa xác định)
- **Ngôi kể (POV):** (chưa xác định — vd: ngôi thứ 3 giới hạn, ngôi thứ nhất...)
- **Thì:** (chưa xác định — vd: quá khứ, hiện tại)
- **Độ dài mỗi chương mục tiêu:** 2000-3000 từ (đếm thật, không ước lượng)
- **Quy cách format:** tiêu đề chương dạng "Chương N: [Tên chương]", đối thoại dùng dấu gạch ngang —

## Tone
- **Tâm tone (tonal center — tone tổng của cả bộ):** (chưa xác định)
- **Biên độ cho phép (cảnh được sáng/tối hơn tâm đến mức nào, trong tình huống nào):** (chưa xác định)

## Giọng văn
- **Giọng kể:** (chưa xác định)
- **Nhịp câu:** (chưa xác định)
- **Quy ước thoại:** (chưa xác định)
- **Điều cấm kỵ / cần tránh:** (chưa xác định)

## Anchor Samples (chuẩn đối chiếu văn phong — do `/story-skeleton` ghi từ phương án tone được chọn)

### Anchor 1
(chưa có)

### Anchor 2 (tùy chọn)
(chưa có)
```

- [ ] **Step 5: Sửa `_template-story/characters/_template.md`** — thêm header chuẩn lên ĐẦU file (giữ nguyên toàn bộ phần thân hiện có):

```markdown
---
loại: nhân-vật
trạng-thái: còn-sống
xuất-hiện-đầu: (chương ...)
cập-nhật-cuối: (chương ...)
---

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

- [ ] **Step 6: Kiểm chứng toàn bộ template**

Run: `find _template-story -type f -name "*.md" | sort`
Expected — đúng 26 file:
```
_template-story/STATE.md
_template-story/chapters/README.md
_template-story/characters/_index.md
_template-story/characters/_template.md
_template-story/lore/conflict-engines.md
_template-story/lore/daily-life.md
_template-story/lore/factions/_index.md
_template-story/lore/factions/_template.md
_template-story/lore/geography/_index.md
_template-story/lore/geography/_template.md
_template-story/lore/history.md
_template-story/lore/raw-idea.md
_template-story/lore/systems/_index.md
_template-story/lore/systems/_template.md
_template-story/lore/world-overview.md
_template-story/plot/arc-plans/_template.md
_template-story/plot/secrets/_index.md
_template-story/plot/secrets/_template.md
_template-story/plot/story-skeleton.md
_template-story/plot/threads-archive.md
_template-story/plot/threads.md
_template-story/style/style-guide.md
_template-story/summaries/arc-summaries.md
_template-story/summaries/chapters/README.md
_template-story/timeline/timeline.md
_template-story/timeline/world-events.md
```
Run thêm: `grep -rl "outline.md" _template-story/` → Expected: không có kết quả.

- [ ] **Step 7: Commit**

```bash
git add _template-story && git commit -m "feat(template): world-events, summaries theo arc, style-guide mở rộng tone/anchor, header nhân vật

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 4: Viết lại `.claude/skills/expand-lore/SKILL.md`

**Files:**
- Modify: `.claude/skills/expand-lore/SKILL.md` (thay toàn bộ nội dung)

- [ ] **Step 1: Ghi toàn bộ nội dung mới:**

```markdown
---
name: expand-lore
description: Mở rộng ý tưởng raw thành lore sâu 3 lớp (nền móng, chiều sâu từng mảng, động cơ xung đột) theo cấu trúc index + per-entity. Dùng khi khởi tạo dự án hoặc người dùng đưa ý tưởng mới. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md. Sau skill này chạy /story-skeleton.
---

# Expand Lore

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/expand-lore story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>`.

## Bước 1 — Nhận ý tưởng raw
Đọc `<story>/lore/raw-idea.md`. Nếu đã có nội dung thực, dùng làm đầu vào. Nếu trống, hỏi người dùng ý tưởng raw ngay trong hội thoại, ghi NGUYÊN VĂN câu trả lời vào `<story>/lore/raw-idea.md` trước khi sang Bước 2.

## Bước 2 — Đọc lore hiện có để không mâu thuẫn
Đọc `<story>/lore/world-overview.md`, `history.md`, `daily-life.md`, `conflict-engines.md`, và các `_index.md` trong `systems/`, `factions/`, `geography/` nếu đã có nội dung thực. Mở file chi tiết khi cần đối chiếu.

## Bước 3 — Sáng tạo mở rộng theo 3 LỚP (bắt buộc đủ từng lớp, soạn nháp trong hội thoại — CHƯA ghi file)

### Lớp 1 — Nền móng
- `world-overview.md`: thể loại, chủ đề, quy mô, tone sơ bộ. Giữ NHỎ, kèm bảng con trỏ (theo khuôn có sẵn trong template).
- `systems/`: mỗi hệ thống lớn 1 file theo `systems/_template.md` + 1 dòng trong `_index.md`. BẮT BUỘC mỗi hệ thống có: chi phí, giới hạn, và LỖ HỔNG khai thác được về mặt kịch tính.
- `history.md`: các thời kỳ + 3-5 sự kiện lịch sử, mỗi sự kiện ghi rõ hệ quả còn sống đến hiện tại.

### Lớp 2 — Chiều sâu từng mảng
- `factions/`: mỗi phe 1 file theo `factions/_template.md`. BẮT BUỘC: lãnh đạo có tên riêng + tính cách; mục tiêu công khai VÀ mục tiêu ngầm; nguồn lực; mâu thuẫn nội bộ; quan hệ với từng phe khác. CẤM "(chưa xác định)" ở trường then chốt. Điền bảng quan hệ phe-phe trong `_index.md`.
- `geography/`: địa danh chính 1 file theo `geography/_template.md` (đặc trưng kinh tế/văn hóa + tối thiểu 2 chi tiết cảm quan: mùi, âm thanh, ánh sáng); địa danh phụ chỉ 1 dòng trong `_index.md`.
- `daily-life.md`: theo từng vùng văn hóa: ăn uống, tín ngưỡng, nỗi sợ, tiền tệ, luật lệ, tục lệ.

### Lớp 3 — Động cơ xung đột
- `conflict-engines.md`: TỐI THIỂU 3 engine. Mỗi engine: hai bên, vật tranh chấp, vì sao không thể thỏa hiệp, leo thang ra sao nếu không ai can thiệp.

## Bước 4 — Quy tắc bí mật (BẮT BUỘC)
Sự thật ẩn của thế giới KHÔNG được ghi vào lore công khai. Lore chỉ ghi "câu hỏi công khai" (điều thế giới đang thắc mắc). Liệt kê riêng trong hội thoại danh sách: câu hỏi công khai + phác thảo đáp án — để `/story-skeleton` dùng làm đầu vào cho `plot/secrets/`. KHÔNG ghi phác thảo đáp án vào bất kỳ file lore nào.

## Bước 5 — Tự kiểm trước khi trình duyệt
- [ ] Không còn "(chưa xác định)" ở trường then chốt (lãnh đạo phe, nguyên lý + lỗ hổng hệ thống, nguyên nhân sự kiện lịch sử lớn)
- [ ] ≥3 conflict engines đầy đủ 4 trường
- [ ] Mỗi hệ thống có lỗ hổng kịch tính; mỗi phe có mục tiêu ngầm
- [ ] Mỗi địa danh chính có ≥2 chi tiết cảm quan
- [ ] Không đáp án bí mật nào nằm trong lore công khai

## Bước 6 — Trình bày cho người dùng duyệt
Tóm tắt theo 3 lớp ngay trong hội thoại (kèm danh sách câu hỏi công khai của Bước 4), hỏi người dùng có muốn chỉnh gì trước khi ghi file.

## Bước 7 — Ghi vào file sau khi được duyệt
Ghi các file lore theo cấu trúc trên (slug kebab-case, file thực thể có header chuẩn: loại, trạng thái, xuất-hiện-đầu, cập-nhật-cuối). Nếu `<story>/STATE.md` còn ở trạng thái khởi tạo, cập nhật các trường liên quan. Kết thúc bằng lời nhắc: chạy `/story-skeleton <story>` để chốt tone + xương sống truyện trước khi viết chương.
```

- [ ] **Step 2: Kiểm chứng**

Run: `grep -c "Lớp" .claude/skills/expand-lore/SKILL.md`
Expected: 3 (3 heading "### Lớp 1/2/3" — lưu ý grep phân biệt hoa/thường nên "LỚP"/"lớp" không tính).
Run: `grep -l "story-skeleton" .claude/skills/expand-lore/SKILL.md`
Expected: in ra đường dẫn file (có tham chiếu bước tiếp theo).

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/expand-lore/SKILL.md && git commit -m "feat(skills): viết lại expand-lore — lore sâu 3 lớp, quality bar, quy tắc bí mật

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 5: Tạo `.claude/skills/story-skeleton/SKILL.md`

**Files:**
- Create: `.claude/skills/story-skeleton/SKILL.md`

- [ ] **Step 1: Ghi toàn bộ nội dung:**

```markdown
---
name: story-skeleton
description: Chốt tone/writing style cho cả bộ truyện (2-3 phương án kèm văn mẫu để người dùng chọn), dựng xương sống toàn truyện (kết thúc định trước, 3 act, danh sách arc, đích nhân vật, lịch trả bí ẩn) và sổ bí mật plot/secrets/. Chạy 1 lần sau khi /expand-lore được duyệt, trước /plan-arc. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Story Skeleton

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/story-skeleton story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>`.

## Bước 1 — Kiểm tra điều kiện
- Nếu lore còn trống (các `_index.md` chưa có thực thể nào) → dừng, nhắc chạy `/expand-lore <story>` trước.
- Nếu `<story>/plot/story-skeleton.md` đã có nội dung thực → hỏi người dùng có muốn làm lại không trước khi ghi đè.

## Bước 2 — Đọc bối cảnh
Đọc `<story>/lore/raw-idea.md`, toàn bộ lore (mọi `_index.md` VÀ mọi file chi tiết — đây là lần hiếm hoi đọc hết, vì skeleton phải nhất quán với toàn bộ thế giới), `characters/` nếu đã có. Lấy danh sách "câu hỏi công khai + phác thảo đáp án" từ hội thoại `/expand-lore` nếu còn; nếu không còn, tự rút các câu hỏi công khai từ lore.

**CHẾ ĐỘ VÀO GIỮA CHỪNG** (truyện đã có chương — vd story-1): đọc thêm toàn bộ `summaries/`, `plot/threads.md`, `STATE.md`, và lướt các chương đã viết. Skeleton dựng ra PHẢI khớp mọi sự kiện đã xảy ra — không được yêu cầu viết lại chương cũ.

## Bước 3 — Đề xuất Tone & Writing Style
Soạn 2-3 phương án, mỗi phương án gồm: tên gọi ngắn + mô tả 2-3 câu (tâm tone, giọng kể, nhịp câu) + **1 đoạn văn mẫu ~150 từ**. Cả 2-3 đoạn văn mẫu VIẾT CÙNG MỘT CẢNH (chọn 1 cảnh tiêu biểu từ raw-idea) để người dùng so trực tiếp. Người dùng chọn 1 (hoặc yêu cầu trộn).

## Bước 4 — Soạn xương sống toàn truyện (nháp trong hội thoại)
Theo đúng khuôn `<story>/plot/story-skeleton.md` trong template:
- Kết thúc đã chốt: 2-3 đoạn cụ thể (cảnh kết + trạng thái thế giới/từng nhân vật chính)
- 3 act + bước ngoặt chuyển act
- Danh sách ~8-15 arc (quy mô 100-200 chương), mỗi arc: chương ước lượng, mục tiêu tự sự, xung đột chính, thay đổi khi arc đóng, bí ẩn tiến triển
- Đích đến từng nhân vật chính
- Lịch trả bí ẩn (khớp Bước 5)

## Bước 5 — Soạn sổ bí mật
Mỗi bí ẩn 1 file `<story>/plot/secrets/<slug>.md` theo `secrets/_template.md`: đáp án thật đầy đủ, ai biết gì, lịch reveal, danh sách foreshadow cần gieo. Cập nhật `secrets/_index.md`.

## Bước 6 — Tự kiểm trước khi trình duyệt
- [ ] Kết thúc cụ thể, không có "sẽ tính sau"
- [ ] Mọi bí ẩn nhắc trong skeleton đều có file trong `secrets/` với đáp án đầy đủ
- [ ] Mọi arc đều có "thay đổi khi arc đóng" (không arc filler)
- [ ] Lịch trả bí ẩn phủ hết các bí ẩn, rải đều, không dồn hết về cuối
- [ ] Đích nhân vật nhất quán với triết lý cốt lõi trong raw-idea

## Bước 7 — Trình bày cho người dùng duyệt
Trình theo thứ tự: (1) 2-3 phương án tone kèm văn mẫu — chờ người dùng chọn; (2) tóm tắt skeleton; (3) danh sách bí ẩn (câu hỏi + đáp án tóm tắt 1 câu). Chờ duyệt toàn bộ. KHÔNG ghi file trước khi được duyệt.

## Bước 8 — Ghi file sau khi được duyệt
1. `<story>/style/style-guide.md`: điền đầy đủ theo phương án tone được chọn, gồm tâm tone, biên độ, giọng kể, nhịp câu, quy ước thoại, cấm kỵ, và 1-2 Anchor Sample (lấy chính đoạn văn mẫu của phương án được chọn).
2. `<story>/plot/story-skeleton.md`
3. `<story>/plot/secrets/` (index + từng file)
4. Cập nhật `<story>/STATE.md`: arc hiện tại = "Arc 01 (chưa plan)".
Kết thúc bằng lời nhắc: chạy `/plan-arc <story>` để lên beat chi tiết arc đầu tiên.
```

- [ ] **Step 2: Kiểm chứng**

Run: `grep -c "văn mẫu" .claude/skills/story-skeleton/SKILL.md`
Expected: ≥ 3.
Run: `grep -l "VÀO GIỮA CHỪNG" .claude/skills/story-skeleton/SKILL.md`
Expected: in ra đường dẫn file.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/story-skeleton/SKILL.md && git commit -m "feat(skills): thêm story-skeleton — tone kèm văn mẫu, xương sống toàn truyện, sổ bí mật

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 6: Tạo `.claude/skills/plan-arc/SKILL.md`

**Files:**
- Create: `.claude/skills/plan-arc/SKILL.md`

- [ ] **Step 1: Ghi toàn bộ nội dung:**

```markdown
---
name: plan-arc
description: Lên kế hoạch chi tiết 1 arc (~10-15 chương) gồm nhìn lại arc vừa xong (lệch beat, trôi tone, threads bỏ quên) và beat từng chương + world turn offscreen + lịch foreshadow cho arc mới. Chạy sau /story-skeleton (plan arc 1) và mỗi khi arc kết thúc. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Plan Arc

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/plan-arc story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>`.

## Bước 1 — Kiểm tra điều kiện & xác định số arc
- Nếu `<story>/plot/story-skeleton.md` còn trống → dừng, nhắc chạy `/story-skeleton <story>` trước.
- Số arc NN = số lớn nhất trong `<story>/plot/arc-plans/arc-*.md` + 1. Nếu người dùng yêu cầu replan arc hiện tại → dùng lại số đó và chỉ plan các chương chưa viết.

## Bước 2 — Đọc bối cảnh
1. `<story>/plot/story-skeleton.md` (toàn bộ)
2. `<story>/plot/secrets/_index.md` + mở file chi tiết của các secret có lịch reveal/foreshadow chạm arc này
3. `<story>/style/style-guide.md` (đặc biệt Anchor Samples)
4. `<story>/STATE.md`, `<story>/plot/threads.md`
5. `<story>/lore/conflict-engines.md`
6. Nếu không phải arc 1: arc plan trước (`arc-plans/arc-(NN-1).md`) + `summaries/chapters/arc-(NN-1).md` toàn bộ + 2-3 chương gần nhất trong `chapters/` (để soi tone)

## Bước 3 — Phần A: Nhìn lại arc vừa xong (BỎ QUA nếu arc 1)
- Đối chiếu từng chương đã viết với beat kế hoạch: lệch ở đâu, lệch đó hay hơn hay dở hơn
- Trôi tone: so văn 2-3 chương gần nhất với Anchor Sample — có vượt biên độ trong style guide không
- Threads nào mở quá lâu không tiến triển; nhân vật nào giậm chân so với đích trong skeleton
- Nếu truyện đã lệch LỚN khỏi skeleton → trình người dùng 2 lựa chọn: (a) kéo arc mới về lại skeleton, (b) cập nhật skeleton theo hướng mới. NGƯỜI DÙNG QUYẾT — skill không tự sửa `story-skeleton.md`.

## Bước 4 — Phần B: Soạn kế hoạch arc mới (nháp trong hội thoại)
Theo đúng khuôn `<story>/plot/arc-plans/_template.md`:
- Khớp mục nào trong skeleton; trạng thái mở đầu → trạng thái khi arc đóng
- **World turn:** mỗi phe lớn liên quan có ≥1 hành động offscreen trong arc (rút từ `conflict-engines.md`), kèm kênh rò rỉ khả dĩ vào chương
- **Bí ẩn trong arc:** secret nào reveal phần nào, foreshadow gieo ở chương nào (khớp lịch trong `secrets/`)
- **Beat từng chương** (~10-15 chương): đủ các trường trong khuôn, đặc biệt "Xuất hiện" (căn cứ để `/next-chapter` đọc chọn lọc) và "Điểm kết chương"
- Mỗi nhân vật chính tiến ≥1 bước về đích skeleton trong arc

## Bước 5 — Tự kiểm trước khi trình duyệt
- [ ] Mỗi chương có "Điểm kết chương" rõ ràng
- [ ] Mỗi beat ghi rõ nhân vật/phe/địa danh/hệ thống xuất hiện
- [ ] World turn có ≥1 hành động cho mỗi phe lớn liên quan tới arc
- [ ] Foreshadow khớp lịch secrets, không reveal vượt lịch
- [ ] Mỗi nhân vật chính tiến ≥1 bước về đích
- [ ] Chuỗi cảm xúc chủ đạo các chương có nhịp lên-xuống, không đơn điệu

## Bước 6 — Trình bày cho người dùng duyệt
Trình Phần A (nếu có) rồi Phần B ngay trong hội thoại. Chờ duyệt. KHÔNG ghi file trước khi được duyệt.

## Bước 7 — Ghi file sau khi được duyệt
1. `<story>/plot/arc-plans/arc-NN.md`
2. Thêm mục `## Arc NN` với bảng world turn vào `<story>/timeline/world-events.md`
3. Tạo file rỗng `<story>/summaries/chapters/arc-NN.md` (chỉ có dòng tiêu đề `# Tóm Tắt Chương — Arc NN`)
4. Cập nhật `<story>/STATE.md`: arc hiện tại = Arc NN
5. Nếu Phần A dẫn tới quyết định cập nhật skeleton → sửa `story-skeleton.md` đúng theo phương án người dùng đã chọn
Kết thúc bằng lời nhắc: chạy `/next-chapter <story>` để viết chương đầu của arc.
```

- [ ] **Step 2: Kiểm chứng**

Run: `grep -l "World turn" .claude/skills/plan-arc/SKILL.md && grep -l "NGƯỜI DÙNG QUYẾT" .claude/skills/plan-arc/SKILL.md`
Expected: in ra đường dẫn file 2 lần.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/plan-arc/SKILL.md && git commit -m "feat(skills): thêm plan-arc — nhìn lại arc cũ, beat từng chương, world turn

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 7: Viết lại `.claude/skills/next-chapter/SKILL.md`

**Files:**
- Modify: `.claude/skills/next-chapter/SKILL.md` (thay toàn bộ nội dung)

- [ ] **Step 1: Ghi toàn bộ nội dung mới:**

```markdown
---
name: next-chapter
description: Sinh chương tiếp theo bám beat trong arc plan hiện tại, đọc bối cảnh chọn lọc theo beat, phác dàn cảnh, viết, tự kiểm chất lượng (độ dài, số cảnh, tone, điểm kết) rồi mới trình duyệt. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Next Chapter

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/next-chapter story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>`.

## Bước 1 — Kiểm tra điều kiện (dừng và nhắc skill tương ứng nếu thiếu)
1. Lore trống hoặc `STATE.md` còn "(chưa xác định)" → nhắc `/expand-lore <story>`
2. `plot/story-skeleton.md` trống → nhắc `/story-skeleton <story>`
3. Không tìm thấy beat cho chương sắp viết trong `plot/arc-plans/` → nhắc `/plan-arc <story>`
Mặc định chỉ viết 1 chương mỗi lần chạy, kể cả khi người dùng không nói rõ số lượng.

## Bước 2 — Đọc bối cảnh CHỌN LỌC THEO BEAT (đúng thứ tự, không bỏ bước)
1. `<story>/STATE.md` — toàn bộ
2. `<story>/style/style-guide.md` — toàn bộ; đọc lại Anchor Sample NGAY TRƯỚC khi bắt đầu viết
3. Beat của chương sắp viết trong `<story>/plot/arc-plans/arc-NN.md` — NGUỒN CHỈ ĐẠO CHÍNH
4. `<story>/plot/threads.md` (file này chỉ chứa thread đang mở)
5. `<story>/plot/secrets/_index.md`; mở file chi tiết của secret có foreshadow/reveal trong arc này
6. `<story>/timeline/world-events.md` — CHỈ mục arc hiện tại; 10 dòng cuối `<story>/timeline/timeline.md`
7. `<story>/characters/_index.md` + file riêng của các nhân vật CÓ TRONG BEAT (mục "Xuất hiện")
8. Các `_index.md` trong `<story>/lore/systems|factions|geography/` + file chi tiết của thực thể CÓ TRONG BEAT; mục vùng liên quan trong `lore/daily-life.md`
9. `<story>/summaries/chapters/arc-NN.md` — 2-3 mục cuối

## Bước 3 — Phác dàn cảnh (nội bộ, không cần người dùng duyệt)
Từ beat → chia 2-4 cảnh. Mỗi cảnh: địa điểm, ai có mặt, căng thẳng gì, kết cảnh ra sao. Không được để cả chương chỉ 1 cảnh toàn thoại.

## Bước 4 — Viết chương
- Bám beat. Được lệch ở mức dàn cảnh nếu có ý hay hơn, nhưng PHẢI giữ "Điểm kết chương" trong beat. Muốn lệch cả điểm kết → DỪNG, hỏi người dùng trước.
- Tuân thủ style guide (tâm tone + biên độ) và cùng giọng với Anchor Sample
- Không mâu thuẫn `timeline/`, `characters/`; foreshadow đúng nội dung `secrets/`, KHÔNG reveal vượt lịch, KHÔNG trích nguyên văn secrets
- Dệt chi tiết cảm quan từ `geography/` và `daily-life.md`; rò rỉ world-events qua tin đồn/giá cả/nhân vật phụ khi hợp cảnh
- Kết chương bằng hook trỏ về beat chương kế (không bịa hook tự do)
- Lưu vào `<story>/chapters/chapter-NNN.md` (3 chữ số, số tiếp theo của file lớn nhất đang có)

## Bước 5 — TỰ KIỂM trước khi trình duyệt (fail mục nào tự sửa mục đó, sửa xong mới trình)
1. Độ dài 2000-3000 từ THẬT (đếm bằng lệnh, không ước lượng)
2. Có ≥2 cảnh; có chi tiết cảm quan lấy từ `geography/`/`daily-life.md`
3. Đúng "Điểm kết chương" mà beat yêu cầu
4. Tone trong biên độ; văn cùng giọng với Anchor Sample
5. Không mâu thuẫn timeline/characters; không reveal vượt lịch secrets
6. ≥1 thread tiến triển; hook cuối chương trỏ về beat chương kế

## Bước 6 — Trình bày cho người dùng duyệt
Đưa chương cho người dùng đọc trực tiếp trong hội thoại. KHÔNG thực hiện Bước 7 cho đến khi người dùng duyệt hoặc chỉnh sửa xong.

## Bước 7 — Sau khi được duyệt, cập nhật hệ thống (bắt buộc, đủ 10 mục, không bỏ mục nào)
1. Cập nhật `<story>/STATE.md` (chương hiện tại, POV, địa điểm, hook cuối chương, mục tiêu ngắn hạn)
2. Thêm dòng mới vào `<story>/timeline/timeline.md`
3. Thêm mục `## Chương N` vào `<story>/summaries/chapters/arc-NN.md`
4. Cập nhật `<story>/plot/threads.md` (mở thread mới / cập nhật tiến triển)
5. Thread vừa đóng → CẮT khỏi `threads.md`, dán sang `threads-archive.md` kèm chương đóng + cách giải quyết
6. Nếu số chương chia hết cho 5 hoặc arc vừa đóng → thêm mục vào `summaries/arc-summaries.md`
7. Nhân vật/phe/hệ thống/địa danh MỚI do AI sáng tạo trong chương → tạo ngay file riêng theo `_template.md` tương ứng (kèm header chuẩn) + thêm dòng vào `_index.md` tương ứng. Không được để thông tin mới chỉ nằm trong văn xuôi chương.
8. Đánh dấu beat của chương này trong `arc-plans/arc-NN.md`: "Trạng thái beat: đã viết" (+ ghi chú nếu có lệch dàn cảnh)
9. Nếu chương làm lộ sự kiện offscreen → điền cột "Đã lộ vào chương nào" trong `timeline/world-events.md`; nếu foreshadow/reveal secret → thêm dòng vào "Nhật ký reveal thực tế" của file secret đó
10. Nếu vừa viết chương cuối của arc → nhắc người dùng chạy `/plan-arc <story>` trước khi viết tiếp
```

- [ ] **Step 2: Kiểm chứng**

Run: `grep -c "Bước" .claude/skills/next-chapter/SKILL.md`
Expected: ≥ 8 (8 mục Bước 0-7).
Run: `grep -l "TỰ KIỂM" .claude/skills/next-chapter/SKILL.md && grep -l "Điểm kết chương" .claude/skills/next-chapter/SKILL.md`
Expected: in ra đường dẫn file 2 lần.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/next-chapter/SKILL.md && git commit -m "feat(skills): viết lại next-chapter — bám beat, đọc chọn lọc, dàn cảnh, tự kiểm 6 mục

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 8: Cập nhật `CLAUDE.MD` và `new-story/SKILL.md`

**Files:**
- Modify: `CLAUDE.MD` (thay toàn bộ nội dung)
- Modify: `.claude/skills/new-story/SKILL.md` (chỉ sửa Bước 6)

- [ ] **Step 1: Ghi toàn bộ `CLAUDE.MD` mới:**

```markdown
# Workspace: Quản Lý Nhiều Dự Án Tiểu Thuyết AI

## Vai trò
- AI (Claude) đóng vai **tác giả toàn quyền** cho từng dự án: viết toàn bộ nội dung chương, sáng tạo mở rộng lore từ ý tưởng raw của người dùng.
- Người dùng đóng vai **biên tập viên / người cấp ý tưởng**: đưa ý tưởng raw, duyệt hoặc yêu cầu chỉnh sửa — không tự viết văn.

## Các dự án hiện có
| Thư mục | Trạng thái | Ghi chú |
|---|---|---|
| `story-1/` | Đang phát triển | Dự án đầu tiên — còn cấu trúc cũ, chỉ migrate khi viết tiếp (xem README.md) |
| `story-2/` | Đang phát triển | Dark Fantasy, hệ thống Thú Ấn — chờ chạy pipeline v2 từ `/expand-lore` |

## Dự án đang active
Xem `ACTIVE-STORY.md`. Mọi skill mặc định thao tác trên dự án active, trừ khi người dùng chỉ định rõ thư mục khác (vd `/next-chapter story-2`).

## Flow chuẩn (Pipeline v2 — chi tiết xem README.md)
`/new-story <ten>` → người dùng điền `lore/raw-idea.md` → `/expand-lore` → `/story-skeleton` → `/plan-arc` → `/next-chapter` (×N, mỗi chương người dùng duyệt) → hết arc → `/plan-arc` → ... → kết thúc theo skeleton.

Bốn nguyên tắc xuyên suốt:
1. Không chương nào được viết mà không có beat định trước trong `plot/arc-plans/`.
2. Không bí ẩn nào thiếu lời giải viết sẵn trong `plot/secrets/`.
3. Mỗi tầng (lore → skeleton → arc plan → chương) là một điểm duyệt của người dùng.
4. `plot/secrets/` là tài liệu AI-only: không trích nguyên văn vào chương, không reveal vượt lịch.

## Quy tắc đọc file (BẮT BUỘC trước khi viết bất kỳ chương nào)
Đọc CHỌN LỌC THEO BEAT — thay `<story>` bằng thư mục dự án đang thao tác:
1. `<story>/STATE.md` — toàn bộ
2. `<story>/style/style-guide.md` — toàn bộ (đọc lại Anchor Sample ngay trước khi viết)
3. Beat chương sắp viết trong `<story>/plot/arc-plans/arc-NN.md` — nguồn chỉ đạo chính
4. `<story>/plot/threads.md` (chỉ chứa thread đang mở)
5. `<story>/plot/secrets/_index.md` + file secret active trong arc
6. `<story>/timeline/world-events.md` (mục arc hiện tại) + 10 dòng cuối `timeline.md`
7. `<story>/characters/_index.md` + file riêng nhân vật CÓ TRONG BEAT
8. `_index.md` của `lore/systems|factions|geography/` + file chi tiết thực thể CÓ TRONG BEAT + mục vùng liên quan trong `lore/daily-life.md`
9. `<story>/summaries/chapters/arc-NN.md` — 2-3 mục cuối

Nếu thiếu điều kiện: lore trống → `/expand-lore`; chưa có skeleton → `/story-skeleton`; chưa có beat → `/plan-arc`. Nếu `lore/raw-idea.md` cũng trống → hỏi người dùng ý tưởng raw trước.

## Quy tắc cập nhật (BẮT BUỘC sau khi 1 chương được người dùng duyệt)
1. Cập nhật `<story>/STATE.md`
2. Thêm dòng mới vào `<story>/timeline/timeline.md`
3. Thêm mục tóm tắt vào `<story>/summaries/chapters/arc-NN.md`
4. Cập nhật `<story>/plot/threads.md` (mở/tiến thread)
5. Thread vừa đóng → chuyển từ `threads.md` sang `threads-archive.md`
6. Chương chia hết cho 5 hoặc arc đóng → thêm mục vào `summaries/arc-summaries.md`
7. Nhân vật/phe/hệ thống/địa danh MỚI → file riêng theo `_template.md` tương ứng + dòng trong `_index.md`. Không để thông tin mới chỉ nằm trong văn xuôi chương.
8. Đánh dấu beat đã viết trong `arc-plans/arc-NN.md`
9. Cập nhật `world-events.md` (sự kiện đã lộ) và "Nhật ký reveal" trong file secret nếu chương có foreshadow/reveal
10. Chương cuối arc → nhắc người dùng chạy `/plan-arc`

Không bước nào được bỏ qua, kể cả khi chương "có vẻ không thay đổi gì nhiều".

## Số chương gen mỗi lần
Mặc định **1 chương / lần gọi** `/next-chapter` — mỗi chương là một điểm kiểm soát chất lượng. Chỉ viết nhiều hơn khi người dùng yêu cầu rõ ràng.

## Cấu trúc mỗi dự án (`story-N/`) — Pipeline v2
| Thư mục/file | Vai trò |
|---|---|
| `STATE.md` | Trạng thái truyện hiện tại — nguồn sự thật duy nhất |
| `lore/` | `world-overview.md` (nhỏ + con trỏ), `systems/` `factions/` `geography/` (mỗi thư mục: `_index.md` + file per-entity), `history.md`, `daily-life.md`, `conflict-engines.md`, `raw-idea.md` |
| `characters/` | `_index.md` + file riêng từng nhân vật (khuôn `_template.md`) |
| `plot/` | `story-skeleton.md` (xương sống toàn truyện), `secrets/` (sổ bí mật AI-only), `threads.md` (chỉ thread mở) + `threads-archive.md`, `arc-plans/arc-NN.md` |
| `timeline/` | `timeline.md` (1 dòng/chương) + `world-events.md` (offscreen, mục theo arc) |
| `chapters/` | `chapter-NNN.md` |
| `summaries/` | `chapters/arc-NN.md` (tóm tắt chương, mỗi arc 1 file) + `arc-summaries.md` |
| `style/` | `style-guide.md`: thông số + tâm tone + biên độ + Anchor Samples |

Quy ước: slug kebab-case làm ID ổn định; file thực thể mới có header chuẩn (loại, trạng-thái, xuất-hiện-đầu, cập-nhật-cuối).

## Skills
- `/new-story <ten>` — tạo dự án mới từ `_template-story/`
- `/expand-lore [story]` — mở rộng ý tưởng raw thành lore sâu 3 lớp
- `/story-skeleton [story]` — chốt tone (kèm văn mẫu) + xương sống toàn truyện + sổ bí mật (chạy 1 lần)
- `/plan-arc [story]` — nhìn lại arc cũ + beat từng chương arc mới + world turn (chạy đầu mỗi arc)
- `/next-chapter [story]` — viết 1 chương bám beat, tự kiểm chất lượng trước khi trình duyệt

## Template gốc
`_template-story/` chứa bộ file rỗng chuẩn cho 1 dự án mới. KHÔNG viết nội dung truyện trực tiếp vào đây — chỉ dùng làm khuôn khi tạo story mới qua `/new-story`.
```

- [ ] **Step 2: Sửa `.claude/skills/new-story/SKILL.md`** — thay riêng mục "## Bước 6 — Đề nghị bước tiếp theo" (giữ nguyên phần còn lại của file):

Nội dung cũ của mục này:
```markdown
## Bước 6 — Đề nghị bước tiếp theo
Nhắc người dùng cung cấp ý tưởng raw cho dự án mới và chạy `/expand-lore story-<ten>` để khởi tạo lore trước khi dùng `/next-chapter`.
```

Thay bằng:
```markdown
## Bước 6 — Đề nghị bước tiếp theo
Nhắc người dùng cung cấp ý tưởng raw cho dự án mới, rồi chạy theo thứ tự: `/expand-lore story-<ten>` → `/story-skeleton story-<ten>` → `/plan-arc story-<ten>` → `/next-chapter story-<ten>`. Không chạy `/next-chapter` khi chưa có arc plan.
```

- [ ] **Step 3: Kiểm chứng**

Run: `grep -c "plan-arc" CLAUDE.MD`
Expected: ≥ 4.
Run: `grep -l "story-skeleton" .claude/skills/new-story/SKILL.md`
Expected: in ra đường dẫn file.
Run: `grep -l "chapter-summaries.md" CLAUDE.MD`
Expected: không có kết quả (đường dẫn cũ đã bị thay hết).

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.MD .claude/skills/new-story/SKILL.md && git commit -m "docs: cập nhật CLAUDE.MD theo pipeline v2, new-story trỏ flow mới

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 9: Tạo `README.md` gốc workspace

**Files:**
- Create: `README.md`

- [ ] **Step 1: Ghi toàn bộ nội dung:**

````markdown
# Workspace Tiểu Thuyết AI — Hướng Dẫn Sử Dụng (Pipeline v2)

## Thứ tự dùng skill cho một truyện MỚI

```
1. /new-story <tên>          → tạo thư mục story-<tên>/ từ template
2. Điền ý tưởng raw          → ghi vào story-<tên>/lore/raw-idea.md (hoặc trả lời khi được hỏi)
3. /expand-lore <story>      → AI dựng lore sâu 3 lớp        → BẠN DUYỆT lore
4. /story-skeleton <story>   → AI đề xuất 2-3 tone kèm văn mẫu + xương sống toàn truyện + sổ bí mật
                                                             → BẠN CHỌN tone, DUYỆT skeleton
5. /plan-arc <story>         → AI lên beat từng chương của arc 1 + world turn
                                                             → BẠN DUYỆT arc plan
6. /next-chapter <story>     → AI viết 1 chương bám beat, tự kiểm rồi trình
                                                             → BẠN DUYỆT từng chương
   (lặp bước 6 cho tới hết arc ~10-15 chương)
7. Hết arc → quay lại /plan-arc (AI nhìn lại arc cũ + plan arc mới) → tiếp tục bước 6
   ... lặp 6-7 cho đến kết thúc đã định trong story-skeleton.md
```

## Bảng tra nhanh
| Skill | Khi nào chạy | Sinh ra | Bạn duyệt gì |
|---|---|---|---|
| `/new-story <tên>` | Bắt đầu truyện mới | Thư mục `story-<tên>/` | Tên + chuyển active |
| `/expand-lore [story]` | Sau khi có raw-idea | `lore/` đầy đủ 3 lớp | Toàn bộ lore |
| `/story-skeleton [story]` | 1 LẦN, sau khi lore duyệt | `style-guide.md` (tone + anchor), `plot/story-skeleton.md`, `plot/secrets/` | Chọn tone, duyệt skeleton + danh sách bí ẩn |
| `/plan-arc [story]` | Đầu MỖI arc (kể cả arc 1) | `plot/arc-plans/arc-NN.md`, mục world-events | Nhận xét arc cũ + beat arc mới |
| `/next-chapter [story]` | Mỗi chương | `chapters/chapter-NNN.md` | Nội dung chương |

## Quy tắc quan trọng
- Mặc định 1 chương / lần `/next-chapter` — mỗi chương là một điểm kiểm soát chất lượng.
- `plot/secrets/` là sổ bí mật AI-only: chứa đáp án mọi bí ẩn + lịch reveal. Đừng đọc nếu không muốn spoil chính mình.
- Muốn đổi hướng truyện giữa chừng: nói khi duyệt arc plan, hoặc yêu cầu replan (`/plan-arc` lại arc hiện tại). Đổi hướng LỚN → yêu cầu cập nhật `story-skeleton.md`.

## Truyện đang viết dở từ trước pipeline v2
- `story-1/` (10 chương, cấu trúc cũ): khi muốn viết tiếp, chạy `/story-skeleton story-1` — skill có chế độ vào-giữa-chừng, đọc chương đã có và dựng skeleton khớp; sau đó cần migrate cấu trúc thư mục (nhờ AI làm khi đó).
- `story-2/` (đã reset, có raw-idea): chạy từ bước 3 — `/expand-lore story-2`.
````

- [ ] **Step 2: Kiểm chứng**

Run: `grep -c "/plan-arc" README.md`
Expected: ≥ 3.

- [ ] **Step 3: Commit**

```bash
git add README.md && git commit -m "docs: thêm README hướng dẫn thứ tự dùng skill pipeline v2

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

## Task 10: Kiểm tra chéo tổng thể

**Files:**
- Không tạo file mới; sửa bất kỳ file nào phát hiện lệch.

- [ ] **Step 1: Mọi đường dẫn template mà 4 SKILL.md nhắc tới phải tồn tại trong `_template-story/`**

```bash
for p in STATE.md style/style-guide.md plot/story-skeleton.md plot/secrets/_index.md plot/secrets/_template.md plot/threads.md plot/threads-archive.md plot/arc-plans/_template.md timeline/timeline.md timeline/world-events.md lore/raw-idea.md lore/world-overview.md lore/history.md lore/daily-life.md lore/conflict-engines.md lore/systems/_index.md lore/systems/_template.md lore/factions/_index.md lore/factions/_template.md lore/geography/_index.md lore/geography/_template.md characters/_index.md characters/_template.md summaries/arc-summaries.md summaries/chapters/README.md chapters/README.md; do
  [ -f "_template-story/$p" ] || echo "THIẾU: $p"
done
```
Expected: không in ra dòng "THIẾU" nào.

- [ ] **Step 2: Không còn tham chiếu tới file đã xóa**

```bash
grep -rn "plot/outline.md\|chapter-summaries.md" .claude/skills/ CLAUDE.MD README.md _template-story/ 2>/dev/null
```
Expected: không có kết quả. Nếu có → sửa dòng đó trỏ sang file mới tương ứng (`story-skeleton.md` / `summaries/chapters/arc-NN.md`).

- [ ] **Step 3: 4 skill + CLAUDE.MD nhất quán tên skill**

```bash
grep -o "/story-skeleton\|/plan-arc\|/expand-lore\|/next-chapter\|/new-story" CLAUDE.MD README.md | sort | uniq -c
```
Expected: cả 5 tên skill đều xuất hiện; không có biến thể sai tên (vd `/story-outline`, `/arc-plan`).

- [ ] **Step 4: Nếu có sửa gì ở Step 1-3 → commit**

```bash
git add -A && git commit -m "fix: đồng bộ tham chiếu chéo giữa skills, template và tài liệu

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```
(Nếu không có gì để sửa, bỏ qua commit này.)

- [ ] **Step 5: Báo cáo hoàn thành cho người dùng**

Tóm tắt: các file đã tạo/sửa, và nhắc bước tiếp theo của NGƯỜI DÙNG: chạy `/expand-lore story-2` để bắt đầu pipeline v2 với raw-idea 523 dòng đang có.
```
