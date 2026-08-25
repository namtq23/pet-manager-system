# [Tên Tính Năng] Specification

---

## 📑 Thông Tin Kiểm Soát (Metadata Header)

| Thuộc tính | Giá trị | Ghi chú |
| :--- | :--- | :--- |
| **Feature ID** | `FT-XXX` | Mã định danh duy nhất của tính năng |
| **Version** | `1.0.0` | SemVer (Nâng lên 1.0.0 khi APPROVED, 0.x khi DRAFT) |
| **Status** | `DRAFT` | `DRAFT` / `UNDER_REVIEW` / `APPROVED` (LOCKED) |
| **Owner** | `@username` | Người chịu trách nhiệm chính về Spec này |
| **Approved By**| `@lead_dev`, `@product_owner` | Người phê duyệt bản spec trước khi code |
| **Sprint / Milestone**| `Sprint XX` | Kế hoạch phát hành dự kiến |
| **Git Tag** | `spec/feature-name/v1.0.0` | Tag git đại diện cho bản spec locked |

> ⚠️ **Quy tắc vàng (Locked Spec):** Khi bản Spec đã đạt trạng thái `APPROVED`, nghiêm cấm sửa đổi trực tiếp spec trong Sprint hiện tại. Mọi thay đổi phát sinh bắt buộc phải thông qua tài liệu phụ lục (Addendum) hoặc tạo phiên bản mới để tránh lỗi "Mục tiêu di động" (The Moving Target).

---

## 🎯 1. Bối Cảnh & Mục Tiêu (Context & Goal - WHY)

### 1.1. Bối cảnh Nghiệp vụ (Business Context)
*Mô tả chi tiết tại sao chúng ta cần làm tính năng này? Nó giải quyết nỗi đau (pain point) nào của người dùng hoặc tạo ra giá trị kinh tế nào cho doanh nghiệp.*

### 1.2. Thước đo Thành công (Success Metrics)
*Các chỉ số định lượng cụ thể để đo lường tính hiệu quả của tính năng sau khi lên production (Ví dụ: Tỉ lệ click tăng 10%, Latency API < 200ms, Giảm tỉ lệ bỏ giỏ hàng xuống dưới 5%).*

---

## 👥 2. Tác Nhân & Vai Trò (Actors & Roles)

### 2.1. Tác nhân Trong phạm vi (In-Scope Actors)
*Liệt kê danh sách các tác nhân (Người dùng hoặc hệ thống khác) trực tiếp tương tác hoặc bị ảnh hưởng bởi tính năng này.*
*   `Actor A`: Người dùng cuối, có quyền thực hiện...
*   `System B`: Hệ thống thanh toán bên thứ ba, chịu trách nhiệm nhận sự kiện và phản hồi...

### 2.2. Tác nhân Ngoài phạm vi (Actors Out of Scope)
*Liệt kê rõ các tác nhân KHÔNG ĐƯỢC PHÉP truy cập hoặc bị giới hạn quyền truy cập đối với tính năng này để AI không cấu hình sai phân quyền.*
*   `Guest`: Người dùng chưa đăng nhập SHALL NOT được nhìn thấy hoặc thao tác...

---

## 📋 3. Yêu Cầu Chức Năng (Functional Requirements - WHAT)

Sử dụng cú pháp **EARS Notation** (Easy Approach to Requirements Syntax) để định nghĩa mọi yêu cầu nghiệp vụ một cách rõ ràng và kiểm thử được. 

### Phân cấp Nghĩa vụ (Imperative Hierarchy)
*   **SHALL:** Yêu cầu bắt buộc (Must have). Không thực hiện là lỗi.
*   **SHALL NOT:** Cấm hoàn toàn.
*   **SHOULD:** Khuyến nghị cao (Nice to have), có thể bỏ qua nếu gặp giới hạn công nghệ cực đoan.
*   **MAY:** Tùy chọn (Optional), triển khai dựa trên mức độ ưu tiên của dự án.

### Các mẫu câu EARS Chuẩn hóa áp dụng:
1.  **Luôn luôn đúng (Ubiquitous):**
    *   `Cú pháp:` THE <hệ thống> SHALL <hành động>.
    *   *Ví dụ:* THE hệ thống SHALL hash passwords với thư viện bcrypt và cost factor >= 12.
2.  **Phản ứng với Sự kiện (Event-driven):**
    *   `Cú pháp:` WHEN <sự kiện kích hoạt>, THE <hệ thống> SHALL <hành động>.
    *   *Ví dụ:* WHEN người dùng nhấn nút "Gửi mã", THE hệ thống SHALL gửi mã OTP SMS tới số điện thoại trong vòng 5 giây.
3.  **Trạng thái liên tục (State-driven):**
    *   `Cú pháp:` WHILE <ở trong trạng thái nhất định>, THE <hệ thống> SHALL <hành động>.
    *   *Ví dụ:* WHILE hệ thống ở trạng thái "Bảo trì", THE trang web SHALL hiển thị thông báo bảo trì cho mọi truy cập.
4.  **Tính năng tùy chọn được bật (Optional Feature):**
    *   `Cú pháp:` WHERE <tính năng tùy chọn được bật>, THE <hệ thống> SHALL <hành động>.
    *   *Ví dụ:* WHERE hệ thống xác thực 2 lớp (2FA) IS ENABLED, THE hệ thống SHALL yêu cầu mã OTP sau bước nhập mật khẩu.
