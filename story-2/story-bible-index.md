# Story Bible Index

> Đây là mục lục trung tâm và quy tắc truy xuất của novel. AI phải đọc file này trước khi làm việc với truyện, rồi chỉ nạp những hồ sơ liên quan đến tác vụ.

## Thông tin truyện

- **Story ID:** story-2
- **Tên:** Thất Kiếm Anh Hùng
- **Index version:** 1
- **Ý tưởng sơ khai gốc:** `story-seeds/story-2.md` (do tác giả cung cấp; AI bổ sung Phụ lục A ngày 2026-11-19 theo yêu cầu)
- **Bản sao seed trong novel:** `seed.md` (giữ nguyên, không chỉnh sửa; phần diễn giải phát triển ghi ở premise/dashboard)
- **AI creative authority:** FULL_WITHIN_SEED_AND_HARD_CONSTRAINTS
- **Trạng thái dự án:** DRAFTING
- **Canon cập nhật đến:** Chương 006 (EVT-042)
- **Chương tiếp theo cần viết:** 007
- **Index cập nhật lần cuối:** 2026-11-19
- **Conflict đang chặn tiến độ:** không có

## Lưu ý đặc biệt về seed

- `seed.md` Phần I–XIII và Phụ lục A là **tầng công khai**, có thể lộ dần cho độc giả.
- `seed.md` Phần XIV–XX là **tầng bí ẩn AI-only**: không trích nguyên văn vào chương, không reveal vượt lịch trong `planning/reveal-and-clue-map.md`.
- Seed nhắc tới các lệnh `/expand-lore`, `/story-skeleton`, `/plan-arc`. Repo này không còn các skill đó; các bước tương ứng làm theo workflow của bible này (worldbuilding → `planning/outline.md` → `planning/arcs/`).

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

- Master outline (12 Saga): `planning/outline.md`
- Arc plans: `planning/arcs/` (hiện có `arc-001.md`)
- Chapter plans: `planning/chapters/` (hiện có `chapter-001.md` → `chapter-003.md`)
- Setup/payoff và reveal: `planning/reveal-and-clue-map.md`
- Hộp ý tưởng chưa quyết: `planning/idea-inbox.md`

### Worldbuilding và hồ sơ

- Worldbuilding index: `lore/worldbuilding/README.md`
- Hệ thống (Khế Ngôn, kiếm thuật, Bảy Thánh Kiếm): `lore/worldbuilding/systems.md`
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

1. Đọc index này, dashboard, story rules và `summaries/story-so-far.md`. Đọc `seed.md` khi cần đối chiếu nền; với tầng bí ẩn (Phần XIV–XX), chỉ đọc khi tác vụ chạm tới reveal/clue.
2. Đọc trạng thái dự án và conflict đang mở. Tự giải quyết mâu thuẫn phụ theo source-of-truth; chỉ escalation conflict liên quan giới hạn cứng hoặc retcon lớn.
3. Xác định các entity ID, arc, sự kiện và file liên quan đến yêu cầu.

### Trước khi viết chương N

1. Đọc plan của chương N và plan arc hiện tại. Nếu thiếu plan, tự tạo plan bám master outline và các mốc đã chốt trước khi viết; cập nhật index.
2. Đọc summary chương N-1 và bản chương N-1 hiện hành (ít nhất đoạn kết); nếu continuity cần, đọc chương nguồn liên quan trực tiếp.
3. Tải snapshot trạng thái nhân vật, knowledge matrix, timeline, open threads và vật phẩm liên quan. **Riêng truyện này:** kiểm tra "nợ Hoãn" của người cầm Dawn trong `continuity/character-state.md`.
4. Tra hồ sơ từng nhân vật/địa điểm/phe phái/worldbuilding xuất hiện; chỉ nạp các miền tác động đến cảnh.
5. Tạo context packet gồm: mục tiêu/beat, điểm bắt đầu, POV knowledge, canon facts, planned direction, constraints và open threads.
6. Bám plan đã chốt. Nếu cần đổi plan để truyện tốt hơn, tự chọn thay đổi hợp lý, ghi lý do trong post-chapter update và sửa các plan sau bị ảnh hưởng. Hỏi tác giả nếu thay đổi làm đảo premise, chủ đề cốt lõi hoặc trải nghiệm novel.

