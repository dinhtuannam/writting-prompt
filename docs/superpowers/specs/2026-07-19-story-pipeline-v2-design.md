# Thiết kế: Story Pipeline v2 — kiến trúc cốt truyện 2 tầng, worldbuilding sâu, cấu trúc file hai lớp

- **Ngày:** 2026-07-19
- **Trạng thái:** Đã duyệt từng phần qua hội thoại brainstorming
- **Phạm vi:** Nâng cấp bộ skill sinh truyện + tái cấu trúc folder story. KHÔNG bao gồm việc chạy regen nội dung story-2 (bước sau, do người dùng kích hoạt) và KHÔNG migrate story-1 (chỉ làm khi người dùng muốn viết tiếp story-1).

## 1. Bối cảnh & chẩn đoán

Triệu chứng người dùng báo: truyện gen ra nhàm, càng về sau càng thiếu chiều sâu, worldbuilding thiếu hụt lớn, "cốt truyện đi tới đâu gen tới đó".

Chẩn đoán từ story-1 (10 chương) và 2 skill hiện tại:

1. **`/expand-lore` chạy 1 lượt, sinh lore dạng bảng 1 dòng.** Toàn bộ thế giới story-1 ~50 dòng; đến chương 10 lãnh đạo cả 7 phe vẫn "(chưa xác định)". Bí ẩn không có lời giải định trước → reveal phải bịa tại chỗ.
2. **`/next-chapter` không có bước lên kế hoạch.** Không beat, không mục tiêu/xung đột/bước ngoặt cho chương → truyện thành chuỗi ứng tác từ hook chương trước.
3. **Chương teo dần:** chương 1 ~9 KB/4 cảnh giàu cảm quan; chương 10 ~5,5 KB/1 cảnh toàn thoại. Style guide đòi 2000-3000 từ nhưng không bước nào kiểm tra.
4. **Thế giới không chuyển động offscreen** — không có cơ chế ghi các phe đang làm gì ngoài tầm nhìn nhân vật chính.
5. **Lore đóng băng sau expand-lore** — chỉ được "thêm 1 dòng" khi có thứ mới xuất hiện trong chương.
6. **Cấu trúc file gộp theo thể loại** (1 file cho cả 7 phe, 1 file mọi địa danh...) → không đọc chọn lọc được, file phình vô hạn theo độ dài truyện.

Quyết định nền của người dùng:
- Quy mô truyện: **dài, kết thúc định trước, ~100-200 chương**.
- Cơ chế plan: **2 tầng** — xương sống toàn truyện quyết 1 lần + kế hoạch chi tiết theo từng arc.
- Hướng triển khai: **Hướng A** — thêm 2 skill mới (`/story-skeleton`, `/plan-arc`), tách tầng, mỗi tầng một điểm duyệt.
- Tone & Writing Style do AI đề xuất kèm văn mẫu, chốt 1 lần cho cả bộ, có biên độ dao động theo tình huống.

## 2. Flow tổng quan mới (vòng đời một truyện)

```
/new-story <tên>
   ↓
Ghi ý tưởng raw vào lore/raw-idea.md
   ↓
/expand-lore            ← NÂNG CẤP: lore sâu 3 lớp (mục 3)
   ↓   người dùng duyệt lore
/story-skeleton         ← MỚI: tone/style + xương sống toàn truyện + sổ bí mật (mục 4)
   ↓   người dùng duyệt skeleton + chọn tone
/plan-arc               ← MỚI: nhìn lại arc cũ + beat từng chương arc mới + world turn (mục 5)
   ↓   người dùng duyệt arc plan
/next-chapter  × N      ← NÂNG CẤP: viết bám beat + dàn cảnh + tự kiểm (mục 6)
   ↓   người dùng duyệt từng chương → cập nhật state
Hết arc (~10-15 chương) → /plan-arc → ... lặp đến kết thúc đã định trong skeleton
```

