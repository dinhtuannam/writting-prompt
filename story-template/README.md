# Bộ Quản Lý Truyện

Bộ khung quản lý novel. Sao chép thư mục này thành `story-<id>` khi bắt đầu một truyện.

## Bắt đầu nhanh

1. Sao chép `novel-seed.md` thành `story-seeds/<id>-seed.md` rồi điền ý tưởng sơ khai; mỗi novel lưu seed bằng một tên file riêng.
2. Yêu cầu AI khởi tạo project: AI sao chép template thành `story-<id>` sau khi kiểm tra tên chưa tồn tại; không viết trực tiếp vào template.
3. Giữ seed gốc ở `seed.md` trong project; dùng `story-bible-index.md` làm mục lục và quy trình indexing trung tâm.
4. Xây premise, luật, worldbuilding, nhân vật và outline; AI chủ động sáng tạo theo quyền tác giả giao.
5. Trước mỗi chương, truy xuất plan, summary và hồ sơ liên quan theo index thay vì nạp lore tùy tiện.
6. Sau khi hoàn thành và tự rà continuity chương, cập nhật canon ledger, timeline, ma trận kiến thức, trạng thái nhân vật, mối dây và summaries. Không cần chờ tác giả duyệt từng chi tiết thông thường.

Để bắt đầu truyện mới, sao chép `story-template/novel-seed.md` thành `story-seeds/<id>-seed.md`, điền ý tưởng rồi yêu cầu AI: `Khởi tạo novel mới từ story-seeds/<id>-seed.md. Tạo story-<id>, xây dựng story bible và plan, sau đó bắt đầu chương 1.` Nếu chưa biết ID, yêu cầu AI đề xuất tên thư mục. AI phải kiểm tra chưa trùng thư mục, sao chép template và làm việc trong thư mục mới.

## Cấu trúc

- `lore/`: nguồn tham chiếu nền, worldbuilding, nhân vật, địa điểm, phe phái và từ điển.
- `continuity/`: canon đã xảy ra, timeline, kiến thức nhân vật, trạng thái vật phẩm và retcon.
- `planning/`: dàn ý và kế hoạch arc/chương; không tự động là canon.
- `novel-seed.md`: mẫu trống; mỗi ý tưởng cụ thể được lưu riêng tại repo `story-seeds/`.
- `story-bible-index.md`: mục lục, source of truth, entity index và quy trình truy xuất.
- `manuscript/chapters/`: nơi viết và sửa bản thảo chương nội bộ; bản nháp chưa duyệt không phải canon.
- `summaries/`: tóm tắt cấp truyện, arc và chương.
- `ai-workflow/`: quy tắc và prompt làm việc.
- `archive/`: nơi lưu ý tưởng đã bỏ, không dùng làm chỉ dẫn hiện hành.

## Quy ước bắt buộc

- `CANON`: sự thật nền AI đã chốt nhất quán trong phạm vi được giao, hoặc sự kiện trong chương hoàn chỉnh đã tự continuity-audit.
- `PLANNED`: dự kiến tương lai, không kể như đã xảy ra.
- `HYPOTHESIS`: suy đoán; luôn ghi rõ ai đang tin điều đó.
- `RETIRED`: ý tưởng đã bỏ, chỉ lưu để tránh dùng lại nhầm.
- `CONFLICT`: có hai nguồn không tương thích; nêu cả hai và chờ tác giả quyết định.
- `DRAFT`: bản nháp tạo theo yêu cầu để xin phản hồi; không phải canon.
- Không âm thầm sửa canon. Đề xuất retcon phải có lý do, ngày, nguồn và danh sách hệ quả.
- Dùng ID ổn định cho nhân vật, sự kiện, địa điểm, vật phẩm, manh mối; tên hiển thị có thể đổi.
- Ghi rõ thời gian, địa điểm, người biết, nguồn biết và hệ quả cho dữ kiện continuity quan trọng.

## Trước khi đưa truyện lên website

Website hiện tại chỉ liệt kê thư mục gốc khớp `story-*` và đọc chương theo `chapters/chapter-N.md`. Tên template này không khớp quy ước đó. Chương được viết và sửa tại `manuscript/chapters/`; sau khi hoàn tất/audit, giữ bản nội bộ ở đó và chỉ sao chép phần văn bản công khai sang `<story-id>/chapters/chapter-N.md` để publish. Không công khai lore nếu chưa muốn lộ spoiler.

## Vòng lặp mỗi chương

1. Chốt mục tiêu chương, POV, thời gian/địa điểm, xung đột và thay đổi cần tạo.
2. Nạp quy tắc truyện, tóm tắt đến hiện tại, hồ sơ liên quan và continuity snapshot.
3. Viết nháp, tách rõ chi tiết mới đề xuất khỏi sự thật.
4. Rà continuity: kiến thức, vị trí, thương tích, vật phẩm, thời gian, động cơ, luật thế giới.
5. AI tự rà continuity và chốt bản hoàn chỉnh thành canon theo quyền sáng tạo được giao. Tác giả đọc như độc giả, không cần duyệt thường lệ; bản nháp chỉ tạo khi được yêu cầu rõ.
6. Cập nhật ledger, timeline, ma trận kiến thức, trạng thái nhân vật, mối dây còn mở và phần tóm tắt.
7. Dùng prompt kiểm tra trong `ai-workflow/04-continuity-audit-prompt.md`.
8. Nếu publish, sao chép nội dung chương đã hoàn tất sang `chapters/chapter-N.md`; không dùng thư mục publish làm nơi soạn thảo.

## Quy ước thời gian và file

Nếu không có lịch riêng, dùng `Ngày N` tính từ mốc 0. Nếu không chắc thời điểm, ghi `ước tính`. Bản nháp đặt tên `chapter-001.draft.md`; bản duyệt đặt tên `chapter-001.md`.
