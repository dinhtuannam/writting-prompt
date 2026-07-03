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
