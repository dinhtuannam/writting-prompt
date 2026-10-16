# Bản Thảo

Bản nháp và bản thảo nội bộ đều nằm trong `manuscript/chapters/`. Bản nháp theo yêu cầu lưu với hậu tố `.draft.md`, ví dụ `chapter-001.draft.md`. Mặc định AI viết hoàn chỉnh, tự rà continuity, lưu bản chính thức nội bộ là `chapter-001.md`, `chapter-002.md`... rồi cập nhật continuity. Đây là nguồn làm việc chính của chương.

Để xuất bản qua website hiện tại, sao chép phần văn bản công khai của bản hoàn chỉnh sang `<story-id>/chapters/chapter-1.md` (website hiện chỉ nhận tên `chapter-N.md`, trong đó N là số nguyên). Thư mục `chapters/` ở gốc story là bản phát hành, không phải nơi viết nháp. Không sao chép ghi chú nội bộ, metadata riêng tư hoặc lore spoiler.

## Cấu trúc thư mục gợi ý

```text
manuscript/
  README.md
  chapters/
    chapter-001.draft.md
    chapter-001.md
    chapter-002.draft.md
```

## Khi nào được ghi là CANON?

- File `.draft.md` luôn là DRAFT, kể cả khi nội dung có vẻ hoàn chỉnh.
- `manuscript/chapters/chapter-NNN.md` là bản cuối nội bộ sau khi AI hoàn tất và tự rà continuity. Tác giả có thể yêu cầu chỉnh hoặc retcon sau khi đọc.
- Bản publish ở `<story-id>/chapters/chapter-N.md` chỉ là bản công khai tương ứng; nếu tác giả yêu cầu chỉnh sửa nội dung, đồng bộ lại bản nội bộ và các hồ sơ continuity.
- Nếu website cần số chương không đệm 0 (`chapter-1.md`) nhưng bản nội bộ dùng `chapter-001.md`, đổi tên khi sao chép sang publish; không đổi quy ước nội bộ giữa chừng.

## Mẫu đầu chương

```markdown
# Chương N: (Tiêu đề)

<!-- STATUS: DRAFT | CANON -->
<!-- POV: CHAR-001 | IN-WORLD TIME: ... | LOCATION: LOC-001 -->

(Nội dung chương)
```

Không đưa ghi chú nội bộ, spoiler hoặc lore riêng tư vào bản công khai.
