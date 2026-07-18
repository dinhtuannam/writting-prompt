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
