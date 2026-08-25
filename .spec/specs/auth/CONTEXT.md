# Context Discovery: Authentication & Account Management (FT-001)

---

## 1. Vấn Đề Thực Sự Là Gì? (The Real Problem)

Bệnh viện thú y có 5-15 bác sĩ cùng sử dụng hệ thống Pet Photo Manager. Cần một cơ chế xác thực để:
- Xác định **ai đang thao tác** (bác sĩ nào upload ảnh, ghi chú)
- Phân biệt quyền **Admin** (quản lý tài khoản) và **Doctor** (sử dụng hệ thống)
- Bảo vệ dữ liệu bệnh nhân thú y khỏi truy cập trái phép

**Pain Point hiện tại:** Chưa có hệ thống — ảnh nằm rải rác trên điện thoại cá nhân, không biết ai chụp, không kiểm soát truy cập.

---

## 2. Thuật Ngữ Nghiệp Vụ (Domain Glossary)

| Thuật ngữ | Định nghĩa |
|-----------|------------|
| **Doctor (Bác sĩ)** | Nhân viên thú y sử dụng hệ thống để upload ảnh, tra cứu hồ sơ ảnh thú cưng |
| **Admin (Quản trị)** | Người quản lý bệnh viện, chịu trách nhiệm tạo/quản lý tài khoản bác sĩ |
| **Session** | Phiên đăng nhập của bác sĩ, duy trì bằng JWT token |
| **Profile** | Thông tin cá nhân của bác sĩ: tên hiển thị, avatar, email |

---

## 3. Stakeholders

| Stakeholder | Vai trò | Quan tâm chính |
|-------------|---------|----------------|
| **Bác sĩ thú y** | Người dùng chính | Đăng nhập nhanh, không phức tạp, dùng được trên điện thoại |
| **Quản lý bệnh viện** | Admin hệ thống | Tạo/khóa tài khoản bác sĩ, kiểm soát ai truy cập |
| **Chủ thú cưng** | Gián tiếp | Không trực tiếp dùng hệ thống, nhưng dữ liệu ảnh thú cưng của họ cần được bảo mật |

---

## 4. Ràng Buộc Cứng (Hard Constraints)

| Ràng buộc | Chi tiết |
|-----------|----------|
| **Tech Stack** | Flutter/Dart (Web) + PostgreSQL — yêu cầu từ khách hàng |
| **Số lượng user** | 5-15 bác sĩ đồng thời (quy mô nhỏ) |
| **Thiết bị** | Web responsive — bác sĩ dùng cả điện thoại và máy tính |
| **Không self-register** | Bác sĩ KHÔNG tự đăng ký — Admin tạo tài khoản cho họ |
| **Phương thức đăng nhập** | Email + Password (không OTP/SMS ở v1.0) |
| **Không mobile native** | Web app, truy cập qua trình duyệt |

---

## 5. Giả Định & Câu Hỏi Chưa Rõ (Assumptions & Open Questions)

### Giả định (Assumptions)
- [A1] Mỗi bệnh viện là 1 instance riêng (single-tenant), không cần multi-tenant ở v1.0
- [A2] Admin là 1 bác sĩ kiêm nhiệm hoặc nhân viên quản lý, cũng có thể sử dụng hệ thống như Doctor
- [A3] Không cần tích hợp SSO/OAuth bên ngoài ở v1.0
- [A4] Password policy cơ bản: tối thiểu 8 ký tự
- [A5] Không cần 2FA/MFA ở v1.0 (quy mô nhỏ, mạng nội bộ)
- [A6] Session timeout hợp lý cho bệnh viện: ~8 giờ (1 ca làm việc) hoặc dùng refresh token

### Câu hỏi mở (Open Questions — cần confirm từ stakeholder)
- [Q1] Admin có thể xóa vĩnh viễn tài khoản hay chỉ vô hiệu hóa (soft delete)?
- [Q2] Khi bác sĩ quên mật khẩu, quy trình reset là gì? (Admin reset thủ công hay gửi email?)
- [Q3] Có cần audit log ghi lại ai đăng nhập lúc nào không?

---

*Tài liệu này được tạo bởi AI Agent, cần Human review và confirm các Assumptions & Open Questions trước khi chuyển sang Pha 1 (Specification).*