### Sau khi chương hoàn tất và qua continuity audit

1. Lưu bản cuối nội bộ trong `manuscript/chapters/`. Không cần dừng chờ tác giả xác nhận từng chương.
2. Trích xuất sự kiện thành EVT-ID và cập nhật canon ledger/timeline.
3. Cập nhật kiến thức theo nhân vật, snapshot trạng thái, quan hệ và vật phẩm.
4. Cập nhật thread/reveal, chapter summary, story-so-far, arc progress và dashboard.
5. Thêm/sửa index khi có entity/file mới; thêm ID và nguồn cho dữ kiện.
6. Rà các chapter plan sau đó nếu chương thực tế làm thay đổi hướng.
7. Nếu được yêu cầu publish, sao chép bản public riêng sang `chapters/chapter-N.md`.

## ID và truy vấn

### Prefix dùng trong truyện này

- `CHAR-###`: nhân vật. `LOC-###`: địa điểm. `FAC-###`: phe phái/tổ chức. `ITEM-###`: vật phẩm.
- `EVT-###`: sự kiện canon trong truyện. `HIST-###`: sự kiện lịch sử trước chương 1.
- `FACT-###`: mệnh đề có ma trận kiến thức. `THREAD-###`: câu hỏi/lời hứa. `CLUE-###` / `REV-###`: manh mối/reveal.
- `GEO-`, `POL-`, `TECH-`, `ECO-`, `BEL-`, `GROUP-`: mục worldbuilding theo miền.
- `SYS-###`: hệ thống. `MAG-##`: luật Khế Ngôn. `SWD-##`: luật chung của Thánh Kiếm. `SWD-I` đến `SWD-VII`: hồ sơ từng kiếm.
- `DEC-###`: quyết định đã chốt. `CONFLICT-###`: xung đột dữ liệu. `TERM-###`: thuật ngữ.

Không tái sử dụng ID đã retired.

