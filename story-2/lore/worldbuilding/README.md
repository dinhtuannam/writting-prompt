# Worldbuilding: Chỉ Mục Và Quy Trình

Thư mục này là bộ tham chiếu worldbuilding có cấu trúc. AI vừa bám điều đã xác lập, vừa chủ động sáng tạo các phần mới hợp lý và giàu sức gợi trong phạm vi quyền tác giả giao.

## Cách dùng

1. Đọc `../02-story-rules.md`, `../world-overview.md` và bảng trạng thái ở dưới.
2. Chỉ đọc các file miền liên quan đến yêu cầu/cảnh hiện tại; không cần nạp toàn bộ world bible mỗi lần.
3. Mỗi sự thật đã xác nhận cần ID ổn định, trạng thái, phạm vi áp dụng và nguồn.
4. Khi tác giả giao xây dựng thế giới, AI chủ động điền các khoảng trống thông thường và tự chọn phương án nhất quán; dùng `development-queue.md` để theo dõi câu hỏi còn mở và quyết định đột phá.
5. Ghi quyết định worldbuilding nền đã tự chốt vào file miền với ID, trạng thái và lý do. Sự kiện tương lai của cốt truyện ghi `PLANNED`; sự thật nền được quyết định ghi `CANON`. Nếu nội dung xuất hiện trong truyện, thêm nguồn chapter/EVT-ID.

## Bản đồ miền

- `geography.md`: địa lý, khí hậu, vùng, tuyến đường, khoảng cách và mùa.
- `history.md`: niên đại, biến cố, nguyên nhân, hậu quả và những phiên bản lịch sử khác nhau.
- `society-culture.md`: tầng lớp, gia đình, phong tục, lễ nghi, chuẩn mực và xung đột văn hóa.
- `politics-law.md`: nhà nước, quyền lực, luật, tư pháp, chiến tranh và ngoại giao.
- `economy-technology.md`: sản xuất, tiền tệ, thương mại, nghề nghiệp, hạ tầng và công nghệ.
- `ecology-species.md`: hệ sinh thái, loài, bệnh tật, mùa vụ, tài nguyên và chuỗi thức ăn.
- `systems.md`: phép thuật, siêu năng lực, khoa học giả tưởng hoặc hệ thống đặc biệt khác.
- `beliefs.md`: tôn giáo, tín ngưỡng, triết học, huyền thoại và điều cấm kỵ.
- `everyday-life.md`: ăn uống, nhà ở, quần áo, giáo dục, giải trí, giao tiếp và chi tiết cảm quan.
- `development-queue.md`: khoảng trống, câu hỏi và đề xuất worldbuilding chưa duyệt.
- `worldbuilding-entry-template.md`: mẫu hồ sơ chi tiết cho một yếu tố mới.

## Trạng thái và loại mệnh đề

Trạng thái:

- `CANON`: sự thật nền đã được AI chốt nhất quán trong vùng sáng tạo được giao, hoặc xuất hiện trong chương hoàn chỉnh đã audit.
- `PLANNED`: hướng tương lai đã được chốt trong story bible nhưng chưa xảy ra trong truyện.
- `PROPOSED`: một nhánh lớn đang chờ tác giả chọn hoặc quyết định chưa thể chốt.
- `IN_WORLD_BELIEF`: niềm tin, lời đồn, giáo lý hoặc tuyên truyền của một nhóm; không mặc nhiên là sự thật khách quan.
- `CONFLICT`: dữ kiện đang mâu thuẫn, chờ tác giả quyết định.
- `RETIRED`: đã bỏ; không dùng làm chỉ dẫn hiện hành.

Loại mệnh đề nên ghi rõ:

- `FACT`: sự thật khách quan được xác nhận.
- `BELIEF`: điều một nhân vật/nhóm tin là thật.
- `RUMOR`: lời đồn chưa xác minh.
- `PROPAGANDA`: thông tin có chủ đích thao túng.
- `UNKNOWN`: tác giả chưa quyết hoặc cư dân chưa biết.

## Phân tầng tri thức trong thế giới

Với bí mật hoặc lịch sử gây tranh cãi, ghi riêng:

