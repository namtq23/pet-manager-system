# Specification: Customer & Pet Management (FT-002)

---

## 📑 Thông Tin Kiểm Soát (Metadata Header)

| Thuộc tính | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Feature ID** | `FT-002` | Module quản lý Khách hàng (Chủ nuôi) & Thú cưng |
| **Version** | `1.0.0` | Bản đặc tả locked và approved |
| **Status** | `APPROVED` | Đã được phê duyệt |
| **Owner** | `@admin` | Người chịu trách nhiệm chính |
| **Approved By**| `@user` | Khách hàng / Lead Dev |
| **Milestone** | `v1.0 — Pet Photo Manager` | Milestone phát hành v1.0 |
| **Git Tag** | `spec/customer-pet/v1.0.0` | Tag git cho bản spec locked |

> ⚠️ **Quy tắc vàng (Locked Spec):** Khi bản Spec đã đạt trạng thái `APPROVED`, nghiêm cấm sửa đổi trực tiếp spec trong Sprint hiện tại. Mọi thay đổi phát sinh bắt buộc phải thông qua tài liệu phụ lục (Addendum) hoặc tạo phiên bản mới.

---

## 🎯 1. Bối Cảnh & Mục Tiêu (Context & Goal - WHY)

### 1.1. Bối cảnh Nghiệp vụ (Business Context)
Bệnh viện thú y có 5-15 bác sĩ đón tiếp 50-200 lượt khách hàng (chủ nuôi) mỗi tháng. 
- **Nỗi đau hiện tại (Pain Point):** Khi khách hàng gọi điện hỏi *"Bé cún nhà tôi điều trị đến đâu rồi?"*, bác sĩ chỉ có Số điện thoại khách hàng nhưng không tra cứu được khách tên gì, sở hữu những con cún nào và lịch sử ảnh tiến trình điều trị trước đó ra sao.
- **Giải pháp:** Xây dựng hệ thống lưu trữ thông tin Chủ nuôi (Tên, SĐT, Địa chỉ) và liên kết danh sách Thú cưng (Tên, Giống, Tuổi, Cân nặng). Cung cấp ô tra cứu tức thì theo SĐT để bác sĩ tìm ra đúng cún trong vòng 1-2 giây.

### 1.2. Thước đo Thành công (Success Metrics)

| Chỉ số | Mục tiêu | Cách đo |
|--------|----------|---------|
| Thời gian tra cứu theo SĐT | < 1 giây (Từ lúc gõ SĐT đến khi hiển thị danh sách cún) | Manual timing / UI Benchmark |
| Thời gian tạo mới Chủ nuôi + Cún | < 30 giây | Manual timing |
| Tỷ lệ tìm kiếm chính xác | 100% (Nhập đúng/một phần SĐT ra đúng chủ & cún) | Integration Test |

---

## 👥 2. Tác Nhân & Vai Trò (Actors & Roles)

### 2.1. Tác nhân Trong phạm vi (In-Scope Actors)

| Actor | Mô tả | Quyền hạn |
|-------|-------|-----------|
| **Doctor** | Bác sĩ thú y — người dùng chính. | Xem, tìm kiếm, thêm mới, chỉnh sửa thông tin Chủ nuôi & Thú cưng. |
| **Admin** | Quản lý bệnh viện. | Có toàn bộ quyền của Doctor. |

### 2.2. Tác nhân Ngoài phạm vi (Actors Out of Scope)

| Actor | Lý do |
|-------|-------|
| **Guest (Chưa đăng nhập)** | SHALL NOT truy cập thông tin chủ nuôi hay thú cưng. Chặn bằng Supabase RLS. |
| **Chủ nuôi (Pet Owner)** | Không trực tiếp truy cập hệ thống. Thông tin do bác sĩ nhập và quản lý. |

---

## 📋 3. Yêu Cầu Chức Năng (Functional Requirements - WHAT)