Nguyên tắc xuyên suốt:
1. Không chương nào được viết mà không có beat định trước.
2. Không bí ẩn nào thiếu lời giải viết sẵn.
3. Mỗi tầng (lore → skeleton → arc plan → chương) là một điểm duyệt của người dùng.
4. Mặc định 1 chương/lần gọi `/next-chapter` (giữ quy tắc hiện có).

## 3. Nâng cấp `/expand-lore` — lore sâu 3 lớp

Sinh trong cùng 1 lần chạy, bắt buộc đủ từng lớp; soạn xong toàn bộ → tóm tắt cho người dùng duyệt → mới ghi file (giữ quy trình duyệt hiện tại).

**Lớp 1 — Nền móng:**
- `world-overview.md`: thể loại, chủ đề, quy mô, tone sơ bộ (tone chính thức do `/story-skeleton` chốt). File này giữ NHỎ có chủ đích, kèm con trỏ tới các index.
- `systems/`: mỗi hệ thống sức mạnh có **chi phí, giới hạn, và lỗ hổng khai thác được về mặt kịch tính**.
- `history.md`: các thời kỳ + 3-5 sự kiện lịch sử, mỗi sự kiện ghi rõ **hệ quả còn sống đến hiện tại**.

**Lớp 2 — Chiều sâu từng mảng:**
- `factions/`: mỗi phe bắt buộc có — lãnh đạo có tên + tính cách; mục tiêu công khai VÀ mục tiêu ngầm; nguồn lực; mâu thuẫn nội bộ; quan hệ với từng phe khác. Cấm "(chưa xác định)" ở trường then chốt.
- `geography/`: mỗi địa danh chính có đặc trưng kinh tế/văn hóa + **chất liệu cảm quan** (mùi, âm thanh, ánh sáng đặc trưng).
- `daily-life.md` (MỚI): thường dân ăn gì, thờ gì, sợ gì, tiền tệ, luật lệ, tục lệ — chia mục theo vùng văn hóa.

**Lớp 3 — Động cơ xung đột:**
- `conflict-engines.md` (MỚI): tối thiểu 3 mâu thuẫn cấu trúc tự sinh chuyện kể cả khi nhân vật chính đứng yên. Mỗi engine: hai bên, vật tranh chấp, vì sao không thể thỏa hiệp, leo thang ra sao nếu không ai can thiệp. Là nguyên liệu cho "world turn" của `/plan-arc`.

**Quy tắc bí mật:** sự thật ẩn của thế giới KHÔNG ghi vào lore công khai — lore chỉ ghi "câu hỏi mà thế giới đang thắc mắc"; đáp án để dành cho `plot/secrets/` do `/story-skeleton` tạo.

## 4. Skill mới `/story-skeleton [story]`

- **Khi chạy:** 1 lần duy nhất, sau khi lore được duyệt. Lore trống → dừng, nhắc chạy `/expand-lore`.
- **Đọc vào:** `raw-idea.md`, toàn bộ `lore/`, `characters/` (nếu có).

**Sản phẩm 1 — Tone & Writing Style → `style/style-guide.md` (mở rộng):**
- AI đề xuất 2-3 phương án tone/style, mỗi phương án kèm **đoạn văn mẫu ~150 từ viết cùng một cảnh** để người dùng so trực tiếp và chọn.
- Style guide đầy đủ gồm: **tâm tone** (tonal center) + **biên độ cho phép** (cảnh được sáng/tối hơn tâm bao nhiêu, tùy tình huống); giọng kể; nhịp câu; quy ước thoại; POV; điều cấm kỵ; **1-2 anchor sample** — chuẩn đối chiếu văn phong cho mọi chương.

**Sản phẩm 2 — `plot/story-skeleton.md` (thay thế `plot/outline.md`):**
- Kết thúc đã chốt: 2-3 đoạn mô tả cảnh kết + trạng thái thế giới/nhân vật lúc đó.
- 3 act với bước ngoặt lớn chuyển act.
- Danh sách arc dự kiến (~8-15 arc), mỗi arc 3-4 dòng: mục tiêu tự sự, xung đột chính, thế giới/nhân vật thay đổi gì khi arc đóng, bí ẩn nào tiến triển.
- Đích đến của từng nhân vật chính (họ là ai ở cuối truyện).
- Lịch trả bí ẩn: bí ẩn nào hé phần nào ở arc nào.

