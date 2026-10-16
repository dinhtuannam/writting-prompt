# Story Bible Index

> Đây là mục lục trung tâm và quy tắc truy xuất của novel. AI phải đọc file này trước khi làm việc với truyện, rồi chỉ nạp những hồ sơ liên quan đến tác vụ.

## Thông tin truyện

- **Story ID:** story-1
- **Tên:** Tam Hồi Phản Trảm (tên làm việc)
- **Index version:** 3
- **Ý tưởng sơ khai gốc:** `seed.md`
- **Bản sao seed trong novel:** `seed.md` (giữ bản gốc không chỉnh sửa; ghi diễn giải phát triển ở premise/decision log)
- **AI creative authority:** FULL_WITHIN_SEED_AND_HARD_CONSTRAINTS
- **Trạng thái dự án:** DRAFTING
- **Canon cập nhật đến:** Chapter 006 / EVT-013
- **Chương tiếp theo cần viết:** 007
- **Index cập nhật lần cuối:** 2026-10-17
- **Conflict đang chặn tiến độ:** (không có)

## Source of truth

Khi các file mâu thuẫn, dùng thứ tự này và ghi lại conflict; không sửa âm thầm:

1. Chỉ dẫn mới nhất, rõ ràng của tác giả và các giới hạn trong `lore/02-story-rules.md`.
2. Seed gốc `seed.md` và các giới hạn cứng của tác giả.
3. Bản thảo hoàn chỉnh hiện hành trong `manuscript/chapters/chapter-NNN.md` (đã qua continuity audit; `.draft.md` không phải canon).
4. `continuity/canon-ledger.md` đối chiếu với các chương hoàn chỉnh hiện hành.
5. Hồ sơ lore/worldbuilding có trạng thái CANON, được AI chốt trong phạm vi sáng tạo được giao hoặc được người dùng xác nhận.
6. Snapshot mới nhất trong `continuity/` và summaries.
7. Kế hoạch (`PLANNED`): hướng tương lai, không phải sự kiện đã xảy ra.
8. Bản nháp, giả thuyết, ý tưởng, proposal: chưa phải sự kiện canon.

Nếu ledger/summary không khớp bản chương hiện hành, bản chương là bằng chứng gốc; ghi conflict cần thiết và đồng bộ các index phụ.

## Mục lục nguồn

### Khởi động và luật

- Seed gốc, chỉ đọc: `seed.md`
- Dashboard: `lore/00-story-dashboard.md`
- Premise/theme/reader promise: `lore/01-premise-and-theme.md`
- Luật truyện, canon và phong cách: `lore/02-story-rules.md`
- Cấu trúc tổng thể: `lore/03-story-structure.md`
- Tổng quan thế giới: `lore/world-overview.md`
- Quy tắc AI: `ai-workflow/00-ai-operating-rules.md`

### Plot và kế hoạch

- Master outline: `planning/outline.md`
- Arc plans: `planning/arcs/` (tạo một file mỗi arc theo `arc-plan-template.md`)
- Chapter plans: `planning/chapters/` (một file mỗi chương theo `chapter-plan-template.md`)
- Planning guide và mẫu: `planning/README.md`, `planning/arc-plan-template.md`, `planning/chapter-plan-template.md`
- Setup/payoff và reveal: `planning/reveal-and-clue-map.md`
- Hộp ý tưởng chưa quyết: `planning/idea-inbox.md`

### Worldbuilding và hồ sơ

- Worldbuilding index: `lore/worldbuilding/README.md`
- Các miền worldbuilding: xem các liên kết trong index đó.
- Character index: `lore/characters/README.md`
- Location index: `lore/locations/README.md`
- Faction index: `lore/factions/README.md`
- Glossary/naming: `lore/glossary.md`

### Canon và trạng thái

- Canon ledger: `continuity/canon-ledger.md`
- Timeline: `continuity/timeline.md`
- Character state snapshot: `continuity/character-state.md`
- Knowledge matrix: `continuity/knowledge-matrix.md`
- Open threads: `continuity/open-threads.md`
- Retcon log: `continuity/retcon-log.md`
- Conflict log: `continuity/conflict-log.md`

### Manuscript và summaries

