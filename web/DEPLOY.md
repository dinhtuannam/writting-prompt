# Deploy lên Vercel

Trang này là 1 site tĩnh (HTML/CSS/JS thuần) + 1 serverless function nhỏ (`api/tree.js`) để proxy gọi GitHub API, không cần build.

## Các bước

1. Đảm bảo repo đã được push lên GitHub (GitHub Desktop tự động làm việc này mỗi khi có commit mới trên `main`).
2. Vào https://vercel.com → **Add New... → Project**.
3. Chọn **Import Git Repository** → chọn repo `dinhtuannam/writting-prompt`.
4. Trong phần cấu hình project:
   - **Root Directory:** `web`
   - **Framework Preset:** Other
   - **Build Command:** để trống (không cần build)
   - **Output Directory:** `.`
5. Tạo GitHub token và khai báo biến môi trường (bắt buộc — xem lý do bên dưới):
   - Vào https://github.com/settings/tokens?type=beta → **Generate new token** (fine-grained).
   - Repository access: chỉ chọn repo `dinhtuannam/writting-prompt`.
   - Permissions: **Contents → Read-only** là đủ.
   - Copy token vừa tạo.
   - Trong Vercel project → **Settings → Environment Variables**, thêm biến `GITHUB_TOKEN` = token vừa copy, áp dụng cho cả Production và Preview.
6. Bấm **Deploy**. Repo phải ở chế độ **public** (nội dung chương vẫn lấy qua `raw.githubusercontent.com` công khai từ trình duyệt).

## Vì sao cần GITHUB_TOKEN?

Nếu gọi thẳng `api.github.com` từ trình duyệt (không token), GitHub giới hạn **60 request/giờ theo địa chỉ IP**. Người dùng mạng di động thường đứng sau NAT dùng chung IP với rất nhiều thuê bao khác (CGNAT) nên dễ bị hết quota và nhận lỗi **403**, trong khi dùng WiFi (IP ít bị chia sẻ hơn) thì không sao. `api/tree.js` chạy trên hạ tầng Vercel, dùng `GITHUB_TOKEN` để gọi GitHub với quota 5000 request/giờ dùng chung cho toàn site — không còn phụ thuộc IP của người xem.

## Sau khi deploy

- Mỗi khi có chương mới được `/next-chapter` viết + duyệt và GitHub Desktop tự push, mở lại trang và bấm nút **"Làm mới"** ở trang danh sách truyện để thấy ngay (trang cũng tự làm mới sau tối đa 10 phút nhờ cache).
- Nếu đổi tên repo hoặc chuyển sang tài khoản GitHub khác, cập nhật 3 hằng số đầu file `web/app.js` (`GITHUB_OWNER`, `GITHUB_REPO`, `GITHUB_BRANCH`) **và** 3 hằng số tương ứng đầu file `web/api/tree.js`.
