# Bệnh Viện Thú Y Mỹ Đình - Hệ Thống Quản Lý Hồ Sơ & Tiến Trình Ảnh Thú Cưng

## What This Is

Hệ thống web app cho **Bệnh Viện Thú Y Mỹ Đình**, giúp bác sĩ lưu trữ và tra cứu ảnh tiến trình điều trị của thú cưng. Bác sĩ chụp ảnh trực tiếp hoặc upload, gắn vào hồ sơ từng con thú cưng, và tra cứu nhanh bằng số điện thoại chủ. Hệ thống hiển thị timeline ảnh trước/sau để đánh giá tiến triển bệnh.

## Core Value

Bác sĩ có thể tra cứu ngay ảnh tiến trình điều trị của bất kỳ thú cưng nào khi khách hàng hỏi về tình trạng bệnh — thay vì lục tìm ảnh rải rác trên điện thoại cá nhân.

## Current State

Shipped **v1.0 — Pet Photo Manager** (2026-08-25).
Hệ thống hoàn chỉnh luồng Đăng nhập bác sĩ, Quản lý chủ nuôi/cún, Chụp & Upload ảnh theo lần khám, Timeline so sánh Trước/Sau và Tối ưu Responsive 100%.

## Requirements

### Validated

- ✓ **AUTH-01**: Đăng nhập bằng tài khoản bác sĩ — v1.0
- ✓ **AUTH-02**: Quản lý tài khoản bác sĩ & Phân quyền Admin — v1.0
- ✓ **AUTH-03**: Duy trì phiên làm việc & Lưu trữ thông tin bác sĩ thao tác — v1.0
- ✓ **CUST-01**: Quản lý khách hàng (Chủ nuôi): Tên, SĐT, Địa chỉ — v1.0
- ✓ **CUST-02**: Quản lý thú cưng: Tên, Giống, Tuổi, Cân nặng — v1.0
- ✓ **CUST-03**: Tra cứu nhanh bằng SĐT chủ nuôi ➔ Danh sách cún — v1.0
- ✓ **PHOTO-01**: Upload / Chụp ảnh trực tiếp từ thiết bị di động — v1.0
- ✓ **PHOTO-02**: Nhóm ảnh theo từng Lần khám — v1.0
- ✓ **PHOTO-03**: Ghi chú chẩn đoán/triệu chứng kèm theo đợt ảnh — v1.0
- ✓ **PHOTO-04**: Timeline ảnh trực quan & So sánh Trước/Sau điều trị — v1.0

### Active

<!-- Scope for v2.0 milestone -->

- [ ] **ANAL-01**: Xuất báo cáo hình ảnh tiến triển điều trị dạng PDF/Link gửi chủ nuôi
- [ ] **ANAL-02**: Tìm kiếm ảnh nâng cao theo loại bệnh / triệu chứng

### Out of Scope

- Hồ sơ bệnh chi tiết (đơn thuốc, chẩn đoán) — không phải phần mềm quản lý bệnh viện, chỉ tập trung ảnh + tra cứu
- Mobile app native — v1 là web app responsive, truy cập qua trình duyệt điện thoại
- Chat/tin nhắn giữa bác sĩ và chủ — ngoài phạm vi, dùng Zalo/SMS hiện tại
- Thanh toán/hóa đơn — hệ thống riêng biệt

## Context

- Bệnh viện thú y quy mô trung bình (5-15 bác sĩ)
- Web app responsive hoạt động tốt trên cả điện thoại di động và máy tính
- Tech stack: Flutter Web + Supabase (PostgreSQL BaaS, Storage, RLS)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Flutter Web + Supabase (PostgreSQL) | Đơn giản hóa kiến trúc (BaaS), bảo mật RLS, tích hợp sẵn Auth & Storage | ✓ Good |
| Web app (không mobile native) | Giảm phức tạp v1, responsive thay thế | ✓ Good |
| Tập trung ảnh + tra cứu | Giải quyết đúng pain point, tránh scope creep | ✓ Good |

---
*Last updated: 2026-08-25 after v1.0 milestone close*
