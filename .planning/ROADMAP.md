# Roadmap — Pet Photo Manager (v1.0)

## Overview

Roadmap chia làm 4 Phase theo mô hình Vertical MVP để nhanh chóng mang lại giá trị cốt lõi cho bệnh viện thú y.

## Phases

### Phase 1: Nền tảng & Xác thực bác sĩ (Foundation & Auth)
**Goal:** Khởi tạo cấu trúc dự án Flutter Web + Backend DB (PostgreSQL), xây dựng luồng Đăng nhập và Quản lý phiên làm việc cho 5-15 bác sĩ.
**Requirements:** AUTH-01, AUTH-02, AUTH-03
**Success Criteria:**
1. Dự án chạy được trên Flutter Web & kết nối PostgreSQL thành công.
2. Bác sĩ có thể đăng nhập/đăng xuất an toàn.
3. Thông tin bác sĩ đang đăng nhập được lưu trữ trong session và đính kèm vào các thao tác sau này.

### Phase 2: Quản lý Khách hàng & Thú cưng (Customer & Pet Management)
**Goal:** Xây dựng quản lý Hồ sơ chủ nuôi (khách hàng) và Thú cưng (cún), cùng tính năng tra cứu nhanh bằng SĐT.
**Requirements:** CUST-01, CUST-02, CUST-03
**Success Criteria:**
1. Bác sĩ có thể thêm/sửa/xem danh sách khách hàng (Tên, SĐT, Địa chỉ).
2. Tạo và liên kết nhiều thú cưng cho 1 chủ nuôi (Tên, Giống, Tuổi, Cân nặng).
3. Nhập SĐT chủ nuôi trên ô tìm kiếm trả về chính xác danh sách cún của chủ đó.

### Phase 3: Upload & Quản lý ảnh theo Lần khám (Photo & Medical Sessions)
**Goal:** Cho phép tải ảnh lên / chụp ảnh từ camera thiết bị di động, nhóm ảnh theo từng lần khám và gắn ghi chú triệu chứng/tình trạng.
**Requirements:** PHOTO-01, PHOTO-02, PHOTO-03
**Success Criteria:**
1. Chụp ảnh trực tiếp từ camera điện thoại hoặc chọn ảnh từ thư viện web thành công.
2. Tạo lần khám mới (Lần 1, Lần 2...) cho cún và đính kèm danh sách ảnh.
3. Thêm/sửa ghi chú chi tiết về triệu chứng/tình trạng bệnh kèm theo từng đợt ảnh.

### Phase 4: Timeline ảnh & Tối ưu Responsive (Timeline & UX)
**Goal:** Hiển thị Timeline so sánh ảnh trước/sau điều trị và hoàn thiện giao diện responsive trên Điện thoại & PC.
**Requirements:** PHOTO-04
**Success Criteria:**
1. Xem lại toàn bộ tiến trình điều trị của cún dưới dạng Timeline trực quan (ảnh trước vs ảnh sau).
2. Giao diện tối ưu hoàn hảo trên trình duyệt điện thoại (chụp/up ảnh nhanh) và máy tính (xem timeline/tra cứu).

## Progress

- Total Phases: 4
- Completed Phases: 0
- Progress: 0%

---
*Roadmap defined: 2026-08-24*
