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
