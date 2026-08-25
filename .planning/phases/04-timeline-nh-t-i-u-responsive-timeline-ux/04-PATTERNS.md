# Pattern Map: Phase 4 (Timeline & Responsive UX)

Tài liệu ánh xạ các file/component hiện có trong codebase làm mẫu cho việc triển khai Phase 4.

## Existing Code Analogs

### 1. Controllers & State Management
- **Analog**: `frontend/lib/features/photo/controllers/medical_session_controller.dart`
- **Application**: Dùng làm mẫu cấu trúc cho `TimelineController` (kế thừa `ChangeNotifier`, quản lý danh sách `medical_sessions`, danh sách ảnh `medical_photos` và trạng thái 2 ảnh so sánh `beforePhoto` / `afterPhoto`).

### 2. UI Widgets & Views
- **Analog**: `frontend/lib/features/photo/views/widgets/medical_session_card.dart`
- **Application**: Tái sử dụng và bọc trong `TimelineSessionCard` để hiển thị trong Timeline view.
- **Analog**: `frontend/lib/features/photo/views/pet_medical_history_tab.dart`
- **Application**: Dùng làm khung mẫu cho `PetTimelineScreen` (tích hợp bộ lọc đợt khám, toggle xem theo Timeline hoặc Grid).

### 3. Lightbox & Image Viewer
- **Analog**: `frontend/lib/features/photo/views/widgets/photo_lightbox_viewer.dart`
- **Application**: Dùng làm tham chiếu cho việc dựng `BeforeAfterComparisonViewer` (hỗ trợ hiển thị ảnh phóng to, thông tin `caption`, `taken_at`).

### 4. Unit & Widget Tests
- **Analog**: `frontend/test/auth_test.dart` & `frontend/test/admin_user_mgmt_test.dart`
- **Application**: Cấu trúc file test, mock Supabase client, kiểm tra giới hạn 30 dòng và bổ sung Ma trận kiểm thử Traceability Matrix ở cuối file test.
