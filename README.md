# Repo Viết Novel

Repo này dùng để phát triển novel dài kỳ và lưu website tĩnh đọc các chương đã publish. Đây không phải repo phần mềm tổng quát.

## Cấu trúc repo

- `story-template/`: bộ mẫu tạo story bible cho mỗi novel. Tên này không khớp `story-*`, nên web không liệt kê nhầm template thành truyện.
- `story-<id>/`: thư mục của một novel cụ thể, tạo bằng cách sao chép `story-template/`.
- `web/`: website đọc truyện tĩnh và Vercel serverless proxy gọi GitHub API.
- `AGENTS.md`: quy tắc khởi động bắt buộc cho AI agent làm việc trong repo.

Website chỉ tìm thư mục `story-*` ở gốc repo và chỉ đọc file `story-<id>/chapters/chapter-N.md`.

## Tạo novel mới

1. Sao chép mẫu `story-template/novel-seed.md` thành `story-seeds/ash-sea-seed.md` rồi điền ý tưởng (hoặc gửi ý tưởng trực tiếp trong chat).
2. Yêu cầu: `Khởi tạo novel mới từ story-seeds/ash-sea-seed.md. Đề xuất story ID nếu cần, kiểm tra tên chưa trùng, tạo folder story-<id>, xây dựng story bible và plan.`
3. AI sao chép nguyên bộ template thành `story-<id>/`, giữ file seed làm nguồn gốc ý tưởng, rồi xây premise, worldbuilding, nhân vật, tuyến truyện và kế hoạch chương. Mỗi lần chỉ khởi tạo một truyện để không trộn canon.
4. AI tự quyết các lựa chọn sáng tạo thông thường. AI chỉ hỏi khi có một phương án đột phá cần bạn chọn, có xung đột với yêu cầu bạn đã đưa ra, hoặc thật sự không tìm được hướng tiếp tục hợp lý.
5. Sau khi story bible và plan đủ nền tảng, AI bắt đầu viết chương theo workflow trong story bible. Mặc định AI tự viết, tự continuity-audit và cập nhật bible; bạn đọc như độc giả rồi yêu cầu sửa nếu muốn.

Nếu cần một template trống cho novel mới, không sửa trực tiếp `story-template/`; luôn tạo bản sao `story-<id>/`.

## AI đóng vai trò gì?

AI là nhà văn novel, worldbuilder và người giữ continuity của từng story. Bạn là người đọc/giám tuyển, không cần quyết định các diễn biến thông thường. AI được quyền chủ động quyết định tuyến truyện, nhân vật, thế giới, diễn biến chương và kết thúc trong phạm vi ý tưởng/giới hạn bạn cung cấp.

- AI tự xây và mở rộng thế giới; các quyết định sáng tạo thông thường có thể được ghi vào story bible mà không cần hỏi từng lần. Người dùng luôn có thể yêu cầu sửa hoặc retcon.
- Ý tưởng đột phá có nhiều hướng hấp dẫn nhưng tạo khác biệt lớn sẽ được trình bày ngắn gọn để bạn chọn khi lựa chọn đó thực sự có giá trị.
- Khi bí hướng tiếp theo sau khi đã thử suy luận từ plan, canon, động cơ nhân vật và hệ quả, AI mới hỏi bạn gợi ý.
- Nếu bạn không thích một quyết định đã viết, AI cập nhật canon/plan liên quan có ghi dấu retcon và sửa các chương bị ảnh hưởng.

## Story bible và indexing

Mỗi novel có `story-bible-index.md` làm mục lục trung tâm, quy định nguồn nào cần đọc theo tác vụ và dẫn đến các index con.

Trước khi viết/sửa chương, AI đọc theo thứ tự: index trung tâm → dashboard/rules → plan arc/chương → tóm tắt hiện tại → hồ sơ nhân vật/địa điểm/worldbuilding liên quan → knowledge matrix/timeline/open threads → chương liền trước. Không cần nạp toàn bộ lore nếu chỉ một phần liên quan.

ID ổn định (`CHAR-001`, `EVT-001`, `LOC-001`, `WB-001`, `THREAD-001`) giúp tìm kiếm và nối chéo. Sau mỗi chương, AI cập nhật index và các snapshot/summary để lần sau tra đúng trạng thái mới nhất. Nếu nguồn mâu thuẫn, ưu tiên theo source-of-truth trong index và ghi conflict thay vì che lỗi.

## Nơi viết và nơi publish chương

- Bản nháp: `story-<id>/manuscript/chapters/chapter-001.draft.md`.
- Bản làm việc cuối cùng: `story-<id>/manuscript/chapters/chapter-001.md`.
- Bản công khai trên web: sao chép nội dung đã hoàn tất/audit sang `story-<id>/chapters/chapter-1.md`.
- `manuscript/chapters/` là nơi viết; thư mục `chapters/` ở gốc story là bản phát hành. Không đưa ghi chú nội bộ, lore riêng hoặc spoiler lên bản công khai.

## Quy trình một chương

1. Indexing và tạo context packet theo plan/canon có liên quan.
2. Viết bản nháp bám mục tiêu, beat, POV và trạng thái xuất phát.
3. Tự continuity audit: kiến thức từng người, thời gian, vị trí, thương tích, vật phẩm, động cơ, luật thế giới và setup/payoff.
4. Lưu bản chương hoàn chỉnh và cập nhật chapter summary, canon ledger, timeline, character state, knowledge matrix, open threads và index. Không dừng chờ tác giả duyệt thường lệ; tác giả có thể yêu cầu chỉnh sau khi đọc.
5. Nếu cần publish, xuất bản riêng file chương đã hoàn tất.

## Điểm vào hữu ích

- Template và hướng dẫn: `story-template/README.md`
- Mẫu nhập ý tưởng sơ khai: `story-template/novel-seed.md` (mỗi seed cụ thể lưu thành file riêng trong `story-seeds/`)
- Quy tắc indexing: `story-template/story-bible-index.md`
- Luật sáng tác AI: `story-template/ai-workflow/00-ai-operating-rules.md`
- Worldbuilding: `story-template/lore/worldbuilding/README.md`
- Deploy web: `web/DEPLOY.md`