**Sản phẩm 3 — `plot/secrets/` (sổ bí mật, chỉ AI đọc khi viết):**
- `_index.md`: mỗi bí ẩn 1 dòng — câu hỏi công khai, trạng thái, arc dự kiến trả.
- `<slug>.md` từng bí ẩn: đáp án thật đầy đủ | ai biết gì | lịch reveal | danh sách foreshadow cần gieo.
- Quy tắc cứng: chương không tiết lộ vượt lịch; foreshadow phải nhất quán với đáp án; không bao giờ trích nguyên văn secrets vào chương.

**Duyệt:** trình tóm tắt skeleton + 2-3 phương án tone → người dùng chọn tone, duyệt skeleton → mới ghi file.

**Chế độ vào giữa chừng** (cho story-1 sau này): đọc toàn bộ chương + summaries đã có, dựng skeleton khớp sự kiện đã xảy ra.

## 5. Skill mới `/plan-arc [story]`

- **Khi chạy:** sau khi skeleton duyệt (plan arc 1, trước chương 1); mỗi khi arc viết xong chương cuối; hoặc giữa arc khi người dùng muốn replan.
- **Đọc vào:** `story-skeleton.md`, `secrets/`, `style-guide.md`, `STATE.md`, `threads.md`, summaries arc vừa xong, `conflict-engines.md`, arc plan cũ (nếu có).

**Phần A — Nhìn lại arc vừa xong** (bỏ qua nếu arc 1):
- Đối chiếu chương đã viết với beat kế hoạch: lệch chỗ nào, lệch hay hơn hay dở hơn.
- Kiểm tra trôi tone: so văn các chương gần nhất với anchor sample, có vượt biên độ không.
- Threads bị bỏ quên; nhân vật giậm chân so với đích skeleton.
- Lệch lớn khỏi skeleton → đề xuất người dùng chọn: kéo về skeleton hay cập nhật skeleton (người dùng quyết, skill không tự sửa skeleton).

**Phần B — Kế hoạch arc mới → `plot/arc-plans/arc-NN.md`:**
- Mục tiêu arc (khớp mục nào trong skeleton); trạng thái mở đầu → trạng thái khi arc đóng.
- Beat từng chương (2-4 dòng/chương): mục tiêu chương; xung đột/trở ngại; bước ngoặt hoặc thông tin mới; thread nào tiến/đóng; cảm xúc chủ đạo; nhân vật/phe/địa danh xuất hiện (làm căn cứ đọc chọn lọc cho `/next-chapter`).
- **World turn:** mỗi phe chính làm gì offscreen trong arc này (rút từ conflict engines) → ghi mục "## Arc NN" vào `timeline/world-events.md`. Sự kiện offscreen rò rỉ vào chương qua tin đồn, giá cả, quân lính di chuyển, nhân vật phụ.
- Bí ẩn: reveal nào của secrets rơi vào arc này, foreshadow nào gieo ở chương nào.
- Nhân vật: mỗi nhân vật chính tiến bước nào về đích trong arc này.

**Quy tắc "kim chỉ nam, không phải xiềng xích":** `/next-chapter` được lệch beat ở mức dàn cảnh miễn giữ đúng điểm kết chương mà beat yêu cầu; muốn lệch cả điểm kết → hỏi người dùng trước.

**Duyệt:** trình toàn bộ Phần A + B → người dùng duyệt → mới ghi file.

## 6. Nâng cấp `/next-chapter`

Giữ khung 5 bước hiện tại, thay đổi:

