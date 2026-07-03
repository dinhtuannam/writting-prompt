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
