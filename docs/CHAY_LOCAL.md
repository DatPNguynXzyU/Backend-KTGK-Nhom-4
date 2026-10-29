# Chạy backend trước, frontend sau

## 1. Khởi động PostgreSQL
Mở Docker Desktop và đợi engine chạy. Tại thư mục project:
```powershell
docker compose up -d
```
Hoặc cài PostgreSQL riêng, tạo database rồi sửa DATABASE_URL tương ứng.

## 2. Chạy backend (terminal thứ nhất)
```powershell
cd D:\PhamNguyenTuanDat_2380614580\backend
npm ci
Copy-Item .env.example .env
```
Sửa `.env`: DATABASE_URL=postgresql://childguard:childguard_local_only@127.0.0.1:5432/childguard, PORT=10000, PUBLIC_URL=http://localhost:10000 và JWT_SECRET là chuỗi ngẫu nhiên ít nhất 32 ký tự. Điền SMTP thật để nhận OTP email. Không ghi đè .env nếu đã có cấu hình.
```powershell
npm start
```
Kiểm tra trình duyệt: http://localhost:10000/health phải trả {"status":"ok"}. Giữ terminal này chạy.

## 3. Chạy frontend (terminal thứ hai)
Máy ảo Android Studio dùng 10.0.2.2 để truy cập máy tính:
```powershell
cd D:\PhamNguyenTuanDat_2380614580\frontend
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:10000 --dart-define=ALLOW_LOCAL_HTTP=true
```
Điện thoại thật qua USB: chạy `adb reverse tcp:10000 tcp:10000`, sau đó dùng API_BASE_URL=http://127.0.0.1:10000 cùng ALLOW_LOCAL_HTTP=true.
Điện thoại qua Wi-Fi: dùng địa chỉ IPv4 LAN của máy tính, hai máy cùng mạng; chỉ cho phép cổng 10000 trên mạng riêng khi Windows hỏi.

HTTP chỉ được mở trong bản Android debug và khi bật ALLOW_LOCAL_HTTP. Bản phát hành tiếp tục dùng HTTPS. Không cần Render cho quy trình này. Google OAuth cần callback được Google chấp nhận, cấu hình client riêng; OTP email vẫn cần SMTP thật.
