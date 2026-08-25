# Phase 2 Context: Quản lý Khách hàng & Thú cưng (Customer & Pet Management)

## Executive Summary
Phase 2 chịu trách nhiệm xây dựng module Quản lý hồ sơ Chủ nuôi (Khách hàng) và Thú cưng (Cún), đồng thời cung cấp tính năng Tra cứu nhanh theo Số điện thoại cho 5-15 Bác sĩ thú y dựa trên bản đặc tả **FT-002** (`.spec/specs/customer-pet/SPEC.md`).

## Locked Technical & Business Decisions

### 1. Requirements Scope
- **CUST-01**: Quản lý hồ sơ Chủ nuôi (Khách hàng) — Tạo mới, chỉnh sửa, lưu thông tin Họ tên, SĐT (độc nhất, 10-11 chữ số), Địa chỉ, Ghi chú.
- **CUST-02**: Quản lý Thú cưng (Cún) — Liên kết 1-nhiều với Chủ nuôi. Lưu Tên, Giống cún, Giới tính, Tuổi, Cân nặng (kg), Ghi chú sức khỏe.
- **CUST-03**: Tra cứu nhanh theo SĐT / Tên — Ô tìm kiếm tìm tức thì trong < 1 giây, hỗ trợ chuẩn hóa SĐT (loại bỏ khoảng trắng, dấu gạch) và hiển thị danh sách cún tương ứng.

### 2. Architecture & Tech Stack (Flutter Web + Supabase BaaS)
- **Database (Supabase PostgreSQL)**:
  - Bảng `public.customers` lưu thông tin chủ nuôi (khóa chính UUID, `phone` UNIQUE).
  - Bảng `public.pets` lưu thông tin thú cưng (khóa ngoại `customer_id` CASCADE delete).
  - Index tối ưu: `idx_customers_phone`, `idx_customers_full_name` (GIN/ILIKE), `idx_pets_customer_id`.
  - Supabase Row Level Security (RLS) bảo vệ cả 2 bảng: Chỉ tài khoản Doctor/Admin ở trạng thái `ACTIVE` mới có quyền SELECT, INSERT, UPDATE.
- **Frontend (Flutter Web)**:
  - Repository Layer: `CustomerRepository`, `PetRepository` thao tác qua `SupabaseClient`.
  - State Management: `CustomerController` & `PetController` (Riverpod `StateNotifier` / `AsyncNotifier`).
  - Views:
    - `CustomerSearchScreen` / `SearchHeader` (Ô tìm kiếm SĐT với debounce & instant result).
    - `CustomerDetailScreen` (Thông tin chủ nuôi + Grid/List danh sách thú cưng).
    - `CustomerFormDialog` / `PetFormDialog` (Modal thêm/sửa khách hàng & thú cưng).

### 3. Code Standards & Quality Rules (`.spec/CLAUDE.md`)
- **Giới hạn 30 dòng**: Giữ mọi hàm UI và Repository < 30 dòng.
- **Xử lý lỗi**: Bắt lỗi `PostgrestException` (ví dụ `23505` duplicate key SĐT) và map sang thông báo tiếng Việt (`DUPLICATE_PHONE`).
- **EARS Notation**: Gắn comment EARS trong business logic (ví dụ `// EARS[Unwanted]: WHERE duplicate phone...`).
- **Traceability Matrix**: Ma trận kiểm thử cuối file test ánh xạ requirement IDs (`CUST-01`, `CUST-02`, `CUST-03`).
