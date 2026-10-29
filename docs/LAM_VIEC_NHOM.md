# Làm frontend dùng chung backend Render

Clone toàn bộ repository để có đầy đủ thư viện NFC đã vá:

```powershell
git clone https://github.com/DatPNguynXzyU/Backend-KTGK-Nhom-4.git
cd Backend-KTGK-Nhom-4/frontend
flutter pub get
flutter run --dart-define=API_BASE_URL=https://phamnguyentuandat-2380614580-api.onrender.com
```

Chỉ sửa frontend/lib và tài nguyên giao diện; không cần npm, PostgreSQL, Docker hay chạy backend. API dùng chung qua HTTPS. Xem docs/API.md để biết request/response. Không đưa JWT_SECRET, RESEND_API_KEY hay Google client secret vào Flutter. Mỗi thành viên dùng tài khoản riêng. Resend thử nghiệm chỉ gửi OTP tới email chủ tài khoản; để cả nhóm đăng ký cần xác minh domain gửi.

Giữ frontend/third_party/nfc_manager và pubspec.lock trong repository; đây là bản vá build NFC cho Android SDK mới. Làm việc trên nhánh riêng, gửi thay đổi để chủ project xem trước khi gộp. Backend Render chỉ cần deploy lại khi mã backend hoặc cấu hình server thay đổi.

Build APK:
```powershell
flutter build apk --debug --dart-define=API_BASE_URL=https://phamnguyentuandat-2380614580-api.onrender.com
```

File tại frontend/build/app/outputs/flutter-apk/app-debug.apk. APK debug phục vụ học tập, không phải bản ký để phát hành Google Play.
