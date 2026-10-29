# Kết quả kiểm tra 29/10/2026

- Backend: 5/5 bài kiểm thử node:test + Supertest + pg-mem thành công.
- Flutter analyze: No issues found.
- Flutter widget test: 1/1 thành công.
- Chưa kiểm thử dịch vụ SMTP, Google OAuth và Render PostgreSQL thật; người dùng chọn tự triển khai.
- Vân tay và NFC cần kiểm thử trên điện thoại thật. Vân tay dùng FingerprintManager qua MethodChannel, không dùng khuôn mặt. API Android này đã deprecated và cần kiểm tra tương thích thiết bị mục tiêu.
- Mã nguồn quản lý hồ sơ và kế hoạch; chưa chặn ứng dụng/đo thời gian sử dụng thực.
