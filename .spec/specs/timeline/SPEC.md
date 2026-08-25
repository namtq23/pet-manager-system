# Specification: Timeline ảnh & Tối ưu Responsive (FT-004)

---

## 📑 Thông Tin Kiểm Soát (Metadata Header)

| Thuộc tính | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Feature ID** | `FT-004` | Module Timeline tiến triển & So sánh ảnh Before/After |
| **Version** | `1.0.0` | Bản đặc tả locked và approved |
| **Status** | `APPROVED` | Đã được phê duyệt |
| **Owner** | `@admin` | Người chịu trách nhiệm chính |
| **Approved By**| `@user` | Khách hàng / Lead Dev |
| **Milestone** | `v1.0 — Pet Photo Manager` | Milestone phát hành v1.0 |
| **Git Tag** | `spec/timeline/v1.0.0` | Tag git cho bản spec locked |

---

## 🎯 1. Bối Cảnh & Mục Tiêu (Context & Goal - WHY)

### 1.1. Bối cảnh Nghiệp vụ (Business Context)
Bác sĩ thú y cần xem toàn bộ lịch sử tiến trình điều trị của cún qua các đợt khám dưới dạng Timeline trực quan, đồng thời so sánh 2 bức ảnh bất kỳ (ảnh Before trước điều trị vs ảnh After sau điều trị) để đánh giá hiệu quả và giải thích trực tiếp cho chủ nuôi.
- **Nỗi đau hiện tại:** Phải xem rải rác từng đợt khám và từng ảnh riêng lẻ, khó đối chiếu trực quan vết thương trước và sau khi dùng thuốc/phẫu thuật.
- **Giải pháp:** 
  1. Trục thời gian (Vertical Timeline) xếp theo đợt khám.
  2. Khung so sánh ảnh (Before/After Comparison Viewer) hỗ trợ cả dạng Side-by-Side (Song song) và Interactive Slider (Kéo trượt đè ảnh).
  3. Tối ưu giao diện Responsive mượt mà trên Mobile Web (<600px) và PC Web (≥600px).

### 1.2. Thước đo Thành công (Success Metrics)

| Chỉ số | Mục tiêu | Cách đo |
|--------|----------|---------|
| Thời gian tải & dựng Timeline | < 500ms | UI Benchmark Test |
| Độ mượt thanh trượt so sánh ảnh | 60 FPS trên thiết bị di động | Flutter Performance Profiler |
| Khả năng hiển thị Responsive | Hoạt động tốt từ 360px đến 1920px+ | Responsive UI Tests |

---

## 👥 2. Tác Nhân & Vai Trò (Actors & Roles)

| Actor | Quyền hạn |
|-------|-----------|
| **Doctor** | Xem Timeline, chọn ảnh Before/After, kéo thanh trượt so sánh ảnh, xem ghi chú chẩn đoán đi kèm. |
| **Admin** | Toàn quyền sử dụng các chức năng của Doctor. |

---

## 📋 3. Yêu Cầu Chức Năng (Functional Requirements - WHAT)

### 3.1. Timeline Tiến Trình Điều Trị (PHOTO-04)
- **EARS[Ubiquitous]:** THE hệ thống SHALL hiển thị danh sách các `medical_sessions` của một `pet_id` dưới dạng trục thời gian dọc (Vertical Timeline), sắp xếp theo ngày khám giảm dần (mới nhất ở trên).
- **EARS[Event]:** WHEN Bác sĩ chọn 1 điểm đợt khám trên Timeline, THE hệ thống SHALL hiển thị thông tin tiêu đề, chẩn đoán, ngày khám và danh sách thumbnail ảnh thuộc đợt khám đó.

### 3.2. So Sánh Ảnh Before / After (PHOTO-04)
- **EARS[Event]:** WHEN Bác sĩ chọn 1 ảnh làm "Ảnh trước" (Before) và 1 ảnh làm "Ảnh sau" (After), THE hệ thống SHALL kích hoạt chế độ so sánh ảnh.
- **EARS[Ubiquitous]:** THE hệ thống SHALL hỗ trợ 2 chế độ xem so sánh:
  1. **Side-by-Side View**: Đặt 2 ảnh nằm cạnh nhau (trên PC) hoặc xếp dọc (trên Mobile) kèm metadata (ngày chụp, ghi chú).
  2. **Interactive Slider Overlay**: Hiển thị 2 ảnh chồng lên nhau với thanh trượt kéo qua lại để xem sự thay đổi chi tiết vết thương.

### 3.3. Responsive Layout (UX Optimization)
- **EARS[State]:** WHILE màn hình có chiều rộng < 600px (Mobile), THE hệ thống SHALL hiển thị giao diện dạng thẻ cuộn dọc (Single-column layout), tự động điều chỉnh thanh trượt slider vừa khít chiều rộng màn hình.
- **EARS[State]:** WHILE màn hình có chiều rộng ≥ 600px (Desktop), THE hệ thống SHALL hiển thị giao diện dạng 2 cột (Split View: Cột trái xem Timeline summary, Cột phải xem Before/After Viewer phóng to).

---

## 🚀 4. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Phân nhóm | Tiêu chuẩn cụ thể |
| :--- | :--- |
| **Hiệu năng** | Không nạp lại ảnh full-res khi kéo thanh trượt; sử dụng memory cache cho 2 ảnh đang so sánh. |
| **Giao diện** | Tương thích hoàn hảo với màn hình cảm ứng di động (Touch events) và chuột máy tính (Pointer drag). |
| **Code Standard** | Mọi hàm UI Widget & Controller < 30 dòng code theo chuẩn `.spec/CLAUDE.md`. |

---

## ✅ 5. Tiêu Chí Nghiệm Thu (Acceptance Criteria - BDD Format)

### Kịch bản 1: Chọn 2 ảnh và mở màn hình so sánh Before / After (Happy Path)
- **Given:** Bác sĩ đang xem Timeline đợt khám của cún `Miu`.
- **When:** Bác sĩ chọn ảnh 1 ở "Lần 1 - Khám ban đầu" làm `Before` và chọn ảnh 2 ở "Lần 3 - Tái khám" làm `After`, sau đó nhấn "So sánh".
- **Then:** Hệ thống mở giao diện `BeforeAfterComparisonViewer` hiển thị 2 ảnh cùng thanh trượt kéo tương tác mượt mà.

### Kịch bản 2: Tự động điều chỉnh layout trên Mobile và PC (Responsive Path)
- **Given:** Bác sĩ mở ứng dụng trên điện thoại di động (width < 600px).
- **When:** Bác sĩ truy cập trang Timeline của cún.
- **Then:** Giao diện hiển thị dưới dạng 1 cột cuộn mượt mà, thanh slider so sánh vừa vặn khung hình di động.

---

*Document Version: 1.0.0 APPROVED (LOCKED)*
