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
Ghi các file lore theo cấu trúc trên (slug kebab-case, file thực thể có header chuẩn: loại, trạng thái, xuất-hiện-đầu, cập-nhật-cuối). Nếu dự án còn file lore dạng cũ trước pipeline v2 (`lore/systems.md`, `lore/factions.md`, `lore/geography.md` dạng file đơn), xóa chúng sau khi ghi xong cấu trúc mới để tránh nội dung mồ côi. Nếu `<story>/STATE.md` còn ở trạng thái khởi tạo, cập nhật các trường liên quan. Kết thúc bằng lời nhắc: chạy `/story-skeleton <story>` để chốt tone + xương sống truyện trước khi viết chương.
