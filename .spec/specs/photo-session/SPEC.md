# Specification: Photo & Medical Sessions Management (FT-003)

---

## 📑 Thông Tin Kiểm Soát (Metadata Header)

| Thuộc tính | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Feature ID** | `FT-003` | Module Upload & Quản lý ảnh theo Lần khám y tế |
| **Version** | `1.0.0` | Bản đặc tả locked và approved |
| **Status** | `APPROVED` | Đã được phê duyệt |
| **Owner** | `@admin` | Người chịu trách nhiệm chính |
| **Approved By**| `@user` | Khách hàng / Lead Dev |
| **Milestone** | `v1.0 — Pet Photo Manager` | Milestone phát hành v1.0 |
| **Git Tag** | `spec/photo-session/v1.0.0` | Tag git cho bản spec locked |

> ⚠️ **Quy tắc vàng (Locked Spec):** Khi bản Spec đã đạt trạng thái `APPROVED`, nghiêm cấm sửa đổi trực tiếp spec trong Sprint hiện tại. Mọi thay đổi phát sinh bắt buộc phải thông qua tài liệu phụ lục (Addendum) hoặc tạo phiên bản mới.

---

## 🎯 1. Bối Cảnh & Mục Tiêu (Context & Goal - WHY)

### 1.1. Bối cảnh Nghiệp vụ (Business Context)
Bác sĩ thú y cần theo dõi tiến triển bệnh của cún qua các đợt khám (Ví dụ: Khám ban đầu, Tái khám sau 3 ngày, Tái khám sau 7 ngày).
- **Nỗi đau hiện tại (Pain Point):** Ảnh chụp tình trạng vết thương, bệnh da liễu hoặc phẫu thuật của cún bị rải rác trên điện thoại cá nhân của các bác sĩ. Không có cách nào gom nhóm ảnh theo từng đợt khám và gắn ghi chú diễn biến bệnh, dẫn đến khó khăn khi đánh giá hiệu quả điều trị hoặc khi bàn giao ca trực cho bác sĩ khác.
- **Giải pháp:** Xây dựng tính năng tạo **Lần khám (Medical Session)** cho từng cún, cho phép bác sĩ chụp/upload danh sách ảnh trực tiếp từ thiết bị di động hoặc máy tính vào đợt khám đó, đồng thời ghi chú chi tiết triệu chứng & tiến triển bệnh.

### 1.2. Thước đo Thành công (Success Metrics)

| Chỉ số | Mục tiêu | Cách đo |
|--------|----------|---------|
| Thời gian upload 1-5 ảnh / Lần khám | < 3 giây (trên mạng 4G/Wifi tiêu chuẩn) | UI Performance Benchmark |
| Tỷ lệ upload ảnh thành công | > 99% | Integration Test & Supabase Storage Log |
| Trải nghiệm chụp/up ảnh trên Mobile Web | Chụp trực tiếp từ camera hoặc chọn thư viện mượt mà | Manual E2E Testing |

---

## 👥 2. Tác Nhân & Vai Trò (Actors & Roles)

### 2.1. Tác nhân Trong phạm vi (In-Scope Actors)

| Actor | Mô tả | Quyền hạn |
|-------|-------|-----------|
| **Doctor** | Bác sĩ thú y — người dùng chính. | Tạo Lần khám, upload/chụp ảnh, nhập ghi chú triệu chứng, xem lịch sử các lần khám của cún. |
| **Admin** | Quản lý bệnh viện. | Có toàn bộ quyền của Doctor, có thêm quyền xóa đợt khám/ảnh khi cần dọn dẹp dữ liệu. |

### 2.2. Tác nhân Ngoài phạm vi (Actors Out of Scope)

| Actor | Lý do |
|-------|-------|
| **Guest (Chưa đăng nhập)** | SHALL NOT truy cập hoặc xem bất kỳ ảnh/lần khám nào. Bảo vệ bằng Supabase RLS & Storage Security. |
| **Chủ nuôi (Pet Owner)** | Không trực tiếp truy cập hệ thống trong v1.0. |

---

## 📋 3. Yêu Cầu Chức Năng (Functional Requirements - WHAT)

