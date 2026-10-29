# PhamNguyenTuanDat_2380614580 — ChildGuard

Đồ án ứng dụng Flutter Android hỗ trợ phụ huynh quản lý hồ sơ trẻ, thiết bị, kế hoạch thời gian số và thỏa thuận trong gia đình.

## Công nghệ và cấu trúc

- Mobile: Flutter/Dart, Material 3; giữ bảng màu xanh đậm, xanh lá và nền sáng.
- Plugin Flutter: `http`, `flutter_secure_storage`, `local_auth`, `flutter_web_auth_2`, `nfc_manager`, `geolocator`, `url_launcher`, `crypto`.
- Backend: Node.js 22, Express 5, PostgreSQL, JWT, bcrypt, Zod; OTP qua Resend HTTPS; Google OAuth 2.0 xử lý phía backend.
- Triển khai: Render Web Service và PostgreSQL, cấu hình bằng `render.yaml`.

```text
frontend/       Ứng dụng Flutter Android và kiểm thử
backend/        REST API, schema PostgreSQL và kiểm thử
render.yaml     Blueprint Render
```

Flutter là framework lập trình mobile của dự án. Việc build Android vẫn cần Android SDK, JDK và Gradle; plugin sử dụng tích hợp native của nền tảng. MainActivity chỉ là lớp khởi động Flutter, không chứa nghiệp vụ riêng. Không dùng React Native hoặc Expo.

## Chức năng hiện có

- Đăng ký email, xác minh OTP; đăng nhập tên tài khoản/email và mật khẩu rồi OTP.
- Đăng nhập Google. Tài khoản đã có mật khẩu với cùng email vẫn phải xác minh OTP khi liên kết qua luồng Google.
- Phân quyền admin, nhân viên (`staff`), phụ huynh (`parent`), trẻ (`child`).
- Admin xem tài khoản và đổi quyền parent/child/staff; không đổi quyền quản trị hoặc quyền của chính mình. Nhân viên xem thống kê tổng hợp.
- Phụ huynh CRUD hồ sơ trẻ và thiết bị, liên kết tài khoản trẻ đã xác minh email.
- Phụ huynh/trẻ đề xuất thỏa thuận; phụ huynh duyệt, từ chối hoặc xóa. Phần thưởng là số phút theo kế hoạch.
- NFC: phụ huynh gắn thẻ, gia đình thực hiện và xem lịch sử check-in.
- Chia sẻ vị trí: trẻ chủ động cấp quyền và gửi vị trí hiện tại; phụ huynh liên kết xem thời điểm gửi, độ chính xác và mở bản đồ. Chỉ lưu vị trí gần nhất; trẻ có thể xóa. Không theo dõi nền.
- Hai lựa chọn mở phiên bằng khuôn mặt và vân tay riêng biệt, có nút bật/tắt và khóa lưu token riêng.

### Giới hạn sinh trắc học

Sinh trắc học mở lại phiên đã đăng nhập, không đăng ký tài khoản hoặc thay thế đăng nhập ban đầu. Token có thời hạn 12 giờ; đăng xuất xóa token lưu trên máy. Ứng dụng không lưu ảnh mặt hay mẫu vân tay lên backend.

`local_auth` không cho ép hộp thoại hệ thống chỉ dùng một phương thức trên mọi thiết bị. Vì vậy mã hiện tại chỉ cho phép khi hệ thống báo đúng loại được chọn và không báo loại khác hoặc nhóm `strong`/`weak`. Nhiều máy Android sẽ không dùng được hai lựa chọn này và cần đăng nhập bằng OTP. Đây không phải hệ thống nhận diện khuôn mặt riêng bằng camera/AI; cần kiểm tra trên điện thoại thật trước khi trình diễn.

## Chạy frontend dùng backend chung

Cài Flutter stable tương thích Dart `^3.8.0`, Android SDK và JDK phù hợp với Gradle của dự án. Android tối thiểu API 24. Kiểm tra môi trường bằng `flutter doctor`; bật USB debugging trên điện thoại.

```powershell
git clone https://github.com/DatPNguynXzyU/Backend-KTGK-Nhom-4.git
cd Backend-KTGK-Nhom-4/frontend
flutter pub get
flutter run
```

API mặc định trong `frontend/lib/api.dart`:

```text
https://phamnguyentuandat-2380614580-api.onrender.com
```

Bạn trong nhóm chỉ chỉnh frontend có thể dùng chung API này, không cần chạy backend hoặc có mật khẩu database. Dữ liệu thao tác là dữ liệu chung trên server. Nếu dùng service khác, truyền URL HTTPS không có dấu `/` cuối:

```powershell
flutter run --dart-define=API_BASE_URL=https://your-service.onrender.com
```

Giữ thư mục `frontend/third_party/nfc_manager`: đây là bản plugin được điều chỉnh tương thích cấu hình build Android, được tham chiếu qua `dependency_overrides`.

## Build APK

Chạy trong `frontend`:

```powershell
flutter pub get
flutter build apk --release
```

APK: `frontend/build/app/outputs/flutter-apk/app-release.apk`.

Bản debug để thử nghiệm:

```powershell
flutter build apk --debug
```

APK: `frontend/build/app/outputs/flutter-apk/app-debug.apk`. Có thể thêm `--dart-define=API_BASE_URL=...` vào lệnh build để đổi backend. Cấu hình release hiện vẫn dùng khóa debug; cần keystore và cấu hình ký riêng trước khi phát hành chính thức.

## Triển khai backend Render