5.  **Xử lý Lỗi / Hành vi không mong muốn (Unwanted Behaviors):**
    *   `Cú pháp:` WHERE <điều kiện lỗi/ngoại lệ xảy ra>, THE <hệ thống> SHALL <hành động>.
    *   *Ví dụ:* WHERE người dùng nhập sai mật khẩu quá 5 lần liên tiếp, THE hệ thống SHALL khóa tài khoản trong vòng 30 phút.

---

## 🚀 4. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

*Các tiêu chuẩn kỹ thuật bắt buộc để đo lường chất lượng hệ thống, cấm dùng tính từ mơ hồ (như "tối ưu", "nhanh", "bảo mật") mà phải có số liệu định lượng cụ thể.*

| Phân nhóm | Tiêu chuẩn cụ thể | Phương pháp đo lường |
| :--- | :--- | :--- |
| **Hiệu năng (Performance)** | API Response Latency (P95) SHALL < 200ms với tải trọng 500 CCU. | Kiểm thử tải bằng k6 / JMeter |
| **Bảo mật (Security)** | Mọi dữ liệu nhạy cảm của người dùng (thẻ tín dụng, mật khẩu) SHALL được mã hóa khi lưu trữ trong cơ sở dữ liệu. | Audit cấu trúc DB & Source Code |
| **Độ tin cậy (Reliability)** | API xử lý thanh toán SHALL có cơ chế kiểm tra tính trùng lặp (Idempotency) để tránh double charge. | Kiểm thử Unit test concurrent request |

---

## 📊 5. Mô Hình Dữ Liệu & API Contracts (Data Model)

### 5.1. Cơ sở Dữ liệu Schema (Database Schema)
*Định nghĩa Prisma Schema hoặc SQL Script mẫu cho các bảng dữ liệu mới.*
```prisma
// Ví dụ Schema mẫu
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String
  createdAt DateTime @default(now())
}
```

### 5.2. Hợp đồng API (API Contracts)
*Mô tả chi tiết Request và Response mẫu của API.*

*   **Endpoint:** `POST /api/v1/feature`
*   **Authentication:** Bắt buộc JWT Bearer Token
*   **Request Body Schema (Zod validated):**
```json
{
  "field_1": "string (bắt buộc, độ dài 5-100 ký tự)",
  "field_2": "number (tùy chọn, giá trị > 0)"
}
```
*   **Response (Success 201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "uuid-1234",
    "createdAt": "2026-08-21T07:00:00Z"
  }
}
```
*   **Response (Error 400 Bad Request):**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Trường field_1 không đúng định dạng",
    "details": []
  }
}
```

---

## 🛡️ 6. Xử Lý Lỗi Nghiệp Vụ (Error Handling - ERR)

*Bảng mô tả tường minh các mã lỗi nghiệp vụ nghiệp vụ riêng, giúp AI sinh mã xử lý lỗi chuẩn xác thay vì dùng lỗi hệ thống chung chung.*

| Điều kiện kích hoạt lỗi | HTTP Status | Mã lỗi custom (`error_code`) | Hành động hệ thống (SHALL) |
| :--- | :--- | :--- | :--- |
| Token JWT hết hạn | `401 Unauthorized` | `TOKEN_EXPIRED` | Trả về thông báo lỗi hết hạn và yêu cầu refresh token |
| Bản ghi không tồn tại | `404 Not Found` | `RECORD_NOT_FOUND` | Trả về mã lỗi bản ghi không tồn tại kèm ID tìm kiếm |

---

## ✅ 7. Tiêu Chí Nghiệm Thu (Acceptance Criteria - BDD Format)

Sử dụng định dạng **Given-When-Then** (Behavior-Driven Development) để định nghĩa kịch bản kiểm thử rõ ràng cho AI Agent sinh mã Unit Tests tương ứng.

### Kịch bản 1: [Tên kịch bản thành công - Happy Path]
*   **Given (Giả sử):** Người dùng đã đăng nhập thành công và có số dư ví là 500,000đ.
*   **When (Khi):** Người dùng thực hiện lệnh thanh toán hóa đơn trị giá 200,000đ.
*   **Then (Thì):** Hệ thống SHALL trừ 200,000đ khỏi ví, lưu lịch sử giao dịch và trả về HTTP 200 OK kèm mã giao dịch.

### Kịch bản 2: [Tên kịch bản thất bại - Boundary/Error Path]
*   **Given (Giả sử):** Người dùng đã đăng nhập thành công và có số dư ví là 50,000đ.
*   **When (Khi):** Người dùng thực hiện lệnh thanh toán hóa đơn trị giá 100,000đ.
*   **Then (Thì):** Hệ thống SHALL từ chối thanh toán, ném lỗi nghiệp vụ `INSUFFICIENT_BALANCE` và trả về HTTP 400 Bad Request.

---

## 🛑 8. Ngoài Phạm Vi Tính Năng (Out of Scope - Ranh Giới Thép)

*Ranh giới thép cực kỳ quan trọng để ngăn chặn AI tự ý "sáng tạo" thêm các chức năng không cần thiết dẫn đến phình scope (Scope Creep) và tốn tài nguyên.*

*   Tính năng này **SHALL NOT** bao gồm hệ thống gửi thông báo đẩy (Push Notifications) trong sprint hiện tại.
*   Hệ thống **SHALL NOT** hỗ trợ thanh toán bằng tiền mã hóa (Crypto) mà chỉ tập trung vào Ví điện tử và Thẻ ngân hàng.
*   Trang quản trị (Admin Dashboard) để thống kê báo cáo tính năng này **SHALL NOT** được làm trong pha này và sẽ dời sang Sprint tiếp theo.