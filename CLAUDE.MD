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
