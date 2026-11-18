# Ma Trận Kiến Thức Nhân Vật

Theo dõi sự thật và thông tin theo từng nhân vật. Một nhân vật có thể biết, tin sai, nghi ngờ hoặc chưa biết một điều.

## Mã trạng thái

- `K`: biết chắc và có nguồn.
- `B`: tin là đúng nhưng có thể sai.
- `S`: nghi ngờ; ghi căn cứ và mức độ.
- `U`: chưa biết; không được viết như thể họ đã biết.
- `L`: biết một phần; mô tả rõ phần nào.

Cột: 001 Hennes, 002 Meinhard, 003 Halvard, 004 Bice, 005 Ottmar, 006 Bertolt. Trạng thái tại thời điểm trước chương 001.

| Fact ID | Sự thật/bí mật | 001 | 002 | 003 | 004 | 005 | 006 | Độc giả | Nguồn/ghi chú |
|---|---|---|---|---|---|---|---|---|---|
| FACT-001 | Kiếm của Meinhard là Dawn / Bình Minh | U | K | K | U | U | S (tin đồn "lão đội trưởng không cho ai chạm kiếm") | U | HIST-016 |
| FACT-002 | Kẻ không được chọn nắm kiếm thì chết | B (huyền thoại) | K | K | B | B | K | B | SWD-01 |
| FACT-003 | Chạm qua vỏ/vải thì an toàn | U | K | K | U | U | L (đọc trong văn khố, chưa kiểm chứng) | U | SWD-01 |
| FACT-004 | Meinhard là tác nhân của một sinh vật không phải người | U | L (biết không phải người, không biết là rồng) | K | U | U | U | U | CHAR-002 |
| FACT-005 | Ottmar giữ kỵ binh ở trại vì sứ giả tuyển hầu | U | S | U | U | K | U | U | HIST-021 |
| FACT-006 | Rồng không chạm được kiếm | U | U | K | U | U | U | U | SWD-03 (AI-only) |
| FACT-007 | Ý thức trong kiếm muốn KHÓA CỨNG và đọc được quyết tâm của người cầm | U | U | K | U | U | U | U | SWD-04, 09 (AI-only) |
| FACT-008 | Ma tộc đánh Dải Cháy vì Ma Thần mộng du về phía phong ấn | U | U | S | U | U | U | U | HIST-020 (AI-only) |
| FACT-009 | Ma tộc ăn thịt người (tuyên truyền, SAI) | B | U (không tin) | — | U (không tin) | B (dùng để động viên) | L | — | PROPAGANDA |

## Kiểm tra trước khi viết

- Nhân vật nhận thông tin bằng cách nào và vào lúc nào?
- Họ có thể hiểu sai, bỏ sót hoặc không tin nguồn không?
- Nếu là suy luận, căn cứ cụ thể là gì?
- Việc tác giả/độc giả biết điều này có khiến AI vô tình cho nhân vật biết không?
- Có cần cập nhật ma trận sau chương mới không?