### 3.1. Quản Lý Chủ Nuôi (Customer Management - CUST-01)

- **EARS[Ubiquitous]:** THE hệ thống SHALL lưu trữ thông tin chủ nuôi gồm: `id` (UUID), `fullName` (Họ và tên, bắt buộc), `phone` (Số điện thoại, bắt buộc, 10-11 chữ số, duy nhất), `address` (Địa chỉ, tùy chọn), `notes` (Ghi chú thêm), `createdAt`, `updatedAt`, `createdBy`.
- **EARS[Event]:** WHEN Bác sĩ gửi thông tin chủ nuôi mới với SĐT chưa tồn tại trong hệ thống, THE hệ thống SHALL tạo bản ghi khách hàng mới và trả về trạng thái thành công.
- **EARS[Unwanted]:** WHERE Bác sĩ tạo chủ nuôi với SĐT đã tồn tại trong hệ thống, THE hệ thống SHALL từ chối và trả về mã lỗi `DUPLICATE_PHONE` kèm thông báo *"Số điện thoại này đã được đăng ký cho chủ nuôi khác"*.
- **EARS[Event]:** WHEN Bác sĩ cập nhật thông tin chủ nuôi (Họ tên, SĐT, Địa chỉ, Ghi chú), THE hệ thống SHALL lưu thông tin mới và cập nhật thời gian `updatedAt`.
- **EARS[Ubiquitous]:** THE hệ thống SHALL chuẩn hóa SĐT (xóa khoảng trắng, dấu chấm, gạch nối) trước khi lưu và tìm kiếm.

### 3.2. Quản Lý Thú Cưng (Pet Management - CUST-02)

- **EARS[Ubiquitous]:** THE hệ thống SHALL lưu trữ thông tin thú cưng gồm: `id` (UUID), `customerId` (UUID, khóa ngoại tham chiếu đến chủ nuôi), `name` (Tên cún, bắt buộc), `species` (Giống loài/Giống cún, ví dụ: Poodle, Corgi, Gâu gâu...), `gender` (Giới tính: Đực/Cái/Chưa rõ), `age` (Tuổi hoặc tháng tuổi), `weight` (Cân nặng kg), `notes` (Ghi chú đặc điểm/tiền sử bệnh), `avatarUrl` (Tùy chọn), `createdAt`, `updatedAt`.
- **EARS[Ubiquitous]:** THE hệ thống SHALL hỗ trợ quan hệ 1-nhiều (1 chủ nuôi có thể sở hữu nhiều thú cưng).
- **EARS[Event]:** WHEN Bác sĩ thêm thú cưng mới cho một chủ nuôi, THE hệ thống SHALL gắn thú cưng đó với `customerId` tương ứng và lưu vào cơ sở dữ liệu.
- **EARS[Event]:** WHEN Bác sĩ cập nhật thông tin thú cưng (Tên, Giống, Tuổi, Cân nặng, Ghi chú), THE hệ thống SHALL cập nhật bản ghi tương ứng.

### 3.3. Tra Cứu Nhanh Theo Số Điện Thoại (Fast Search - CUST-03)

- **EARS[Event]:** WHEN Bác sĩ nhập SĐT (hoặc một phần chuỗi SĐT) vào ô tìm kiếm, THE hệ thống SHALL truy vấn và hiển thị ngay lập tức thông tin Chủ nuôi khớp với SĐT cùng danh sách tất cả Thú cưng thuộc sở hữu của chủ đó.
- **EARS[Event]:** WHEN Bác sĩ nhập Tên chủ nuôi hoặc Tên cún vào thanh tìm kiếm, THE hệ thống SHALL hỗ trợ tìm kiếm gần đúng (ILIKE / Fuzzy Search) và trả về các kết quả phù hợp.
- **EARS[State]:** WHILE không tìm thấy kết quả phù hợp với từ khóa tìm kiếm, THE giao diện SHALL hiển thị trạng thái rỗng thân thiện kèm nút *"Thêm Khách hàng Mới"*.

