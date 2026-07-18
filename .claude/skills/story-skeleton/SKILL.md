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