| ID | Tên chuẩn | Loại | Trạng thái | File nguồn | Lần cập nhật |
|---|---|---|---|---|---|
| CHAR-001 | Hennes | Character (protagonist, POV) | CANON nền / PLANNED arc | `lore/characters/CHAR-001-hennes.md` | init 2026-11-19 |
| CHAR-002 | Meinhard Asch | Character (người cầm Dawn trước Hennes) | CANON nền | `lore/characters/CHAR-002-meinhard-asch.md` | init |
| CHAR-003 | Halvard (người áo xám) | Character (Long tộc, một trong Ngũ Long) | CANON nền (phần lớn AI-only) | `lore/characters/CHAR-003-halvard.md` | init |
| CHAR-004 | Bice Ardengo | Character (pháp sư Sét, đồng hành) | CANON nền / PLANNED | `lore/characters/CHAR-004-bice-ardengo.md` | init |
| CHAR-005 | Ottmar von Selbach | Character (chỉ huy, đối thủ ARC-001) | CANON nền | `lore/characters/CHAR-005-ottmar-von-selbach.md` | init |
| CHAR-006 | Bertolt Ziegler | Character (thầy dòng phái Thu Hồi) | CANON nền | `lore/characters/CHAR-006-bertolt-ziegler.md` | init |
| CHAR-007 | Jörg Haller | Character (lính đi thay, phụ) | CANON nền | `lore/characters/CHAR-007-jorg-haller.md` | init |
| CHAR-008 | Bastl | Character (tân binh 15 tuổi, phụ) | CANON nền | `lore/characters/CHAR-008-bastl.md` | init |
| CHAR-009 | Mencía Oriol | Character (người chữa, ứng viên kiếm Mercy) | PLANNED | `lore/characters/CHAR-009-mencia-oriol.md` | init |
| CHAR-010 | Ma Thần | Entity | CANON (seed) | `lore/characters/CHAR-010-ma-than.md` | init |
| ITEM-001 | Dawn / Bình Minh (Kiếm I) | Item | CANON | `lore/worldbuilding/systems.md` mục SWD-I | init |
| LOC-001 | Bến lội Haselfurt | Location | CANON | `lore/locations/README.md` | init |
| LOC-002 | Trại Rabenau | Location | CANON | `lore/locations/README.md` | init |
| LOC-003 | Dải Cháy | Region | CANON | `lore/locations/README.md` | init |
| LOC-004 | Làng Lindhaag | Location | CANON | `lore/locations/README.md` | init |
| LOC-005 | Bá quốc biên Wendmark | Region | CANON | `lore/locations/README.md` | init |
| LOC-006 | Làng biên Valdesca | Location | PLANNED | `lore/locations/README.md` | init |
| LOC-007 | Biển Hẹp | Region | CANON | `lore/locations/README.md` | init |
| FAC-001..012 | Xem faction index | Faction | CANON / PLANNED | `lore/factions/README.md` | init |
| SYS-001 | Khế Ngôn | System | CANON (seed VIII) | `lore/worldbuilding/systems.md` | init |
| SYS-002 | Kiếm thuật | System | CANON (seed IX) | `lore/worldbuilding/systems.md` | init |
| SYS-003 | Bảy Thánh Kiếm | System | CANON (seed V, XV, XVIII) | `lore/worldbuilding/systems.md` | init |

## Chỉ mục arc/chương

| Arc/Chapter | Trạng thái | Mục tiêu/biến cố | Plan | Summary | Canon đến |
|---|---|---|---|---|---|
| ARC-001 "Thuế Máu" | IN_PROGRESS | Hennes sống sót trận Haselfurt, được Dawn chọn, trốn khỏi trại, tới làng biên Valdesca và bị lộ là người cầm kiếm | `planning/arcs/arc-001.md` | `summaries/arcs/arc-001.md` | — |
| Chapters 001–006 | COMPLETE | Đã viết và audit; chi tiết xem summary từng chương | `planning/arcs/arc-001.md` | `summaries/chapters/` | EVT-042 |
| ARC-002 → ARC-012 | PLANNED (phác) | Xem master outline | `planning/outline.md` | — | — |

## Ranh giới sáng tạo

- AI có quyền chủ động phát triển plot, nhân vật, worldbuilding, twist, nhịp chương và kết thúc theo premise, giới hạn và plan hiện hành.
- Chi tiết sáng tạo thông thường: AI tự quyết, ghi vào nguồn phù hợp, cập nhật ID/index và phân biệt sự thật nền `CANON` với sự kiện tương lai `PLANNED`.
- Quyết định đột phá có nhiều hướng mạnh và sẽ định hình khác biệt lớn: hỏi tác giả bằng các lựa chọn ngắn gọn, kèm đề xuất ưu tiên.
- Khi bí hướng: rà lại mục tiêu nhân vật, plan, open threads, chủ đề và hệ quả trước; chỉ hỏi tác giả khi đã thử mà vẫn không có hướng thuyết phục.
- Không hỏi tác giả duyệt từng chương hay chi tiết nhỏ. Tác giả có thể đọc như độc giả và yêu cầu chỉnh sửa bất cứ lúc nào; khi đó cập nhật retcon log và các hồ sơ/chương phụ thuộc.
- Chỉ giữ trạng thái DRAFT khi tác giả yêu cầu bản nháp hoặc phương án để lựa chọn. Mặc định, hoàn thành chương nghĩa là tự viết, tự audit, cập nhật bible rồi báo kết quả.
