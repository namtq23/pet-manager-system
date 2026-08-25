# PLAN.md: Architecture & Components for FT-042

Tài liệu này do AI đề xuất sau khi đọc `SPEC.md` và `constitution.md`. Đã được Human review và ký duyệt thông qua.

---

## 1. Architectural Approach (Mô hình kiến trúc)

Áp dụng quy chuẩn kiến trúc Controller ➔ Service ➔ Repository trong file `constitution.md`.
*   Do có ràng buộc về mặt Idempotency và tránh spam, chúng ta sẽ cấu hình Index Unique ở tầng DB kết hợp kiểm tra khóa chống trùng lặp ở tầng Service.
*   Ràng buộc phi chức năng yêu cầu tính toán lại Rating trung bình trong vòng 5 phút (Async) ➔ Sử dụng hàng đợi BullMQ hoặc thiết lập một Cron Job chạy định kỳ quét DB cập nhật trường `average_rating` của bảng `Product`.

---

## 2. Components list (Danh sách thành phần cần tạo/sửa)

| Thành phần | Trách nhiệm | File Path |
| :--- | :--- | :--- |
| **ReviewRouter** | Định nghĩa API routes, khai báo middleware xác thực và validate Zod schema đầu vào. | `src/reviews/router.ts` |
| **ReviewController**| Trích xuất dữ liệu từ HTTP Request, gọi tầng Service và trả về response chuẩn hóa. | `src/reviews/controller.ts` |
| **ReviewService** | Thực thi 100% logic nghiệp vụ: kiểm tra trạng thái đơn hàng hoàn thành, kiểm tra review trùng lặp và ném lỗi nghiệp vụ. | `src/reviews/service.ts` |
| **ReviewRepository**| Thực hiện truy vấn DB PostgreSQL thông qua Prisma Client để CRUD bản ghi đánh giá. | `src/reviews/repository.ts` |
| **AverageRatingJob**| Tác vụ quét bất đồng bộ để tính toán rating trung bình cho sản phẩm. | `src/reviews/jobs/rating-job.ts` |

---

## 3. Data Flow (Luồng di chuyển dữ liệu)

```
[User Client] ──(HTTP POST)──> [ReviewRouter] ──(Zod Validate)──> [ReviewController]
                                                                        │
                                                                   (Call Service)
                                                                        ▼
[Prisma DB] <──(Prisma Client)── [ReviewRepository] <──(Business)── [ReviewService]
```

---

## 4. Risks & Mitigations (Đánh giá Rủi ro kỹ thuật)

1.  **Risk:** Tác vụ tính toán rating trung bình của sản phẩm chạy tính toán trực tiếp trên toàn bộ DB có thể gây chậm hệ thống khi DB lớn (lên tới hàng triệu dòng).
    *   *Mitigation:* Thay vì tính toán lại toàn bộ, Job SHALL chỉ cập nhật lại rating cho những sản phẩm có bản ghi đánh giá mới phát sinh trong vòng 5 phút vừa qua dựa trên bảng log/hàng đợi.
2.  **Risk:** Lỗi Race Condition khi người dùng bấm submit liên tục 2 lần, vượt qua bước check kiểm tra trùng lặp ở tầng Service.
    *   *Mitigation:* Thiết lập ràng buộc Unique index kết hợp `@@unique([buyerId, productId])` trực tiếp tại bảng cơ sở dữ liệu Postgres.
3.  **Risk:** Lộ lọt secrets khi kết nối database hoặc gọi các dịch vụ kiểm duyệt.
    *   *Mitigation:* Cấu hình Prisma đọc từ `process.env.DATABASE_URL`, tuyệt đối không khai báo trực tiếp URL vào code hoặc đẩy lên Git.

---

## 5. Questions for Human (Câu hỏi cần con người xác nhận)
1.  *Câu hỏi:* Merchant có được phép phản hồi đánh giá của Buyer nhiều lần không hay chỉ 1 lần duy nhất?
    *   ➔ *Human confirm:* Merchant được phản hồi nhiều lần để hỗ trợ Buyer sửa lỗi, nhưng hệ thống chỉ hiển thị phản hồi mới nhất.