1. **Sự thật khách quan:** điều thực sự xảy ra trong canon (có thể UNKNOWN với độc giả).
2. **Tri thức công khai:** điều dân chúng có thể biết.
3. **Tri thức chuyên môn:** điều chỉ người trong nghề/giới tinh hoa biết.
4. **Tri thức bí mật:** ai biết, biết bằng cách nào, và đang giấu ai.
5. **Phiên bản sai lệch:** lời đồn, giáo lý, tuyên truyền hay hiểu lầm.

Không gộp các lớp này thành một câu khẳng định chung.

## Quy trình đề xuất sáng tạo

Khi được giao xây dựng/thêm worldbuilding, AI chủ động tạo chi tiết mới trong vùng chưa xác định. Với các quyết định thông thường, tự chọn hướng nhất quán và ghi vào bible. Mỗi lần mở rộng cần:

- Khớp các quy tắc CANON, hoặc chỉ rõ quy tắc nào cần thay đổi.
- Bắt đầu từ nhu cầu truyện, nhân vật hoặc môi trường, không chỉ thêm lore trang trí.
- Có giới hạn, chi phí, người hưởng lợi, người chịu thiệt và hệ quả đời sống.
- Xem xét tác động tới địa lý, lịch sử, quyền lực, kinh tế, văn hóa, công nghệ và continuity liên quan.
- Nêu phần nào là sự thật khách quan, phần nào chỉ là niềm tin trong thế giới.
- Tự chọn phương án tốt nhất cho các quyết định worldbuilding thông thường, ghi lý do và hệ quả.
- Đưa 1-3 phương án và hỏi tác giả chỉ khi các hướng đều mạnh nhưng làm thay đổi đáng kể trải nghiệm/cốt lõi novel.
- Không retcon canon đã xác lập một cách âm thầm; các bổ sung tương thích trong vùng chưa xác định được AI tự quyết theo quyền sáng tạo đã giao.

### Định dạng câu trả lời PROPOSAL

```text
PROPOSAL ID: WB-P-001
Tên ý tưởng:
Miền:
Trạng thái: PROPOSED
Nhu cầu truyện đang phục vụ:
Mô tả ngắn:
Sự thật khách quan / niềm tin trong thế giới:
Giới hạn và chi phí:
Ai hưởng lợi / ai chịu thiệt:
Tác động lên các miền khác:
Tương thích với canon nào:
Rủi ro hoặc mâu thuẫn tiềm tàng:
Các lựa chọn thay thế:
Quyết định cần tác giả:
```

## Nguyên tắc chống worldbuilding rời rạc

- Ưu tiên hệ quả hơn danh sách trivia: một quy luật nên ảnh hưởng đến hành vi, thiết chế hoặc đời sống.
- Công nghệ/phép thuật càng mạnh càng cần giới hạn, chi phí, khả năng tiếp cận và cách bị lạm dụng.
- Phong tục phải có nguồn gốc hoặc chức năng; không coi cả nền văn hóa là đồng nhất.
- Lịch sử do con người ghi chép có thể thiên lệch; chỉ tác giả mới quyết định sự thật khách quan.
- Không mở rộng quy mô thế giới bằng một đế chế, giống loài, thần linh hay đại chiến mới nếu chưa kiểm tra tác động cốt truyện.
- Không tạo ngoại lệ chỉ để giải cứu tình huống hiện tại.
- Mỗi dữ kiện dùng được trong chương cần có ID/nguồn để truy ngược.

## Kiểm tra trước khi chấp thuận

- Nó giải quyết nhu cầu kể chuyện nào?
- Nếu yếu tố này tồn tại từ lâu, vì sao chưa gây ra hệ quả rõ ràng trước đó?
- Ai kiểm soát nó, ai bị loại khỏi quyền tiếp cận?
- Có thể khai thác, làm giả, buôn bán, cấm đoán hoặc lạm dụng nó không?
- Nó thay đổi điều gì trong đời sống thường ngày?
- Nó tạo lỗ hổng continuity nào (đi lại, liên lạc, chiến tranh, chữa bệnh, quyền lực)?
- Độc giả cần biết phần nào ngay bây giờ, phần nào có thể giữ bí mật?
