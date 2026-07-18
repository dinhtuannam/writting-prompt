# Workspace Tiểu Thuyết AI — Hướng Dẫn Sử Dụng (Pipeline v2)

## Thứ tự dùng skill cho một truyện MỚI

```
1. /new-story <tên>          → tạo thư mục story-<tên>/ từ template
2. Điền ý tưởng raw          → ghi vào story-<tên>/lore/raw-idea.md (hoặc trả lời khi được hỏi)
3. /expand-lore <story>      → AI dựng lore sâu 3 lớp        → BẠN DUYỆT lore
4. /story-skeleton <story>   → AI đề xuất 2-3 tone kèm văn mẫu + xương sống toàn truyện + sổ bí mật
                                                             → BẠN CHỌN tone, DUYỆT skeleton
5. /plan-arc <story>         → AI lên beat từng chương của arc 1 + world turn
                                                             → BẠN DUYỆT arc plan
6. /next-chapter <story>     → AI viết 1 chương bám beat, tự kiểm rồi trình
                                                             → BẠN DUYỆT từng chương
   (lặp bước 6 cho tới hết arc ~10-15 chương)
7. Hết arc → quay lại /plan-arc (AI nhìn lại arc cũ + plan arc mới) → tiếp tục bước 6
   ... lặp 6-7 cho đến kết thúc đã định trong story-skeleton.md
```

## Bảng tra nhanh
| Skill | Khi nào chạy | Sinh ra | Bạn duyệt gì |
|---|---|---|---|
| `/new-story <tên>` | Bắt đầu truyện mới | Thư mục `story-<tên>/` | Tên + chuyển active |
| `/expand-lore [story]` | Sau khi có raw-idea | `lore/` đầy đủ 3 lớp | Toàn bộ lore |
| `/story-skeleton [story]` | 1 LẦN, sau khi lore duyệt | `style-guide.md` (tone + anchor), `plot/story-skeleton.md`, `plot/secrets/` | Chọn tone, duyệt skeleton + danh sách bí ẩn |
| `/plan-arc [story]` | Đầu MỖI arc (kể cả arc 1) | `plot/arc-plans/arc-NN.md`, mục world-events | Nhận xét arc cũ + beat arc mới |
| `/next-chapter [story]` | Mỗi chương | `chapters/chapter-NNN.md` | Nội dung chương |

## Quy tắc quan trọng
- Mặc định 1 chương / lần `/next-chapter` — mỗi chương là một điểm kiểm soát chất lượng.
- `plot/secrets/` là sổ bí mật AI-only: chứa đáp án mọi bí ẩn + lịch reveal. Đừng đọc nếu không muốn spoil chính mình.
- Muốn đổi hướng truyện giữa chừng: nói khi duyệt arc plan, hoặc yêu cầu replan (`/plan-arc` lại arc hiện tại). Đổi hướng LỚN → yêu cầu cập nhật `story-skeleton.md`.

## Truyện đang viết dở từ trước pipeline v2
- `story-1/` (10 chương, cấu trúc cũ): khi muốn viết tiếp, chạy `/story-skeleton story-1` — skill có chế độ vào-giữa-chừng, đọc chương đã có và dựng skeleton khớp; sau đó cần migrate cấu trúc thư mục (nhờ AI làm khi đó).
- `story-2/` (đã reset, có raw-idea): chạy từ bước 3 — `/expand-lore story-2`.
