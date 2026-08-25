# TASKS.md: Task Decomposition for FT-042

Tài liệu phân rã công việc chi tiết. Toàn bộ các task có thời gian ước lượng ≤ 4 giờ để AI Agent có thể dễ dàng tập trung giải quyết độc lập.

---

## 🗂️ Danh sách Tác vụ phân rã (Task List)

| ID | Tên tác vụ | Est | Deps | Tham chiếu Spec | Tiêu chí hoàn thành (Done Criteria) | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **T001** | Tạo file migration Prisma DB | 1h | None | §5.1 Schema | Chạy lệnh migrate thành công, tạo bảng `ProductReview` kèm Unique Index. | Done |
| **T002** | Viết ReviewRepository | 2h | T001 | §5.1 Schema | Viết xong các method CRUD và test query Prisma hoạt động ổn định. | Done |
| **T003** | Viết ReviewService & EARS Logic | 4h | T002 | §3.1, §3.2, §3.3 | Hoàn thành hàm `createReview` thực thi toàn bộ kịch bản EARS (Validate, Check order, Check trùng lặp). | Done |
| **T004** | Viết Router & Controller | 2h | T003 | §5.2 Contract | Hoàn tất endpoint POST API, tích hợp Middleware xác thực JWT và validate đầu vào bằng Zod. | Done |
| **T005** | Viết Job cập nhật điểm trung bình | 3h | T002 | §3.1 Luồng Async | Job viết xong, chạy thành công, cập nhật chính xác rating của sản phẩm trong bảng Product. | Done |
| **T006** | Viết Test Suite tích hợp (Integration Tests) | 3h | T004 | §6 AC | Viết file test với Supertest bao phủ 100% 2 kịch bản Acceptance Criteria. | Done |

---

## 📋 Hướng dẫn thực thi cho AI Agent
*   AI Agent SHALL đọc file `TASKS.md` này và triển khai lần lượt từng task theo thứ tự phụ thuộc (Dependencies).
*   Khi hoàn thành xong một task, hãy cập nhật trạng thái của task sang `Done` và log lại kết quả chạy test.