### 3.1. Quản Lý Lần Khám (Medical Sessions - PHOTO-02)

- **EARS[Ubiquitous]:** THE hệ thống SHALL lưu trữ thông tin Lần khám (`medical_sessions`) gồm: `id` (UUID), `pet_id` (UUID, khóa ngoại tham chiếu đến `pets`), `session_date` (TIMESTAMPTZ, mặc định `NOW()`), `title` (Tiêu đề lần khám, ví dụ: "Lần 1 - Khám ban đầu", "Lần 2 - Tái khám"), `diagnosis` (Chẩn đoán / Triệu chứng chính), `notes` (Ghi chú đánh giá tiến triển), `created_at`, `updated_at`, `created_by` (UUID tham chiếu đến `auth.users`).
- **EARS[Event]:** WHEN Bác sĩ tạo Lần khám mới cho cún (`pet_id`), THE hệ thống SHALL tạo bản ghi trong bảng `medical_sessions` và gắn đúng `pet_id`.
- **EARS[Event]:** WHEN Bác sĩ cập nhật thông tin Lần khám (Tiêu đề, Chẩn đoán, Ghi chú), THE hệ thống SHALL cập nhật dữ liệu và thời gian `updated_at`.
- **EARS[Event]:** WHEN Bác sĩ xóa một Lần khám, THE hệ thống SHALL tự động xóa toàn bộ file ảnh thuộc lần khám đó trong Supabase Storage và xóa các bản ghi trong bảng `medical_photos` (Cascade Delete).

### 3.2. Upload & Quản Lý Ảnh Khám Bệnh (Photo Upload & Storage - PHOTO-01)

- **EARS[Ubiquitous]:** THE hệ thống SHALL lưu trữ thông tin Ảnh khám bệnh (`medical_photos`) gồm: `id` (UUID), `session_id` (UUID, khóa ngoại tham chiếu đến `medical_sessions`), `storage_path` (Đường dẫn file trong Supabase Storage bucket `medical-photos`), `public_url` (URL công khai để hiển thị ảnh), `caption` (Ghi chú riêng cho từng ảnh), `taken_at` (TIMESTAMPTZ), `created_at`, `created_by`.
- **EARS[Event]:** WHEN Bác sĩ chọn ảnh từ thư viện hoặc chụp ảnh trực tiếp từ Camera di động trên Flutter Web, THE hệ thống SHALL tối ưu/nén ảnh client-side và upload lên Supabase Storage bucket `medical-photos`.
- **EARS[Event]:** WHEN file ảnh upload thành công lên Supabase Storage, THE hệ thống SHALL tạo bản ghi lưu thông tin metadata ảnh vào bảng `medical_photos` đính kèm `session_id`.
- **EARS[Unwanted]:** WHERE file chọn upload không thuộc các định dạng ảnh hợp lệ (`image/jpeg`, `image/png`, `image/webp`, `image/heic`) hoặc dung lượng file gốc > 10MB, THE hệ thống SHALL từ chối tải lên và hiển thị lỗi `INVALID_FILE_TYPE` hoặc `FILE_TOO_LARGE`.
- **EARS[Event]:** WHEN Bác sĩ thực hiện xóa 1 bức ảnh khỏi lần khám, THE hệ thống SHALL xóa file ảnh khỏi Supabase Storage và xóa bản ghi `medical_photos` tương ứng.

### 3.3. Ghi Chú Triệu Chứng & Tiến Triển (Session & Photo Notes - PHOTO-03)

- **EARS[Ubiquitous]:** THE hệ thống SHALL hỗ trợ gắn ghi chú ở 2 cấp độ:
  1. Ghi chú tổng quan đợt khám (`medical_sessions.notes` / `diagnosis`): ghi nhận diễn biến tổng thể, chẩn đoán, phác đồ.
  2. Ghi chú chi tiết theo từng ảnh (`medical_photos.caption`): ghi chú cụ thể vị trí tổn thương hoặc trạng thái vết thương tại thời điểm chụp ảnh đó.
- **EARS[Event]:** WHEN Bác sĩ thêm hoặc sửa ghi chú cho ảnh/lần khám, THE hệ thống SHALL lưu ngay thay đổi vào database.

