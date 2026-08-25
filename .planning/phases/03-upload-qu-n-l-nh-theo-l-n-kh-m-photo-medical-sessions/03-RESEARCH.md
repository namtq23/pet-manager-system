# Phase 3 Research: Upload & Quản lý ảnh theo Lần khám (Photo & Medical Sessions)

## Technical Architecture & Best Practices

### 1. Supabase Storage & Migration Strategy
- **Migration SQL:**
  - Bảng `public.medical_sessions` lưu trữ thông tin đợt khám.
  - Bảng `public.medical_photos` lưu metadata ảnh (gồm `storage_path` và `public_url`).
  - Bucket `medical-photos` cấu hình RLS chỉ cho phép bác sĩ `ACTIVE` upload/download/delete.
- **Indexes:**
  - `idx_medical_sessions_pet_id` trên `pet_id`
  - `idx_medical_photos_session_id` trên `session_id`

### 2. Client-Side Image Compression & Picker in Flutter Web
- Dùng package `image_picker` cho Flutter Web (hỗ trợ cả camera chụp ảnh và thư viện file).
- Client-side compression trước khi upload: nén ảnh về kích thước tối đa 1920px chiều rộng/cao, định dạng JPEG chất lượng 85% để đảm bảo dung lượng file < 1MB.

### 3. State Management & Repositories
- `MedicalSessionRepository`: CRUD lần khám (PostgreSQL).
- `MedicalPhotoRepository`: Upload ảnh lên Supabase Storage bucket `medical-photos` và chèn record vào `medical_photos`.
- Controllers (`MedicalSessionController`, `PhotoUploadController`) quản lý trạng thái tải ảnh và danh sách lần khám.

### 4. UI Components & Responsive Layout
- `MedicalSessionCard`: Card hiển thị từng đợt khám với danh sách thumbnail ảnh.
- `CreateSessionDialog`: Form nhập tiêu đề, chẩn đoán, ghi chú kèm bộ chọn nhiều ảnh.
- `PhotoLightboxViewer`: Xem ảnh phóng to toàn màn hình khi click vào thumbnail.
