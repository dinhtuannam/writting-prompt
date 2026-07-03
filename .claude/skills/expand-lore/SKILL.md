---
name: expand-lore
description: Mở rộng một ý tưởng raw của người dùng thành lore hoàn chỉnh cho thế giới tiểu thuyết (world-building, hệ thống, phe phái, lịch sử, địa lý). Dùng khi người dùng đưa ý tưởng mới hoặc khởi tạo dự án. Nhận tham số tên story tùy chọn, mặc định dùng ACTIVE-STORY.md.
---

# Expand Lore

## Bước 0 — Xác định dự án đang thao tác
Nếu người dùng chỉ định tên story trong lệnh (vd `/expand-lore story-2`), dùng story đó. Nếu không, đọc `ACTIVE-STORY.md` ở gốc workspace. Gọi thư mục này là `<story>` cho các bước sau.

## Bước 1 — Nhận ý tưởng raw
Đọc `<story>/lore/raw-idea.md`. Nếu file đã có nội dung thực (khác trạng thái trống mặc định), dùng nội dung đó làm ý tưởng raw. Nếu file còn trống, hỏi người dùng ý tưởng raw ngay trong hội thoại (thể loại, nhân vật chính, bối cảnh sơ bộ, hoặc chỉ một câu ý tưởng ngắn), sau đó ghi NGUYÊN VĂN câu trả lời của người dùng vào `<story>/lore/raw-idea.md` trước khi sang Bước 2.

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
