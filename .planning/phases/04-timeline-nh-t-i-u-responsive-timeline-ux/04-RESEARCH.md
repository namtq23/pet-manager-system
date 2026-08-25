# Phase 4 Research: Timeline ảnh & Tối ưu Responsive (Timeline & UX)

## Executive Summary
Phase 4 hoàn thiện tính năng hiển thị Timeline tiến triển bệnh của cún và so sánh ảnh Before/After (PHOTO-04), đồng thời tối ưu hóa giao diện responsive cho cả thiết bị di động (Mobile Web) và máy tính (Desktop Web). 

Tài liệu nghiên cứu này phân tích cấu trúc kỹ thuật, lựa chọn component/widget cho Flutter Web, chiến lược xử lý responsive, tối ưu hiệu năng hiển thị hình ảnh và phương án kiểm thử.

---

## 1. Technical Stack & Component Architecture

### 1.1. Vertical Timeline Component
- **Mục tiêu**: Hiển thị chuỗi các `MedicalSession` của thú cưng theo thứ tự thời gian giảm dần (mới nhất ở trên), nối với nhau bằng trục thời gian dọc.
- **Phương án Kỹ thuật**: Sử dụng thuần Custom Flutter Widgets với `ListView.builder` + CustomPainter/Stack hoặc bọc từng item trong đường nối dọc (Connector Line & Circle Node).
  - *Lý do chọn Custom Widget*: Không cần cài thêm dependency bên ngoài, tùy biến hoàn toàn theo theme của app, dễ dàng đưa `MedicalSessionCard` đã có ở Phase 3 vào khung timeline.
  - *Cấu trúc*:
    - `TimelineNode`: Điểm tròn hiển thị ngày tháng hoặc icon lần khám.
    - `TimelineConnector`: Đường nối đứt đoạn hoặc nét liền giữa các lần khám.
    - `TimelineSessionCard`: Bọc `MedicalSessionCard` đính kèm thumbnail ảnh và nút chọn ảnh vào chế độ So sánh (Compare).

### 1.2. Before / After Image Comparison Component
- **Mục tiêu**: Cho phép bác sĩ chọn 2 bức ảnh bất kỳ (từ cùng đợt khám hoặc giữa đợt khám đầu vs đợt tái khám) để so sánh vết thương/tiến triển.
- **Phương án Kỹ thuật**:
  - **Chế độ 1: Side-by-Side View (So sánh song song)**: Đặt 2 ảnh nằm cạnh nhau trên màn hình PC hoặc trên/dưới trên Mobile, cho phép bật/tắt ghi chú (`caption`) và thông tin ngày chụp (`taken_at`).
  - **Chế độ 2: Interactive Split Slider (Kéo thanh trượt đè ảnh)**: Dùng Custom `GestureDetector` + `ClipRect` để kéo thanh chia dọc (Divider), cho phép so sánh chính xác từng mm vết thương trước và sau điều trị.

### 1.3. Responsive Layout Strategy (Mobile vs PC Web)
- **Breakpoints**:
  - `Mobile`: Max width < 600px (Điện thoại thông minh).
  - `Desktop / Tablet`: Min width ≥ 600px (Máy tính bảng, Laptop, PC màn hình rộng).
- **Layout Patterns**:
  - **Mobile (<600px)**:
    - Tab bar / Navigation bar chuyển đổi giữa Lịch sử đợt khám & Timeline So sánh.
    - Bottom Sheet cho bảng chọn ảnh so sánh.
    - So sánh Before/After xếp theo chiều dọc hoặc dùng Slider full chiều rộng.
  - **Desktop (≥600px)**:
    - Split View (Cột trái 35%: Danh sách lần khám & Timeline summary; Cột phải 65%: Khung so sánh Before/After lớn + Lightbox phóng to).

---

## 2. Hiệu năng & Tối ưu Hình ảnh (Image Performance on Flutter Web)

1. **Caching & Thumbnail Rendering**:
   - Sử dụng `Image.network` với `cacheWidth` / `cacheHeight` khi dựng lưới thumbnail để tránh load ảnh nguyên kích thước (full-res) gây tràn RAM trình duyệt.
   - Chỉ load full resolution khi bác sĩ mở Lightbox hoặc vào màn hình so sánh chi tiết.
2. **Cơ chế Chọn Ảnh So Sánh (Selection State)**:
   - Quản lý trạng thái chọn ảnh bằng `TimelineController` (dùng `ChangeNotifier` / `ValueNotifier`).
   - Lưu trữ tạm `beforePhoto` (Ảnh trước) và `afterPhoto` (Ảnh sau). Khi chọn đủ 2 ảnh, tự động kích hoạt nút "So sánh ngay".

---

## 3. Validation Architecture & Test Strategy

Dựa trên yêu cầu kiểm thử và tiêu chuẩn dự án (`.spec/CLAUDE.md`), Phase 4 sẽ bao gồm:
1. **Unit Tests**:
   - `TimelineControllerTest`: Kiểm tra logic chọn/bỏ chọn 2 ảnh so sánh, validate ảnh trước (Before - ngày cũ hơn) và ảnh sau (After - ngày mới hơn).
2. **Widget Tests**:
   - `PetTimelineScreenTest`: Verify danh sách các đợt khám hiển thị đúng thứ tự thời gian.
   - `BeforeAfterComparisonTest`: Verify tương tác thanh trượt slider so sánh ảnh và hiển thị thông tin metadata ảnh.
   - `ResponsiveLayoutTest`: Verify chuyển đổi layout linh hoạt khi thay đổi kích thước màn hình (MediaQueries / Constraints).
3. **Traceability Matrix**:
   - Ánh xạ trực tiếp requirement `PHOTO-04` vào toàn bộ test cases.

---

## ## RESEARCH COMPLETE