**Bước đọc bối cảnh — đọc chọn lọc theo beat (thay quy tắc đọc cũ):**
1. `STATE.md` (toàn bộ), `style/style-guide.md` (toàn bộ, đọc lại anchor sample ngay trước khi viết)
2. Beat chương sắp viết trong `plot/arc-plans/arc-NN.md` (nguồn chỉ đạo chính)
3. `plot/threads.md` (chỉ chứa thread mở), `plot/secrets/_index.md` + file secret nào active trong arc
4. `timeline/world-events.md` mục arc hiện tại; 10 dòng cuối `timeline/timeline.md`
5. `characters/_index.md` + file riêng của nhân vật CÓ TRONG BEAT; `lore/*/_index.md` + file riêng của phe/địa danh/hệ thống CÓ TRONG BEAT
6. `summaries/chapters/arc-NN.md` (arc hiện tại), 2-3 mục cuối

**Bước mới — Phác dàn cảnh trước khi viết** (nội bộ, không cần duyệt): từ beat → 2-4 cảnh; mỗi cảnh: địa điểm, ai có mặt, căng thẳng gì, kết cảnh ra sao.

**Bước mới — Tự kiểm trước khi nộp** (fail mục nào tự sửa mục đó rồi mới trình):
1. Độ dài 2000-3000 từ thật (đếm, không ước lượng)
2. ≥2 cảnh; có chi tiết cảm quan lấy từ `geography/`/`daily-life.md`
3. Đúng điểm kết mà beat yêu cầu
4. Tone trong biên độ, cùng giọng với anchor sample
5. Không mâu thuẫn timeline/characters; không reveal vượt lịch secrets
6. ≥1 thread tiến triển; hook cuối chương trỏ về beat chương kế

**Bước cập nhật sau duyệt (bổ sung vào 6 mục hiện có):**
7. Đánh dấu beat đã hoàn thành trong arc plan (ghi chú nếu lệch)
8. Cập nhật `world-events.md` nếu chương làm lộ sự kiện offscreen
9. Thread nào vừa đóng → cắt khỏi `threads.md`, dán sang `threads-archive.md` (giữ `threads.md` chỉ chứa thread mở)
10. Nếu là chương cuối arc → nhắc người dùng chạy `/plan-arc`
(Ghi chú: mục 3 hiện có "thêm tóm tắt" đổi đích sang `summaries/chapters/arc-NN.md`; mục 6 hiện có "tạo hồ sơ mới" đổi đích sang cấu trúc index + file riêng ở mục 7 dưới đây.)

## 7. Tái cấu trúc folder story

**4 nguyên tắc:**
1. Hai lớp: `_index.md` (luôn rẻ để đọc; mỗi thực thể 1 dòng: slug, tóm tắt, trạng thái) + file chi tiết per-entity (chỉ mở khi thực thể xuất hiện trong beat). Nhân rộng pattern đã chạy tốt của `characters/`.
2. File "nóng" (đọc mỗi chương) phải nhỏ: đồ cũ/đã đóng đẩy sang archive.
3. Log chia theo arc — không file nối-đuôi nào phình vô hạn.
4. Slug kebab-case làm ID ổn định; mỗi file thực thể có header chuẩn (loại, trạng thái, chương xuất hiện đầu, chương cập nhật cuối).

**Cấu trúc mới:**

```
story-N/
├── STATE.md                        # giữ nguyên — nhỏ, luôn đọc toàn bộ
├── lore/
│   ├── raw-idea.md
│   ├── world-overview.md           # nhỏ có chủ đích: tổng quan + con trỏ tới các index
│   ├── conflict-engines.md         # 3-5 động cơ xung đột (bounded)
│   ├── history.md                  # viết 1 lần, mục theo thời kỳ (bounded)
│   ├── daily-life.md               # mục theo vùng văn hóa
│   ├── systems/    _index.md + <slug>.md
│   ├── factions/   _index.md (+ bảng quan hệ phe-phe) + <slug>.md
│   └── geography/  _index.md (địa danh phụ chỉ 1 dòng ở index) + <slug>.md
├── characters/                     # giữ nguyên pattern hiện có; nhân vật tạo MỚI thêm header chuẩn theo nguyên tắc 4
├── plot/
│   ├── story-skeleton.md           # thay thế outline.md (xóa outline.md khỏi template)
│   ├── secrets/    _index.md + <slug>.md
│   ├── threads.md                  # CHỈ thread đang mở
│   ├── threads-archive.md          # thread đã đóng
│   └── arc-plans/arc-NN.md
├── timeline/
│   ├── timeline.md                 # 1 dòng/chương — giữ 1 file
│   └── world-events.md             # mục "## Arc NN", chỉ đọc mục arc hiện tại
├── chapters/chapter-NNN.md         # giữ nguyên
├── summaries/
│   ├── arc-summaries.md            # 1 đoạn/arc (bounded)
│   └── chapters/arc-NN.md          # tóm tắt chương, mỗi arc 1 file
└── style/style-guide.md            # bounded, luôn đọc toàn bộ
```

