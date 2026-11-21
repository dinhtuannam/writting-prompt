# App Android "Đọc Truyện" (Flutter)

Bản Android của website `web/`: đọc các chương đã publish (`story-*/chapters/chapter-N.md`) từ GitHub.

## Tính năng

- Thư viện truyện → danh sách chương → đọc chương (giống web), kéo xuống để làm mới.
- Cỡ chữ A-/A+, nhớ đoạn đang đọc dở từng chương, nút "Đọc tiếp" ở danh sách chương.
- Đọc offline: chương/danh sách đã tải được lưu lại, mất mạng vẫn mở được.
- **Nghe truyện (đọc to)** bằng giọng tiếng Việt của Android:
  - Vẫn đọc khi **tắt màn hình** hoặc chuyển sang app khác (foreground service của `audio_service`, giữ wake lock khi đang phát).
  - Nút phát/dừng, đoạn trước/sau trên thanh thông báo, màn hình khóa và tai nghe.
  - Tự sang chương sau, tải sẵn chương kế để không đứt khi mất mạng.
  - Tô sáng và tự cuộn tới đoạn đang đọc; nhấn giữ một đoạn để đọc từ đó.
  - Chọn giọng, tốc độ 0.8×–2×; tự dừng khi rút tai nghe hoặc có cuộc gọi.

## Cấu trúc

- `lib/core/text_utils.dart` — hàm thuần port từ `web/app.js` (parse cây repo, markdown, chia câu để đọc).
- `lib/data/` — tải dữ liệu GitHub (qua proxy Vercel `/api/tree` của web, dự phòng gọi thẳng GitHub API) + cài đặt.
- `lib/tts/reader_audio_handler.dart` — bộ đọc to chạy trong service nền.
- `lib/ui/` — các màn hình.

Nếu đổi repo/tài khoản GitHub, sửa hằng số đầu `lib/data/library_repository.dart` (giống `web/app.js`).

## Build

SDK cài ở `C:\Users\ACER\dev\` (Flutter, Android SDK) và JDK 21 (Microsoft OpenJDK).

```bash
flutter test                 # unit test
flutter build apk --release  # → build/app/outputs/flutter-apk/app-release.apk
flutter build apk --release --split-per-abi   # APK nhỏ hơn theo kiến trúc máy (dùng bản arm64-v8a)
flutter run                  # chạy trên điện thoại cắm USB (bật Gỡ lỗi USB)
```

Lưu ý: `sdkmanager` bản mới dùng tên gói dạng `ndk/28.2.13676358` (dấu `/`); nếu Gradle báo không cài được gói SDK, cài tay:
`sdkmanager --sdk_root=C:\Users\ACER\dev\android-sdk "<gói>/<phiên bản>"`.

## Nếu máy tự dừng đọc khi tắt màn hình

Một số hãng (Xiaomi, Oppo, Vivo, Samsung…) tắt app chạy nền rất mạnh tay. Trong app: nút ⚙ ở thanh nghe → "Cho phép chạy nền" → tắt tối ưu pin cho "Đọc Truyện". Trên Xiaomi bật thêm "Tự khởi chạy".
