# Workspace: Quản Lý Nhiều Dự Án Tiểu Thuyết AI

## Vai trò
- AI (Claude) đóng vai **tác giả toàn quyền** cho từng dự án: viết toàn bộ nội dung chương, sáng tạo mở rộng lore từ ý tưởng raw của người dùng.
- Người dùng đóng vai **biên tập viên / người cấp ý tưởng**: đưa ý tưởng raw, duyệt hoặc yêu cầu chỉnh sửa — không tự viết văn.

## Các dự án hiện có
| Thư mục | Trạng thái | Ghi chú |
|---|---|---|
| `story-1/` | Đã reset (2026-07-19) | Epic Fantasy — Chu Kỳ & Selector (Thất Đại Tội/Bảy Đức Hạnh); đã cấu trúc lại theo pipeline v2, chỉ còn `lore/raw-idea.md`; chờ chạy `/expand-lore story-1` |
| `story-2/` | Đang phát triển | Dark Fantasy, hệ thống Thú Ấn — Arc 02 đang viết (`/next-chapter story-2`) |

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
