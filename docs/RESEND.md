# OTP qua HTTPS trên Render Free

Backend mặc định dùng Resend API qua HTTPS. SMTP chỉ bật khi MAIL_PROVIDER=smtp; không dùng chế độ này trên Render Free.

1. Tạo tài khoản tại https://resend.com và tạo API key có quyền gửi email.
2. Render Environment: MAIL_PROVIDER=resend, RESEND_API_KEY là key riêng, MAIL_FROM là địa chỉ gửi.
3. Thử nghiệm: MAIL_FROM=ChildGuard <onboarding@resend.dev>. Chỉ gửi được tới email tài khoản Resend của bạn.
4. Để cả nhóm nhận OTP: thêm và xác minh domain của bạn trong Resend, rồi đổi MAIL_FROM thành ChildGuard <otp@domain-da-xac-minh>. Không dùng địa chỉ Gmail làm domain gửi đã xác minh.
5. Push render.yaml mới lên GitHub rồi tải lại trang tạo Blueprint. Các ô SMTP sẽ được thay bằng RESEND_API_KEY và MAIL_FROM. Không nhập secret vào Git/chat.
6. Deploy rồi đăng ký bằng email được phép nhận, kiểm tra OTP thật. API key chưa cấu hình hoặc gửi thất bại trả 503; không trả OTP ra response/log.

Google OAuth vẫn cần cấu hình riêng. Các hướng dẫn SMTP cũ trong DEPLOY_RENDER.md được thay thế bằng tài liệu này khi dùng Render Free. Chưa kiểm chứng gửi thư thật cho đến khi cấu hình key và sender.

Nguồn: https://resend.com/docs/api-reference/emails/send-email và https://resend.com/docs/knowledge-base/403-error-resend-dev-domain
