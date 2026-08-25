# Requirements: Pet Photo Manager

**Defined:** 2026-08-24
**Core Value:** Bác sĩ có thể tra cứu ngay ảnh tiến trình điều trị của bất kỳ thú cưng nào khi khách hàng hỏi về tình trạng bệnh — thay vì lục tìm ảnh rải rác trên điện thoại cá nhân.

## v1 Requirements

### Authentication & User Management

- [x] **AUTH-01**: Bác sĩ có thể đăng nhập bằng tài khoản (email/username + mật khẩu)
- [x] **AUTH-02**: Quản lý tài khoản bác sĩ (5-15 bác sĩ, phân quyền cơ bản)
- [x] **AUTH-03**: Duy trì phiên đăng nhập và ghi nhận thông tin bác sĩ thực hiện các thao tác (upload ảnh, cập nhật hồ sơ)

### Customer & Pet Management

- [x] **CUST-01**: Bác sĩ có thể quản lý thông tin khách hàng (chủ nuôi): Tên, SĐT, Địa chỉ
- [x] **CUST-02**: Bác sĩ có thể quản lý thông tin thú cưng: Tên, Giống, Tuổi, Cân nặng (1 chủ nuôi có thể có nhiều cún)
- [x] **CUST-03**: Tra cứu thông tin nhanh bằng Số điện thoại chủ nuôi ➔ Danh sách cún liên quan

### Photo & Treatment Management

- [x] **PHOTO-01**: Bác sĩ có thể upload ảnh hoặc chụp ảnh trực tiếp từ thiết bị di động (Web responsive)
- [x] **PHOTO-02**: Nhóm ảnh theo từng lần khám (Lần 1, Lần 2, Lần 3...)
- [x] **PHOTO-03**: Ghi chú theo từng ảnh / lần khám: triệu chứng, tình trạng bệnh, đánh giá tiến triển
- [x] **PHOTO-04**: Hiển thị Timeline ảnh trực quan cho phép so sánh ảnh trước/sau điều trị

## v2 Requirements

### Analytics & Export

- **ANAL-01**: Xuất báo cáo hình ảnh tiến triển điều trị dạng PDF/Link cho chủ nuôi
- **ANAL-02**: Tìm kiếm ảnh nâng cao theo loại bệnh / triệu chứng

## Out of Scope

| Feature | Reason |
|---------|--------|
| Hồ sơ bệnh chi tiết (đơn thuốc, chẩn đoán chi tiết) | Không phải phần mềm quản lý bệnh viện tổng thể, tập trung vào ảnh + tra cứu |
| Mobile app native | v1 là Web app responsive chạy tốt trên điện thoại |
| Chat / nhắn tin trực tiếp với chủ | Đã dùng Zalo/SMS hiện tại |
| Thanh toán / Hóa đơn | Hệ thống thanh toán riêng biệt |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | Phase 1 | Complete |
| AUTH-02 | Phase 1 | Complete |
| AUTH-03 | Phase 1 | Complete |
| CUST-01 | Phase 2 | Complete |
| CUST-02 | Phase 2 | Complete |
| CUST-03 | Phase 2 | Complete |
| PHOTO-01 | Phase 3 | Complete |
| PHOTO-02 | Phase 3 | Complete |
| PHOTO-03 | Phase 3 | Complete |
| PHOTO-04 | Phase 4 | Complete |

**Coverage:**
- v1 requirements: 10 total
- Mapped to phases: 10
- Unmapped: 0 ✓

---
*Requirements defined: 2026-08-24*
*Last updated: 2026-08-24 after Phase 3 completion*
