# Story Bible Index

> Đây là mục lục trung tâm và quy tắc truy xuất của novel. AI phải đọc file này trước khi làm việc với truyện, rồi chỉ nạp những hồ sơ liên quan đến tác vụ.

## Thông tin truyện

- **Story ID:** story-2
- **Tên:** Thất Kiếm – Tàn Dưới Bình Minh
- **Index version:** 1
- **Ý tưởng sơ khai gốc:** `../story-seeds/story-2.md`
- **Bản sao seed trong novel:** `seed.md` (giữ nguyên, không chỉnh sửa; diễn giải phát triển ghi ở premise/decision log)
- **AI creative authority:** FULL_WITHIN_SEED_AND_HARD_CONSTRAINTS
- **Trạng thái dự án:** DRAFTING
- **Canon cập nhật đến:** Chương 1 (EVT-016)
- **Chương tiếp theo cần viết:** 2
- **Index cập nhật lần cuối:** 2026-11-21
- **Conflict đang chặn tiến độ:** không có

## Source of truth

Khi các file mâu thuẫn, dùng thứ tự này và ghi lại conflict; không sửa âm thầm:

1. Chỉ dẫn mới nhất, rõ ràng của tác giả và các giới hạn trong `lore/02-story-rules.md`.
2. Seed gốc `seed.md` và các giới hạn cứng của tác giả (luật bảy thanh kiếm, 5 long tộc, Thất Nguyên Tố, bảy cấp độ ma pháp, các nguyên tắc thế giới mục II).
3. Bản thảo hoàn chỉnh hiện hành trong `manuscript/chapters/chapter-NNN.md` (đã qua continuity audit; `.draft.md` không phải canon).
4. `continuity/canon-ledger.md` đối chiếu với các chương hoàn chỉnh hiện hành.
5. Hồ sơ lore/worldbuilding có trạng thái CANON.
6. Snapshot mới nhất trong `continuity/` và summaries.
7. Kế hoạch (`PLANNED`): hướng tương lai, không phải sự kiện đã xảy ra.
8. Bản nháp, giả thuyết, ý tưởng, proposal: chưa phải sự kiện canon.

**Ghi chú riêng story-2:** Chương 1–2 trong seed là **bản phác của tác giả**. Các sự kiện trong đó là canon bắt buộc (DEC-001); văn bản chương chính thức được AI viết lại trong `manuscript/chapters/` và chính bản đó mới là canon văn bản.

## Mục lục nguồn

### Khởi động và luật

- Seed gốc, chỉ đọc: `seed.md`
- Dashboard + decision log: `lore/00-story-dashboard.md`
- Premise/theme/reader promise: `lore/01-premise-and-theme.md`
- Luật truyện, canon và phong cách: `lore/02-story-rules.md`
- Cấu trúc tổng thể 7 quyển: `lore/03-story-structure.md`
- Tổng quan thế giới: `lore/world-overview.md`
- Quy tắc AI: `ai-workflow/00-ai-operating-rules.md`

### Plot và kế hoạch

- Master outline: `planning/outline.md`
- Arc plans: `planning/arcs/arc-001.md`
- Chapter plans: `planning/chapters/chapter-001.md` → `chapter-003.md`
- Setup/payoff và reveal: `planning/reveal-and-clue-map.md`
- Hộp ý tưởng chưa quyết: `planning/idea-inbox.md`

### Worldbuilding và hồ sơ

- Worldbuilding index: `lore/worldbuilding/README.md`
- **Hệ thống ma pháp + Thất Kiếm:** `lore/worldbuilding/systems.md` (SYS-001 Thất Nguyên Tố, SYS-002 Bảy cấp độ, SYS-003 Thất Kiếm/phẩm lực, SYS-004 Cấm thuật)
- Lịch sử/niên đại: `lore/worldbuilding/history.md`
- Địa lý: `lore/worldbuilding/geography.md`
- Chủng tộc/sinh thái: `lore/worldbuilding/ecology-species.md`
- Chính trị/chiến tranh: `lore/worldbuilding/politics-law.md`
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
- Bản public: `chapters/chapter-N.md` (chỉ dùng để publish website, không phải nơi làm việc; chưa có)

## Quy trình indexing trước khi viết

### Mọi tác vụ trong novel

1. Đọc index này, bản seed gốc `seed.md`, dashboard, story rules và `summaries/story-so-far.md`.
2. Đọc trạng thái dự án và conflict đang mở. Tự giải quyết mâu thuẫn phụ theo source-of-truth; chỉ escalation conflict liên quan giới hạn cứng/retcon lớn.
3. Xác định các entity ID, arc, sự kiện và file liên quan đến yêu cầu.

### Trước khi viết chương N

1. Đọc plan của chương N và plan arc hiện tại. Nếu thiếu plan, tự tạo plan bám `planning/arcs/arc-001.md` và các mốc đã chốt trước khi viết; cập nhật index.
2. Đọc summary chương N-1 và bản chương N-1 hiện hành (ít nhất đoạn kết).
3. Tải snapshot trạng thái nhân vật, knowledge matrix, timeline, open threads và vật phẩm có liên quan.
4. Tra hồ sơ từng nhân vật/địa điểm/phe phái/worldbuilding xuất hiện; với cảnh có ma pháp, luôn đọc `lore/worldbuilding/systems.md`.
5. Tạo context packet với: mục tiêu/beat, điểm bắt đầu, POV knowledge, canon facts, planned direction, constraints và open threads.
6. Bám plan đã chốt; nếu cần đổi plan để truyện tốt hơn, tự chọn thay đổi hợp lý, ghi lý do và sửa các plan sau bị ảnh hưởng.

