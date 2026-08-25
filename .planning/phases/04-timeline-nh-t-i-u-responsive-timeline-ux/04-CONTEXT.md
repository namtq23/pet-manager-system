# Phase 4 Context: Timeline ảnh & Tối ưu Responsive (Timeline & UX)

## Executive Summary
Phase 4 tập trung vào việc hoàn thiện trải nghiệm người dùng cuối cho ứng dụng Pet Photo Manager:
1. **Chức năng so sánh tiến trình điều trị (PHOTO-04)**: Xây dựng màn hình Timeline tổng thể cho từng thú cưng, hiển thị trực quan các Lần khám theo dòng thời gian và cho phép so sánh Before / After giữa 2 bức ảnh bất kỳ từ các đợt khám khác nhau.
2. **Tối ưu Responsive UX (Mobile & PC Web)**: Chuẩn hóa layout thích ứng linh hoạt giữa màn hình cảm ứng di động (thao tác 1 tay, bottom sheet, touch swipe) và màn hình máy tính (multi-column, split view, keyboard shortcuts).

## Locked Technical & Business Decisions

### 1. Scope & Requirements
- **PHOTO-04**: Hiển thị Timeline ảnh trực quan cho phép so sánh ảnh trước/sau điều trị.
  - **Medical Photo Timeline**: Hiển thị chuỗi các `medical_sessions` của một `pet_id` theo dạng trục thời gian (vertical timeline) tích hợp thumbnail ảnh, ghi chú chẩn đoán, ngày khám.
  - **Before / After Photo Comparison**: Cho phép chọn 2 ảnh (ảnh ban đầu & ảnh tái khám) để so sánh song song (Side-by-Side) hoặc vuốt trượt đè lên nhau (Slider Overlay Comparison).
- **Responsive & UX Optimization**:
  - **Mobile Layout (<600px)**: Thẻ compact, xem dọc mượt mà, modal bottom sheet cho bộ lọc & chọn ảnh so sánh.
  - **Desktop Layout (≥600px)**: Multi-column view (Cột trái: Lịch sử khám; Cột phải: Timeline & Comparison Viewer).

### 2. Architecture & Components (Flutter Web)
- **Repositories & State Management**:
  - Tận dụng `MedicalSessionRepository` & `MedicalPhotoRepository` hiện có.
  - Xây dựng `TimelineController` / `ComparisonController` để quản lý trạng thái chọn ảnh so sánh (`beforePhoto`, `afterPhoto`), chế độ hiển thị (Timeline List vs Comparison Mode).
- **UI Components & Views**:
  - `PetTimelineScreen` / `PetTimelineView`: Trục thời gian hiển thị đợt khám và ảnh.
  - `ImageComparisonViewer`: Widget so sánh Before / After (Side-by-Side & Interactive Split Slider).
  - `ResponsiveLayoutBuilder`: Utility / Widget hỗ trợ phân tách layout Mobile & Desktop.

### 3. Standards & Quality Rules (`.spec/CLAUDE.md`)
- Hàm UI/Controller < 30 dòng.
- Xử lý lỗi đầy đủ, tiếng Việt thân thiện.
- Unit / Widget / Integration tests cho Timeline & Comparison mode.
- EARS tag annotations & Traceability Matrix trong test files.
