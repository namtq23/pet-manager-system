# Phase 2 Validation Strategy: Quản lý Khách hàng & Thú cưng

## Automated Verification Targets

1. **Database Schema & RLS Test**:
   - Migration `20260824100000_create_customers_and_pets_schema.sql` tạo đúng bảng `customers` (có unique constraint trên `phone`) và `pets` (foreign key `customer_id` CASCADE).
   - RLS policy cho phép tài khoản bác sĩ `ACTIVE` thao tác, chặn khách vô danh/người dùng `INACTIVE`.

2. **Unit & Integration Tests (`frontend/test/customer_pet_test.dart`)**:
   - Verify `CustomerRepository.normalizePhone` chuẩn hóa các dạng chuỗi SĐT (VD: `090-123-4567` -> `0901234567`).
   - Verify `CustomerRepository.searchCustomers` tìm ra đúng khách hàng và thông tin thú cưng liên quan.
   - Verify việc cố tình tạo SĐT bị trùng trả về đúng mã lỗi `DUPLICATE_PHONE` / exception tương ứng.
   - Traceability Matrix cuối file test map đầy đủ `CUST-01`, `CUST-02`, `CUST-03`.

3. **Code Style & 30-line limit**:
   - Kiểm tra mọi hàm/method mới trong `frontend/lib/features/customer/` không vượt quá 30 dòng.