- Bản thảo nội bộ: `manuscript/chapters/chapter-NNN.md`
- Bản nháp: `manuscript/chapters/chapter-NNN.draft.md`
- Chapter summaries: `summaries/chapters/chapter-NNN.md`
- Story so far: `summaries/story-so-far.md`
- Arc summaries: `summaries/arcs/arc-NNN.md`
- Bản public: `chapters/chapter-N.md` (chỉ dùng để publish website, không phải nơi làm việc)

## Quy trình indexing trước khi viết

### Mọi tác vụ trong novel

1. Đọc index này, bản seed gốc `seed.md`, dashboard, story rules và `summaries/story-so-far.md`.
2. Đọc trạng thái dự án và conflict đang mở. Tự giải quyết mâu thuẫn phụ theo source-of-truth; chỉ escalation conflict liên quan giới hạn cứng/retcon lớn.
3. Xác định các entity ID, arc, sự kiện và file liên quan đến yêu cầu.

### Trước khi viết chương N

1. Đọc plan của chương N và plan arc hiện tại. Nếu thiếu plan, tự tạo plan bám master outline và các mốc đã chốt trước khi viết; cập nhật index.
2. Đọc summary chương N-1 và bản chương N-1 hiện hành (ít nhất đoạn kết); nếu continuity cần, đọc chương nguồn liên quan trực tiếp.
3. Tải snapshot trạng thái nhân vật, knowledge matrix, timeline, open threads và vật phẩm có liên quan.
4. Tra hồ sơ từng nhân vật/địa điểm/phe phái/worldbuilding xuất hiện; chỉ nạp các miền tác động đến cảnh.
5. Tạo context packet với: mục tiêu/beat, điểm bắt đầu, POV knowledge, canon facts, planned direction, constraints và open threads.
6. Bám plan đã chốt. Nếu cần đổi plan để truyện tốt hơn, tự chọn thay đổi hợp lý, ghi lý do trong post-chapter update và sửa các plan sau bị ảnh hưởng; hỏi tác giả nếu thay đổi làm đảo premise, chủ đề cốt lõi hoặc trải nghiệm novel.

### Sau khi chương hoàn tất và qua continuity audit

1. Lưu bản cuối nội bộ trong `manuscript/chapters/`. Không cần dừng chờ tác giả xác nhận từng chương; tác giả là người đọc và có thể yêu cầu sửa sau.
2. Trích xuất sự kiện thành EVT-ID và cập nhật canon ledger/timeline. Chapter hoàn chỉnh sau audit là canon hiện hành, trừ khi được ghi rõ là bản nháp.
3. Cập nhật kiến thức theo nhân vật, snapshot trạng thái, quan hệ và vật phẩm.
4. Cập nhật thread/reveal, chapter summary, story-so-far, arc progress và dashboard.
5. Thêm/sửa index khi có entity/file mới; thêm ID và nguồn cho dữ kiện.
6. Rà các chapter plan sau đó nếu chương thực tế làm thay đổi hướng.
7. Nếu publish được yêu cầu, sao chép bản public riêng sang `chapters/chapter-N.md`.

## ID và truy vấn

### Prefix khuyến nghị

- `CHAR-###`: nhân vật.
- `LOC-###`: địa điểm.
- `FAC-###`: phe phái/tổ chức.
- `EVT-###`: sự kiện canon.
- `FACT-###`: mệnh đề/thông tin có ma trận kiến thức.
- `THREAD-###`: câu hỏi/lời hứa chưa giải quyết.
- `CLUE-###` / `REV-###`: manh mối/reveal.
- `WB-###`: mục worldbuilding tổng quát; miền có thể dùng `GEO-`, `HIST-`, `POL-`, `TECH-`, `ECO-`, `BEL-`.
- `DEC-###`: quyết định tác giả đã chốt.
- `CONFLICT-###`: xung đột dữ liệu cần xử lý.

Không tái sử dụng ID đã retired. Bảng entity index dưới đây phải dẫn tới file hồ sơ hiện hành.

