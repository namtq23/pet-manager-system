# Phase 2: Quản lý Khách hàng & Thú cưng - Pattern Map

**Mapped:** 2026-08-24
**Stack:** Flutter Web + Supabase (PostgreSQL BaaS)

## Structural Context & Architectural Foundation

Phát triển Phase 2 dựa trên kiến trúc chuẩn đã thiết lập ở Phase 1 (Flutter Web Layered Architecture: `Screen ➔ StateNotifier/Controller ➔ Repository ➔ SupabaseClient`).

Các quy tắc kiến trúc bắt buộc:
1. **Repository Pattern:** Toàn bộ truy vấn Supabase PostgreSQL (`customers`, `pets`) phải gom trong `CustomerRepository` và `PetRepository`. Không gọi Supabase query trực tiếp từ Widget UI.
2. **Quy tắc 30 dòng:** Mọi widget build method, controller method và repository method phải ngắn hơn 30 dòng.
3. **Phân quyền RLS:** Tất cả câu lệnh SQL/Migration khởi tạo bảng `customers` và `pets` phải bật RLS (`ENABLE ROW LEVEL SECURITY`) và tạo Policy cho phép Doctor/Admin ở trạng thái `ACTIVE` thao tác.
4. **SĐT Normalization & Indexing:** SĐT khi lưu hoặc tìm kiếm phải qua hàm `normalizePhone()` (loại bỏ ký tự không phải số). Bảng `customers` sử dụng Index `idx_customers_phone`.

---

## File Classification

| New File Path | Role | Description |
|---------------|------|-------------|
| `supabase/migrations/20260824100000_create_customers_and_pets_schema.sql` | migration | Database Schema, Indexes, và RLS Policies cho `customers` & `pets` |
| `frontend/lib/features/customer/models/customer.dart` | model | Model lớp Khách hàng (Chủ nuôi) |
| `frontend/lib/features/customer/models/pet.dart` | model | Model lớp Thú cưng (Cún) |
| `frontend/lib/features/customer/repositories/customer_repository.dart` | repository | CRUD Khách hàng & Tra cứu nhanh theo SĐT/Tên |
| `frontend/lib/features/customer/repositories/pet_repository.dart` | repository | CRUD Thú cưng gắn với Customer ID |
| `frontend/lib/features/customer/controllers/customer_controller.dart` | controller | StateNotifier quản lý danh sách & trạng thái tìm kiếm khách hàng |
| `frontend/lib/features/customer/controllers/pet_controller.dart` | controller | StateNotifier quản lý danh sách thú cưng |
| `frontend/lib/features/customer/views/customer_search_screen.dart` | screen | Màn hình tra cứu nhanh theo SĐT & danh sách khách hàng |
| `frontend/lib/features/customer/views/customer_detail_screen.dart` | screen | Màn hình chi tiết chủ nuôi & danh sách cún sở hữu |
| `frontend/lib/features/customer/views/customer_form_dialog.dart` | widget | Dialog tạo mới / chỉnh sửa hồ sơ chủ nuôi |
| `frontend/lib/features/customer/views/pet_form_dialog.dart` | widget | Dialog tạo mới / chỉnh sửa hồ sơ thú cưng |
| `frontend/test/customer_pet_test.dart` | test | Unit & Widget Tests kèm Traceability Matrix cho `CUST-01`, `CUST-02`, `CUST-03` |

---

## Code Analog Examples

### 1. Supabase Repository Pattern (Tương tự `AdminUserRepository`)

```dart
class CustomerRepository {
  final SupabaseClient _client;
  CustomerRepository(this._client);

  String normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final cleanQuery = normalizePhone(query);
    var req = _client.from('customers').select('*, pets(*)');
    if (cleanQuery.isNotEmpty) {
      req = req.ilike('phone', '%$cleanQuery%');
    } else if (query.isNotEmpty) {
      req = req.ilike('full_name', '%$query%');
    }
    final response = await req.order('created_at', ascending: false);
    return (response as List).map((json) => Customer.fromJson(json)).toList();
  }
}
```

### 2. Traceability Matrix Pattern in Tests

```dart
/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * Customer Creation & Phone Unique    | SPEC.md 3.1 & CUST-01
 * Pet Linkage to Customer             | SPEC.md 3.2 & CUST-02
 * Fast Phone Search (<1s)             | SPEC.md 3.3 & CUST-03
 */
```
