# Phase 3 Context: Upload & Quản lý ảnh theo Lần khám (Photo & Medical Sessions)

## Executive Summary
Phase 3 chịu trách nhiệm xây dựng module **Tạo & Quản lý Lần khám (Medical Sessions)** cho từng cún, cho phép bác sĩ upload/chụp ảnh trực tiếp từ thiết bị di động/PC vào Supabase Storage (`medical-photos`), đồng thời đính kèm ghi chú triệu chứng & diễn biến bệnh dựa trên bản đặc tả **FT-003** (`.spec/specs/photo-session/SPEC.md`).

## Locked Technical & Business Decisions

### 1. Requirements Scope
- **PHOTO-01**: Upload & Quản lý ảnh khám bệnh — Cho phép bác sĩ chọn ảnh từ thư viện hoặc chụp trực tiếp từ camera di động trên Flutter Web, nén ảnh client-side (<1MB), lưu trữ trên Supabase Storage bucket `medical-photos` và quản lý metadata bảng `medical_photos`.
- **PHOTO-02**: Quản lý Lần khám (Medical Sessions) — Nhóm ảnh theo từng đợt khám (`medical_sessions`) liên kết 1-nhiều với cún (`pets.id`), lưu Tiêu đề, Chẩn đoán, Ghi chú diễn tiến.
- **PHOTO-03**: Ghi chú triệu chứng & Tiến triển — Ghi chú ở 2 cấp độ: Tổng quan đợt khám (`medical_sessions.notes`/`diagnosis`) và Chi tiết theo từng bức ảnh (`medical_photos.caption`).

### 2. Architecture & Tech Stack (Flutter Web + Supabase Storage & Database)
- **Database Schema (Supabase PostgreSQL)**:
  - Bảng `public.medical_sessions` (`id`, `pet_id`, `session_date`, `title`, `diagnosis`, `notes`, `created_at`, `updated_at`, `created_by`).
  - Bảng `public.medical_photos` (`id`, `session_id`, `storage_path`, `public_url`, `caption`, `taken_at`, `created_at`, `created_by`).
  - Supabase Storage Bucket `medical-photos` công khai/authenticated view.
  - Row Level Security (RLS): Chỉ bác sĩ/admin có `status = 'ACTIVE'` mới có quyền Đọc/Thêm/Xóa.
- **Frontend (Flutter Web)**:
  - Utility: `ImageCompressor` (Tối ưu/nén ảnh client-side max 1920px, JPEG 85% trước khi up).
  - Repositories: `MedicalSessionRepository`, `MedicalPhotoRepository` (thao tác Supabase Database & Storage).
  - State Management: `MedicalSessionController`, `PhotoUploadController`.
  - Views / UI Components:
    - `PetMedicalHistoryTab` / `MedicalSessionCard` (Danh sách các lần khám xếp theo thời gian mới nhất).
    - `CreateSessionDialog` / `SessionDetailScreen` (Modal tạo đợt khám + picker chọn/chụp nhiều ảnh).
    - `PhotoGalleryGrid` + `PhotoLightboxViewer` (Lưới xem ảnh đợt khám & xem phóng to full screen).

### 3. Code Standards & Quality Rules (`.spec/CLAUDE.md`)
- **Giới hạn 30 dòng**: Giữ mọi hàm UI và Repository < 30 dòng.
- **Xử lý lỗi**: Bắt lỗi upload storage/database exception và map sang thông báo tiếng Việt (`INVALID_FILE_TYPE`, `FILE_TOO_LARGE`, `STORAGE_UPLOAD_FAILED`).
- **EARS Notation**: Gắn comment EARS trong business logic tương ứng với `FT-003 SPEC`.
- **Traceability Matrix**: Ma trận kiểm thử cuối file test ánh xạ requirement IDs (`PHOTO-01`, `PHOTO-02`, `PHOTO-03`).
