# Specification: Product Review & Rating (FT-042)

---

## 📑 Thông Tin Kiểm Soát (Metadata Header)

| Thuộc tính | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Feature ID** | `FT-042` | Mã tính năng Đánh giá & Phản hồi sản phẩm |
| **Version** | `1.0.0` | Locked spec |
| **Status** | `APPROVED` | Phê duyệt chính thức |
| **Owner** | `@backend-lead` | Người phụ trách chính |
| **Approved By**| `@tech-architect`, `@product-owner` | Đã ký duyệt |
| **Sprint** | `Sprint-15` | Triển khai chính thức |
| **Git Tag** | `spec/product-review/v1.0.0` | Đã tag trong Git |

---

## 🎯 1. Bối Cảnh & Mục Tiêu (Context & Goal - WHY)

### 1.1. Bối cảnh Nghiệp vụ
Tạo lập lòng tin cho khách hàng bằng cách cho phép người mua thực tế nhận xét về chất lượng sản phẩm [2.3.6]. Điểm số đánh giá trung bình sẽ giúp khách hàng sau dễ dàng đưa ra quyết định mua sắm hơn.

### 1.2. Thước đo Thành công
*   Tăng tỷ lệ mua lại của người dùng cũ lên 15% sau khi có mục đánh giá.
*   Thời gian hiển thị đánh giá mới dưới 2 giây.

---

## 👥 2. Tác Nhân & Vai Trò (Actors & Roles)

*   `Buyer (Người mua)`: Tác nhân đã mua sản phẩm và trạng thái đơn hàng đã hoàn thành (`DELIVERED`). Có quyền tạo, sửa đánh giá của chính mình.
*   `Merchant (Người bán)`: Chủ cửa hàng, có quyền xem đánh giá sản phẩm của shop mình và viết câu trả lời (Merchant Reply).
*   `Guest (Khách vãng lai) OUT OF SCOPE`: Khách chưa mua sản phẩm hoặc chưa đăng nhập SHALL NOT được phép tạo hoặc sửa đánh giá [2.3.6].

---

## 📋 3. Yêu Cầu Chức Năng (Functional Requirements - WHAT)

### 3.1. Tạo Đánh giá mới (Create Review)
*   **EARS[Ubiquitous]:** THE system SHALL validate rating value là số nguyên nằm trong khoảng từ `1` đến `5` [2.3.6].
*   **EARS[Event]:** WHEN user submits review và input validation PASS, THE system SHALL tạo một bản ghi đánh giá mới, lưu trạng thái là `APPROVED` và trả về mã lỗi 201 Created.
*   **EARS[Event]:** WHEN user submits review thành công, THE system SHALL kích hoạt hàng đợi tác vụ bất đồng bộ (Async Background Job) để tính toán lại điểm rating trung bình của sản phẩm trong vòng tối đa 5 phút [2.3.8].

### 3.2. Sửa Đánh giá (Edit Review)
*   **EARS[Event]:** WHEN user edits review, THE system SHALL cho phép cập nhật lại nội dung `comment` và điểm số `rating`.
*   **EARS[Ubiquitous]:** THE system SHALL ghi lại lịch sử thay đổi của đánh giá để phục vụ công tác đối soát.

### 3.3. Các kịch bản bất thường (EARS Unwanted Patterns)
*   **EARS[Unwanted]:** WHERE user attempts to review product mà chưa có bất kỳ đơn hàng nào ở trạng thái `DELIVERED`, THE system SHALL từ chối yêu cầu và trả về lỗi `NOT_PURCHASED` với HTTP Status 403 Forbidden.
*   **EARS[Unwanted]:** WHERE user attempts to review cùng 1 sản phẩm lần thứ 2, THE system SHALL chặn yêu cầu và trả về lỗi `DUPLICATE_REVIEW` với HTTP Status 400 Bad Request [2.3.8].
*   **EARS[Unwanted]:** WHERE nội dung đánh giá (`comment`) chứa từ khóa thô tục nằm trong bộ lọc từ cấm, THE system SHALL từ chối lưu và trả về lỗi `PROFANITY_DETECTED` với HTTP Status 400.

---

## 🚀 4. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

*   **Idempotency (Tính trùng lặp):** API gửi đánh giá SHALL cấu hình middleware Idempotency bằng cách check trường `order_id` và `product_id`. Nếu click submit liên tục (Double-click), request thứ hai SHALL bị từ chối với lỗi trùng lặp để tránh sinh 2 record đồng thời [2.3.8].
*   **Performance:** API lấy danh sách đánh giá của sản phẩm SHALL phản hồi với Latency P95 < 150ms dưới tải trọng 200 lượt truy cập đồng thời.

---

## 📊 5. Mô Hình Dữ Liệu & API Contracts (Data Model)

### 5.1. Database Schema (Prisma Schema)
```prisma
model ProductReview {
  id         String   @id @default(uuid())
  productId  String
  buyerId    String
  orderId    String
  rating     Int      // Range 1 to 5
  comment    String?  @db.VarChar(1000)
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt

  @@unique([buyerId, productId]) // Cấm spam review lần thứ 2 cho cùng 1 sản phẩm
}
```

### 5.2. API Contract
*   **Endpoint:** `POST /api/v1/reviews`
*   **Request Body (JSON):**
```json
{
  "productId": "prod-123",
  "orderId": "order-999",
  "rating": 5,
  "comment": "Sản phẩm dùng rất tốt, giao hàng nhanh!"
}
```
*   **Response (Success 201 Created):**
```json
{
  "success": true,
  "data": {
    "reviewId": "rev-555",
    "rating": 5,
    "createdAt": "2026-08-21T07:30:00Z"
  }
}
```

---

## ✅ 6. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

### Kịch bản 1: Mua hàng thành công và gửi đánh giá hợp lệ
*   **Given:** Người mua `@buyer_01` đã mua sản phẩm `prod-123` trong đơn hàng `order-999` có trạng thái `DELIVERED`. `@buyer_01` chưa từng đánh giá sản phẩm này.
*   **When:** `@buyer_01` gửi yêu cầu POST đánh giá với `rating` là 5 và `comment` là "Rất tốt".
*   **Then:** Hệ thống SHALL tạo bản ghi review mới thành công, trả về HTTP 201 và kích hoạt luồng tính điểm trung bình sản phẩm.

### Kịch bản 2: Từ chối đánh giá khi chưa mua hàng
*   **Given:** Người mua `@buyer_02` chưa từng mua sản phẩm `prod-123`.
*   **When:** `@buyer_02` gửi yêu cầu POST đánh giá cho sản phẩm `prod-123`.
*   **Then:** Hệ thống SHALL chặn lại, không ghi nhận DB, trả về HTTP 403 Forbidden kèm mã lỗi `NOT_PURCHASED`.

---

## 🛑 7. Ngoài Phạm Vi Tính Năng (Out of Scope)

*   Hệ thống **SHALL NOT** hỗ trợ upload ảnh hoặc video trong bài đánh giá tại Sprint-15 [2.3.8].
*   Hệ thống **SHALL NOT** hỗ trợ tích hợp kiểm duyệt tự động bằng AI của bên thứ ba, việc lọc thô tục chỉ sử dụng thư viện regex đối chiếu từ khóa cấm trong file cấu hình local.