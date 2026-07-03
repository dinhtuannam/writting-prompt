# Deploy lên Vercel

Trang này là 1 site tĩnh (HTML/CSS/JS thuần), không cần build.

## Các bước

1. Đảm bảo repo đã được push lên GitHub (GitHub Desktop tự động làm việc này mỗi khi có commit mới trên `main`).
2. Vào https://vercel.com → **Add New... → Project**.
3. Chọn **Import Git Repository** → chọn repo `dinhtuannam/writting-prompt`.
4. Trong phần cấu hình project:
   - **Root Directory:** `web`
   - **Framework Preset:** Other
   - **Build Command:** để trống (không cần build)
   - **Output Directory:** `.`
5. Bấm **Deploy**. Không cần khai báo biến môi trường nào — trang chỉ gọi API công khai của GitHub (`api.github.com` và `raw.githubusercontent.com`), repo phải ở chế độ **public**.

## Sau khi deploy

- Mỗi khi có chương mới được `/next-chapter` viết + duyệt và GitHub Desktop tự push, mở lại trang và bấm nút **"Làm mới"** ở trang danh sách truyện để thấy ngay (trang cũng tự làm mới sau tối đa 10 phút nhờ cache).
- Nếu đổi tên repo hoặc chuyển sang tài khoản GitHub khác, cập nhật 3 hằng số đầu file `web/app.js`: `GITHUB_OWNER`, `GITHUB_REPO`, `GITHUB_BRANCH`.