1. Tạo Blueprint từ repository và `render.yaml` ở nhánh `main`.
2. Blueprint khai báo Web Service chạy từ `backend`, build `npm ci --omit=dev`, start `npm start`, health check `/health`; database là PostgreSQL.
3. Điền các biến môi trường bên dưới. Không đưa khóa bí mật vào Git hoặc frontend.
4. Deploy và kiểm tra trạng thái Live của đúng commit. Sau khi push, nếu chưa có bản triển khai mới, dùng **Manual Deploy → Deploy latest commit**.

| Biến | Nội dung |
| --- | --- |
| `DATABASE_URL` | Blueprint lấy từ PostgreSQL; nếu tạo service thủ công phải cấu hình kết nối |
| `JWT_SECRET` | Bí mật tối thiểu 32 ký tự; Blueprint tự tạo |
| `PUBLIC_URL` | Origin HTTPS của backend, không có dấu `/` cuối |
| `MAIL_PROVIDER` | `resend` |
| `RESEND_API_KEY` | API key Resend, chỉ đặt trên backend |
| `MAIL_FROM` | Địa chỉ người gửi hợp lệ với cấu hình Resend |
| `GOOGLE_CLIENT_ID` | OAuth client loại Web application |
| `GOOGLE_CLIENT_SECRET` | Client secret tương ứng |
| `BOOTSTRAP_ADMIN_EMAIL` | Email tài khoản sẽ được cấp admin sau khi đã xác minh và server khởi động lại |

Google OAuth phải cấu hình redirect URI khớp chính xác:

```text
https://phamnguyentuandat-2380614580-api.onrender.com/auth/google/callback
```

Nếu đổi service, đổi origin của redirect URI và `PUBLIC_URL` tương ứng. Khi Google OAuth còn ở chế độ thử nghiệm, thêm các tài khoản dùng thử trong Google Cloud. Resend cần người gửi/domain hợp lệ; địa chỉ thử nghiệm không dùng để gửi tùy ý cho mọi thành viên.

Backend chạy `backend/src/schema.sql` khi khởi động để tạo các bảng nếu chưa có, bao gồm `shared_locations`. Dữ liệu lưu trong PostgreSQL, không lưu trong APK. DBeaver chỉ là công cụ kết nối và quản lý database này.

## API và quyền truy cập

Kiểm tra backend/database: [GET /health](https://phamnguyentuandat-2380614580-api.onrender.com/health).

Các API dữ liệu yêu cầu header `Authorization: Bearer <token>`. Mở đường dẫn bảo vệ trực tiếp trên trình duyệt không có token sẽ không xem được dữ liệu.

| Nhóm | Endpoint tiêu biểu |
| --- | --- |
| Tài khoản | `POST /auth/register`, `POST /auth/login`, `POST /auth/otp`, `GET /me` |
| Google | `GET /auth/google/start`, `GET /auth/google/callback`, `POST /auth/google/exchange` |
| Hồ sơ trẻ | `GET/POST /children`, `PUT/DELETE /children/:id`, `POST /children/:id/link` |
| Thiết bị | `GET/POST /children/:id/devices`, `PUT/DELETE /devices/:id` |
| Thỏa thuận | `GET/POST /children/:id/agreements`, `PATCH/DELETE /agreements/:id` |
| NFC | `PUT /children/:id/nfc`, `GET/POST /children/:id/checkins` |
| Vị trí | `GET/PUT/DELETE /children/:id/location` |
| Quản trị | `GET /admin/users`, `PATCH /admin/users/:id/role` |
| Nhân viên | `GET /staff/dashboard` |

`:id` là UUID hồ sơ tương ứng. API vị trí chỉ cho trẻ đã liên kết gửi/xóa; phụ huynh sở hữu hồ sơ và trẻ liên kết được đọc. Dữ liệu PUT gồm `latitude`, `longitude`, `accuracy` (mét). Bản đồ mở bằng liên kết ngoài, không cần Google Maps SDK/API key trong app.

## Luồng dùng thử

1. Đăng ký và xác minh email phụ huynh; đăng nhập bằng mật khẩu và OTP.
2. Tạo tài khoản trẻ, xác minh email; admin cấp vai trò `child`.
3. Phụ huynh tạo hồ sơ và liên kết email tài khoản trẻ, sau đó thêm thiết bị hoặc thỏa thuận.
4. Trẻ đăng nhập, đề xuất thỏa thuận, check-in thẻ NFC đã gắn hoặc chọn chia sẻ vị trí.
5. Phụ huynh mở hồ sơ để duyệt thỏa thuận, xem check-in và làm mới vị trí.
6. Trong Tài khoản, bật phương thức sinh trắc học nếu thiết bị đáp ứng điều kiện nêu trên.

## Kiểm tra mã nguồn

Trong `backend`:

```powershell
npm ci
npm test
```

Trong `frontend`:

```powershell
flutter pub get
flutter analyze lib test
flutter test
```

Kiểm thử backend dùng database mô phỏng trong bộ test, không xác nhận tình trạng deploy Render. OAuth, nhận email, NFC, vị trí và sinh trắc học cần thử thêm trên thiết bị và dịch vụ thật.

## Phạm vi đồ án

Ứng dụng chưa đo thời gian sử dụng thực tế, chặn ứng dụng, khóa máy từ xa hoặc ghép nối phần cứng tự động. Giới hạn thời gian và phần thưởng là kế hoạch trong database. NFC check-in không chứng minh vị trí hay chống sao chép thẻ. Chưa tích hợp QR/Barcode, video nhóm, cảm biến hoặc dịch thời gian thực. Không nên coi giao diện khuôn mặt là bằng chứng chức năng nhận diện khuôn mặt đã hoạt động trên mọi máy.