| ID | Tên chuẩn | Loại | Trạng thái | File nguồn | Lần cập nhật |
|---|---|---|---|---|---|
| CHAR-001 | Elk Vantry | Character | CANON | `lore/characters/CHAR-001-elk-vantry.md` | chapter-001 |
| CHAR-002 | Corvin Hale | Character | CANON | `lore/characters/CHAR-002-corvin-hale.md` | chapter-001 |
| CHAR-003 | Sable | Character | CANON | `lore/characters/CHAR-003-sable.md` | chapter-001 |
| CHAR-004 | Garrity | Character | CANON | `lore/characters/CHAR-004-garrity.md` | chapter-001 |
| LOC-001 | Vực Khuyết | Location | CANON | `lore/locations/LOC-001-vuc-khuyet.md` | chapter-001 |
| LOC-002 | Nhà Corvin | Location | CANON | `lore/locations/LOC-002-nha-corvin.md` | chapter-001 |
| LOC-003 | Trụ sở Hội Giá Vực | Location | CANON | `lore/locations/LOC-003-tru-so-hoi.md` | chapter-003 |
| FAC-001 | Hội Giá Vực | Faction | CANON | `lore/factions/FAC-001-hoi-gia-vuc.md` | chapter-001 |
| CHAR-005 | Odalie Varnes | Character | CANON | `lore/characters/CHAR-005-odalie-varnes.md` | chapter-003 |
| CHAR-006 | Dask | Character | CANON | `lore/characters/CHAR-006-dask.md` | chapter-006 |

## Chỉ mục arc/chương

| Arc/Chapter | Trạng thái | Mục tiêu/biến cố | Plan | Summary | Canon đến |
|---|---|---|---|---|---|
| ARC-001 | IN_PROGRESS | Elk giữ Nhà Corvin an toàn trước Hội Giá Vực; Dấu Ấn Phẫn Nộ đã thức tỉnh (Ngoặt 1 đạt được) | `planning/arcs/arc-001.md` | (chưa có arc summary, arc chưa đóng) | EVT-013 |
| Chapter 001 | DONE | Elk đối đầu Hội Giá Vực một mình; tin Selector tử trận lan tới | `planning/chapters/chapter-001.md` | `summaries/chapters/chapter-001.md` | EVT-005 |
| Chapter 002 | DONE | Xác nhận danh tính Harlan Dray; Odalie Varnes mời gặp | `planning/chapters/chapter-002.md` | `summaries/chapters/chapter-002.md` | EVT-007 |
| Chapter 003 | DONE | Thương lượng hợp đồng với Odalie Varnes | `planning/chapters/chapter-003.md` | `summaries/chapters/chapter-003.md` | EVT-009 |
| Chapter 004 | DONE | Hợp đồng ký; Dask tấn công trả thù, Corvin bị thương | `planning/chapters/chapter-004.md` | `summaries/chapters/chapter-004.md` | EVT-011 |
| Chapter 005 | DONE | Dấu Ấn Phẫn Nộ thức tỉnh lần đầu (Ngoặt 1) | `planning/chapters/chapter-005.md` | `summaries/chapters/chapter-005.md` | EVT-012 |
| Chapter 006 | DONE | Hậu quả; Hội Giá Vực chính thức biết Elk là Selector | `planning/chapters/chapter-006.md` | `summaries/chapters/chapter-006.md` | EVT-013 |

## Ranh giới sáng tạo

- AI có quyền chủ động phát triển plot, nhân vật, worldbuilding, twist, nhịp chương và kết thúc theo premise, giới hạn và plan hiện hành.
- Chi tiết sáng tạo thông thường: AI tự quyết, ghi vào nguồn phù hợp, cập nhật ID/index và phân biệt sự thật nền `CANON` với sự kiện tương lai `PLANNED`.
- Quyết định đột phá nhưng có nhiều hướng mạnh, sẽ định hình khác biệt lớn: hỏi tác giả bằng các lựa chọn ngắn gọn, kèm đề xuất ưu tiên.
- Khi bí hướng: rà lại mục tiêu nhân vật, plan, open threads, chủ đề và hệ quả trước; chỉ hỏi tác giả khi đã thử mà vẫn không có hướng thuyết phục.
- Không hỏi tác giả duyệt từng chương/chi tiết nhỏ. Tác giả có thể đọc như độc giả và yêu cầu chỉnh sửa bất cứ lúc nào; khi đó cập nhật retcon log và các hồ sơ/chương phụ thuộc.
- Chỉ giữ trạng thái DRAFT khi tác giả yêu cầu bản nháp/phương án để lựa chọn. Mặc định, hoàn thành chương là tự viết, tự audit, cập nhật bible rồi báo kết quả.