### 3.4. Bảo Vệ Dữ Liệu & Phân Quyền Storage (Authorization & Security)

- **EARS[Ubiquitous]:** THE hệ thống SHALL bảo vệ bảng `medical_sessions`, `medical_photos` và Supabase Storage Bucket `medical-photos` bằng Row Level Security (RLS). Chỉ Bác sĩ/Admin có tài khoản trạng thái `ACTIVE` mới có quyền Đọc / Thêm / Sửa / Xóa.
- **EARS[State]:** WHILE tài khoản Bác sĩ ở trạng thái `INACTIVE`, THE hệ thống SHALL từ chối mọi thao tác đọc/ghi vào dữ liệu lần khám và ảnh.

---

## 🚀 4. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Phân nhóm | Tiêu chuẩn cụ thể | Phương pháp đo lường |
| :--- | :--- | :--- |
| **Hiệu năng** | Đọc danh sách ảnh & hiển thị thumbnail của Lần khám SHALL có Latency < 500ms. | UI Benchmark Test |
| **Tối ưu Băng thông** | Ảnh trước khi upload SHALL được nén client-side (target max width/height 1920px, chất lượng JPEG ~85%) để giảm dung lượng file xuống < 1MB. | Client Image Compressor Unit Test |
| **Bảo mật** | Storage Bucket `medical-photos` SHALL áp dụng RLS Policy chỉ cho phép tài khoản bác sĩ active upload/delete file. | Supabase Security Audit |
| **Giao diện** | Giao diện upload & xem lưới ảnh (Photo Grid Gallery) SHALL Responsive trên cả Mobile (360px) và PC (1920px), hỗ trợ preview ảnh toàn màn hình (Lightbox viewer). | Flutter Web Cross-device Test |

---

## 📊 5. Mô Hình Dữ Liệu & API Contracts (Data Model)

### 5.1. Database Schema & Storage Setup (Supabase PostgreSQL)

```sql
-- 1. Bang Lan Kham (Medical Sessions)
CREATE TABLE public.medical_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID NOT NULL REFERENCES public.pets(id) ON DELETE CASCADE,
    session_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    title TEXT NOT NULL, -- Vi du: "Lan 1 - Kham ban dau", "Lan 2 - Tai kham"
    diagnosis TEXT,      -- Chan doan / Trieu chung chinh
    notes TEXT,          -- Ghi chu tien triển dieu tri
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- 2. Bang Anh Kham Benh (Medical Photos)
CREATE TABLE public.medical_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.medical_sessions(id) ON DELETE CASCADE,
    storage_path TEXT NOT NULL, -- Path trong Supabase Storage: "pets/{pet_id}/{session_id}/{photo_id}.jpg"
    public_url TEXT NOT NULL,
    caption TEXT,              -- Ghi chu chi tiet cho buc anh nay
    taken_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- Indexes
CREATE INDEX idx_medical_sessions_pet_id ON public.medical_sessions(pet_id);
CREATE INDEX idx_medical_sessions_date ON public.medical_sessions(session_date DESC);
CREATE INDEX idx_medical_photos_session_id ON public.medical_photos(session_id);

-- RLS Policies cho Tables
ALTER TABLE public.medical_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Active doctors can manage medical_sessions" ON public.medical_sessions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors can manage medical_photos" ON public.medical_photos
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

-- 3. Supabase Storage Bucket Configuration
-- Bucket ID: `medical-photos` (Public bucket hoặc Authenticated Access)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('medical-photos', 'medical-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage RLS Policies
CREATE POLICY "Active doctors upload medical photos" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors view medical photos" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors delete medical photos" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );
```

---

## 🛡️ 6. Xử Lý Lỗi Nghiệp Vụ (Error Handling - ERR)