### Sau khi chương hoàn tất và qua continuity audit

1. Lưu bản cuối nội bộ trong `manuscript/chapters/`.
2. Trích xuất sự kiện thành EVT-ID (tiếp từ EVT-011) và cập nhật canon ledger/timeline.
3. Cập nhật kiến thức theo nhân vật, snapshot trạng thái, quan hệ và vật phẩm.
4. Cập nhật thread/reveal, chapter summary, story-so-far, arc progress và dashboard.
5. Thêm/sửa index khi có entity/file mới.
6. Rà các chapter plan sau đó nếu chương thực tế làm thay đổi hướng.
7. Nếu publish được yêu cầu, sao chép bản public riêng sang `chapters/chapter-N.md`.

## ID và truy vấn

Prefix: `CHAR-` nhân vật, `LOC-` địa điểm, `FAC-` phe phái, `ITEM-` vật phẩm, `EVT-` sự kiện canon, `FACT-` mệnh đề kiến thức, `THREAD-` mối dây, `CLUE-`/`REV-` manh mối/reveal, `SYS-` hệ thống, `GEO-`/`HIST-`/`POL-`/`RACE-` worldbuilding, `DEC-` quyết định, `Q-` câu hỏi mở, `CONFLICT-`.

Không tái sử dụng ID đã retired.

| ID | Tên chuẩn | Loại | Trạng thái | File nguồn | Lần cập nhật |
|---|---|---|---|---|---|
| CHAR-001 | Edran Veyl | Character (protagonist, POV) | CANON | `lore/characters/CHAR-001-edran-veyl.md` | init |
| CHAR-002 | Vaelthar | Character (long tộc Nham, mentor) | CANON | `lore/characters/CHAR-002-vaelthar.md` | init |
| CHAR-003 | Varkhaz – Ma thần | Character (đối thủ tối thượng) | CANON | `lore/characters/CHAR-003-varkhaz.md` | init |
| CHAR-004 | Pell Hask | Character (lính trẻ Hắc Thạch) | CANON (nền) / PLANNED (vai trò) | `lore/characters/CHAR-004-pell-hask.md` | init |
| CHAR-005 | Ysolde Kramm | Character (pháp sư Thủy quân y) | PLANNED | `lore/characters/CHAR-005-ysolde-kramm.md` | init |
| CHAR-006 | Kesh Vahrun | Character (pháp sư Hỏa Cao cấp, Hắc Nha) | PLANNED | `lore/characters/CHAR-006-kesh-vahrun.md` | init |
| CHAR-007 | Ansgar Tolle | Character (Bá tước biên trấn) | PLANNED | `lore/characters/CHAR-007-ansgar-tolle.md` | init |
| CHAR-008 | Lise Veyl | Character (em gái Edran) | PLANNED | `lore/characters/CHAR-008-lise-veyl.md` | init |
| CHAR-009 | Gerrit Moll | Character (sĩ quan già, Hắc Thạch) | CANON (nền) | `lore/characters/README.md` | init |
| CHAR-010 | Lambert Tolle | Character (cháu Bá tước) | PLANNED | `lore/characters/README.md` | init |
| CHAR-011 | Dhurgal | Character (tướng Hắc Nha) | PLANNED | `lore/characters/README.md` | init |
| ITEM-001 | Bình Minh (kiếm Dũng Khí) | Item | CANON | `lore/worldbuilding/systems.md#SYS-003` | init |
| ITEM-002 | Bản đồ da rồng bảy dấu kiếm | Item | CANON | `lore/worldbuilding/systems.md#SYS-003` | init |
| LOC-001 → LOC-010 | Xem location index | Location | CANON/PLANNED | `lore/locations/README.md` | init |
| FAC-001 → FAC-008 | Xem faction index | Faction | CANON/PLANNED | `lore/factions/README.md` | init |

## Chỉ mục arc/chương

| Arc/Chapter | Trạng thái | Mục tiêu/biến cố | Plan | Summary | Canon đến |
|---|---|---|---|---|---|
| ARC-001 (Quyển I: Tàn Dưới Bình Minh) | PLANNED | Edran sống sót, học cách dùng Bình Minh, rời phương Bắc | `planning/arcs/arc-001.md` | `summaries/arcs/arc-001.md` | — |
| Chapter 001 | COMPLETE | Ngày Phòng Tuyến Phía Bắc Sụp Đổ | `planning/chapters/chapter-001.md` | `summaries/chapters/chapter-001.md` | EVT-016 |
| Chapter 002 | PLANNED | Tỉnh dậy ở nhà đá; bản đồ sáu thanh kiếm | `planning/chapters/chapter-002.md` | — | — |
| Chapter 003 | PLANNED | Đá thử nguyên; cái giá của Bình Minh; dấu hiệu bị săn đuổi | `planning/chapters/chapter-003.md` | — | — |

## Ranh giới sáng tạo

- AI có quyền chủ động phát triển plot, nhân vật, worldbuilding, twist, nhịp chương và kết thúc theo premise, giới hạn và plan hiện hành.
- Chi tiết sáng tạo thông thường: AI tự quyết, ghi vào nguồn phù hợp, cập nhật ID/index và phân biệt `CANON` với `PLANNED`.
- Quyết định đột phá nhiều hướng mạnh: hỏi tác giả bằng lựa chọn ngắn gọn kèm đề xuất.
- Không hỏi tác giả duyệt từng chương/chi tiết nhỏ.