### 3.4. Bảo Vệ Dữ Liệu & Phân Quyền (Authorization & Security)

- **EARS[Ubiquitous]:** THE hệ thống SHALL bảo vệ các bảng `customers` và `pets` bằng Supabase Row Level Security (RLS). Chỉ những Bác sĩ/Admin có tài khoản trạng thái `ACTIVE` mới có quyền SELECT, INSERT, UPDATE.
- **EARS[State]:** WHILE tài khoản Bác sĩ ở trạng thái `INACTIVE`, THE hệ thống SHALL từ chối mọi thao tác đọc/ghi vào bảng `customers` và `pets`.

---

## 🚀 4. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Phân nhóm | Tiêu chuẩn cụ thể | Phương pháp đo lường |
| :--- | :--- | :--- |
| **Hiệu năng** | API Query tìm kiếm theo SĐT SHALL phản hồi với Latency < 300ms với 10,000 bản ghi khách hàng. | Supabase Index Benchmark (`idx_customers_phone`) |
| **Bảo mật** | Dữ liệu khách hàng SHALL được bảo vệ bằng Supabase RLS Policy (`auth.uid() IN active_doctors`). | RLS Security Audit |
| **Giao diện** | Giao diện quản lý & tra cứu SHALL Responsive hoàn hảo trên Màn hình Điện thoại (360px - 430px) và Máy tính (1280px - 1920px). | Flutter Responsive Testing |
| **Độ tin cậy** | Tìm kiếm SĐT SHALL tự động loại bỏ ký tự đặc biệt (khoảng trắng, dấu gạch ngang) để đảm bảo tìm đúng dù nhập `090 123 4567` hay `0901234567`. | Unit Test |

---

## 📊 5. Mô Hình Dữ Liệu & API Contracts (Data Model)

### 5.1. Database Schema (Supabase PostgreSQL)