| Điều kiện kích hoạt lỗi | HTTP Status / Exception | Mã lỗi custom (`error_code`) | Hành động hệ thống (SHALL) |
| :--- | :--- | :--- | :--- |
| File không phải định dạng ảnh | `400 Bad Request` | `INVALID_FILE_TYPE` | Từ chối upload, báo lỗi *"Chỉ chấp nhận file hình ảnh (JPG, PNG, WebP)"* |
| Dung lượng file gốc > 10MB | `400 Bad Request` | `FILE_TOO_LARGE` | Từ chối upload, báo lỗi *"Kích thước ảnh vượt quá giới hạn 10MB"* |
| Lỗi tải file lên Storage | `500 Internal Error` | `STORAGE_UPLOAD_FAILED` | Báo lỗi *"Không thể tải ảnh lên máy chủ storage. Vui lòng thử lại"* |
| Không tìm thấy đợt khám | `404 Not Found` | `SESSION_NOT_FOUND` | Báo lỗi *"Không tìm thấy thông tin đợt khám này"* |
| Tiêu đề đợt khám để trống | `400 Bad Request` | `VALIDATION_FAILED` | Báo lỗi *"Tiêu đề đợt khám không được để trống"* |

---

## ✅ 7. Tiêu Chí Nghiệm Thu (Acceptance Criteria - BDD Format)

### Kịch bản 1: Tạo Lần khám mới & Upload 3 ảnh kèm ghi chú thành công (Happy Path)
- **Given:** Bác sĩ đang ở trang chi tiết cún `Miu` (Poodle).
- **When:** Bác sĩ nhấn "Tạo Lần khám mới", nhập Tiêu đề `Lần 1 - Khám viêm da`, Chẩn đoán `Viêm da dị ứng vùng lưng`, chọn 3 ảnh từ thư viện/camera, nhập ghi chú `Vết đỏ diện rộng` cho ảnh thứ 1 và nhấn "Lưu".
- **Then:** Hệ thống lưu 1 bản ghi `medical_sessions`, upload 3 ảnh lên Storage bucket `medical-photos`, tạo 3 bản ghi `medical_photos` tương ứng và hiển thị danh sách ảnh đẹp mắt trong Lần 1.

### Kịch bản 2: Upload file sai định dạng hoặc quá dung lượng (Boundary Path)
- **Given:** Bác sĩ đang ở form upload ảnh cho Lần khám.
- **When:** Bác sĩ chọn file `.pdf` hoặc file ảnh dung lượng 15MB.
- **Then:** Hệ thống từ chối upload ngay tại client, hiển thị thông báo lỗi `INVALID_FILE_TYPE` hoặc `FILE_TOO_LARGE` tương ứng.

### Kịch bản 3: Xem danh sách Lần khám & Chi tiết ảnh của Thú cưng
- **Given:** Cún `Miu` đã có 2 Lần khám (Lần 1: Khám ban đầu với 3 ảnh; Lần 2: Tái khám sau 5 ngày với 2 ảnh).
- **When:** Bác sĩ chọn cún `Miu` từ ô tìm kiếm.
- **Then:** Hệ thống hiển thị danh sách 2 Lần khám sắp xếp theo thời gian mới nhất lên đầu, click vào từng Lần khám mở ra danh sách ảnh và ghi chú tương ứng. Bác sĩ có thể bấm xem phóng to từng bức ảnh (Lightbox).

### Kịch bản 4: Xóa một bức ảnh khỏi Lần khám
- **Given:** Lần khám có 3 ảnh.
- **When:** Bác sĩ nhấn nút xóa ở bức ảnh thứ 2 và xác nhận.
- **Then:** Hệ thống xóa file khỏi Supabase Storage, xóa bản ghi trong database và cập nhật giao diện hiển thị 2 ảnh còn lại.

---

## 🛑 8. Ngoài Phạm Vi Tính Năng (Out of Scope - Ranh Giới Thép)

- Phase 3 **SHALL NOT** bao gồm giao diện Timeline so sánh ảnh Trước/Sau điều trị (Chức năng này thuộc **Phase 4 - PHOTO-04**).
- Hệ thống **SHALL NOT** tự động nhận diện khuôn mặt hay phân tích vết thương cún bằng AI (Computer Vision) trong v1.0.
- Hệ thống **SHALL NOT** hỗ trợ upload file video (chỉ tập trung tối ưu file ảnh).

---

*Document Version: 1.0.0 APPROVED (LOCKED) — Mọi thay đổi phát sinh bắt buộc thông qua Addendum hoặc nhật ký phiên bản nối tiếp.*