**Kết quả test cấu trúc (mô phỏng, thế giới ở độ sâu mục tiêu, mốc chương ~100):**
- Cấu trúc cũ: AI buộc đọc ~391 KB/chương (mở toàn bộ file thể loại).
- Cấu trúc mới: ~92 KB/chương (**giảm 77%**); chi phí đọc tỉ lệ theo nội dung chương, không theo kích thước thế giới.
- Định vị: cần phe X → mở thẳng `factions/<slug>.md`, không quét file lớn.
- Giới hạn của test: đo chi phí context + khả năng định vị, không đo chất lượng văn; chất lượng kiểm chứng khi chạy arc đầu của story-2.

**Migration:**
- `_template-story/` làm lại toàn bộ theo cấu trúc mới.
- story-2: lore đang trống sau reset → không cần migrate, `/expand-lore` sinh thẳng cấu trúc mới.
- story-1: giữ cấu trúc cũ; chỉ migrate khi người dùng muốn viết tiếp (README ghi chú rõ).

## 8. Cập nhật tài liệu & template

**CLAUDE.md:**
- Thay "Quy tắc đọc file" bằng quy tắc đọc chọn lọc theo beat (mục 6).
- Thay "Quy tắc cập nhật" bằng bản bổ sung (mục 6, bước cập nhật sau duyệt).
- Cập nhật bảng skill + flow: `/new-story` → `/expand-lore` → `/story-skeleton` → `/plan-arc` → `/next-chapter` (× N) → hết arc quay lại `/plan-arc`.
- Ghi rõ: `plot/secrets/` là file AI-only, không trích nguyên văn vào chương.
- Cập nhật mô tả cấu trúc dự án theo cây thư mục mới.

**README.md (gốc workspace — TẠO MỚI):**
- Sơ đồ thứ tự dùng skill (như mục 2).
- Bảng tra nhanh: skill — khi nào chạy — sinh ra file gì — người dùng duyệt gì.
- Mục "truyện đang viết dở": hướng dẫn dùng chế độ vào-giữa-chừng của `/story-skeleton` cho story-1.

**Skill files:**
- Tạo mới: `.claude/skills/story-skeleton/SKILL.md`, `.claude/skills/plan-arc/SKILL.md`.
- Viết lại: `.claude/skills/expand-lore/SKILL.md`, `.claude/skills/next-chapter/SKILL.md`.
- `.claude/skills/new-story/SKILL.md`: giữ logic, template mới tự được nhân bản.

## 9. Tiêu chí thành công

1. Chạy được trọn flow mới trên story-2 từ raw-idea hiện có: `/expand-lore` → `/story-skeleton` → `/plan-arc` → `/next-chapter` chương 1, mỗi bước có điểm duyệt.
2. Sau `/expand-lore`: không còn "(chưa xác định)" ở trường then chốt; mỗi phe/hệ thống/địa danh chính có file riêng + index.
3. Sau `/story-skeleton`: kết thúc + lịch trả bí ẩn tồn tại trên file; mọi bí ẩn có đáp án viết sẵn.
4. Mỗi chương mới: đạt 2000-3000 từ, ≥2 cảnh, bám beat, qua đủ checklist tự kiểm trước khi trình duyệt.
5. Lượng file AI đọc mỗi chương bám theo beat (đọc chọn lọc), không phình theo kích thước thế giới.