```sql
-- Bang Khach Hang (Chu nuoi)
CREATE TABLE public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    address TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- Bang Thu Cung (Cun)
CREATE TABLE public.pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    species TEXT,           -- Giong cun (Poodle, Corgi, Phoc, Pug...)
    gender TEXT DEFAULT 'UNKNOWN', -- 'MALE' | 'FEMALE' | 'UNKNOWN'
    age TEXT,               -- Vi du: "2 tuoi", "6 thang"
    weight NUMERIC(5,2),    -- Can nang (kg), vi du: 4.50
    notes TEXT,             -- Ghi chu dac diem, tien su benh
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- Index cho tim kiếm nhanh theo SDT va Ten
CREATE INDEX idx_customers_phone ON public.customers(phone);
CREATE INDEX idx_customers_full_name ON public.customers USING gin(to_tsvector('simple', full_name));
CREATE INDEX idx_pets_customer_id ON public.pets(customer_id);
CREATE INDEX idx_pets_name ON public.pets(name);

-- RLS Policies
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pets ENABLE ROW LEVEL SECURITY;

-- Policy Cho phep Bac si dang hoat dong xem/them/sua
CREATE POLICY "Active doctors can manage customers" ON public.customers
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors can manage pets" ON public.pets
    FOR ALL USING (
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
| SĐT đã được sử dụng bởi chủ nuôi khác | `409 Conflict` | `DUPLICATE_PHONE` | Từ chối tạo, báo lỗi *"Số điện thoại này đã thuộc về chủ nuôi khác"* |
| SĐT nhập không đủ 10-11 chữ số | `400 Bad Request` | `INVALID_PHONE_FORMAT` | Báo lỗi *"Số điện thoại không hợp lệ (cần 10-11 chữ số)"* |
| Không tìm thấy chủ nuôi theo ID | `404 Not Found` | `CUSTOMER_NOT_FOUND` | Báo lỗi *"Không tìm thấy thông tin chủ nuôi"* |
| Không tìm thấy thú cưng theo ID | `404 Not Found` | `PET_NOT_FOUND` | Báo lỗi *"Không tìm thấy thông tin thú cưng"* |
| Tên chủ nuôi hoặc tên cún để trống | `400 Bad Request` | `VALIDATION_FAILED` | Báo lỗi *"Vui lòng nhập đầy đủ các trường bắt buộc"* |

---

## ✅ 7. Tiêu Chí Nghiệm Thu (Acceptance Criteria - BDD Format)

### Kịch bản 1: Tạo chủ nuôi mới và thêm thú cưng thành công (Happy Path)
- **Given:** Bác sĩ đã đăng nhập vào ứng dụng Flutter Web.
- **When:** Bác sĩ mở form "Thêm Khách hàng", nhập Họ tên `Nguyễn Văn A`, SĐT `0901234567`, Địa chỉ `123 Nguyễn Trãi`, và thêm cún tên `Miu` (Giống `Poodle`, 2 tuổi, 4.5kg).
- **Then:** Hệ thống lưu thành công vào PostgreSQL, tạo 1 bản ghi `customers` và 1 bản ghi `pets` liên kết, hiển thị thông báo thành công và chuyển về trang chi tiết khách hàng.

### Kịch bản 2: Tạo chủ nuôi bị trùng Số điện thoại
- **Given:** Khách hàng với SĐT `0901234567` đã tồn tại trong hệ thống.
- **When:** Bác sĩ cố gắng thêm khách hàng mới với SĐT `0901234567`.
- **Then:** Hệ thống từ chối lưu và hiển thị thông báo lỗi `DUPLICATE_PHONE`: *"Số điện thoại này đã được đăng ký cho chủ nuôi khác"*.

### Kịch bản 3: Tra cứu nhanh theo Số điện thoại (CUST-03)
- **Given:** Hệ thống có chủ nuôi `Trần Thị B` (SĐT `0988776655`) sở hữu 2 cún `Lu` (Corgi) và `Mi` (Phốc).
- **When:** Bác sĩ nhập `0988776655` (hoặc `098877`) vào ô tìm kiếm.
- **Then:** Hệ thống trả về thông tin chủ nuôi `Trần Thị B` kèm danh sách 2 cún `Lu` và `Mi` trong thời gian < 1 giây.

### Kịch bản 4: Thêm nhiều thú cưng cho 1 chủ nuôi
- **Given:** Chủ nuôi `Nguyễn Văn A` đã có trong hệ thống.
- **When:** Bác sĩ vào trang chi tiết của `Nguyễn Văn A` và nhấn "Thêm Thú cưng", nhập cún thứ 2 tên `Kiki` (Giống `Bulldog`).
- **Then:** Hệ thống lưu cún `Kiki` gắn với `customerId` của `Nguyễn Văn A`. Danh sách cún của `Nguyễn Văn A` giờ hiển thị 2 cún (`Miu` và `Kiki`).

---

## 🛑 8. Ngoài Phạm Vi Tính Năng (Out of Scope - Ranh Giới Thép)

- Tính năng này **SHALL NOT** hỗ trợ xóa vĩnh viễn (Hard Delete) hồ sơ chủ nuôi hoặc cún nếu cún đó đã có lịch sử ảnh khám bệnh (để bảo vệ dữ liệu y tế).
- Hệ thống **SHALL NOT** tự động gửi tin nhắn SMS/Zalo chào mừng hay nhắc lịch khám cho chủ nuôi trong v1.0.
- Hệ thống **SHALL NOT** quản lý đơn thuốc, chi phí hay hóa đơn dịch vụ khám chữa bệnh.

---

*Document Version: 1.0.0 APPROVED (LOCKED) — Mọi thay đổi phát sinh bắt buộc thông qua Addendum hoặc nhật ký phiên bản nối tiếp.*
