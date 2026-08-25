# CLAUDE.md - Phím Tắt Nghiệp Vụ & Chỉ Thị Cho AI Agents

File này giúp các AI Agent hoạt động cực nhanh trong project này bằng cách định nghĩa sẵn các lệnh CLI phổ biến và quy chuẩn kỹ thuật.

## 🛠️ Lệnh CLI Thường Dùng

*   **Cài đặt:** `npm install`
*   **Chạy Dev Server:** `npm run dev`
*   **Build Dự Án:** `npm run build`
*   **Chạy Toàn Bộ Test Suite:** `npm run test`
*   **Chạy Test Cho File Cụ Thể:** `npm run test -- <path_to_file>`
*   **Chạy Test Lọc Theo Pattern:** `npm run test -t "kịch bản test"`
*   **Chạy DB Migration:** `npx prisma migrate dev`
*   **Mở Prisma Studio (giao diện DB):** `npx prisma studio`

## 🎯 Tiêu Chuẩn Code & Lỗi Thường Gặp Cần Tránh

1.  **Quy tắc 30 dòng:** Giữ mọi hàm không quá 30 dòng. AI SHALL tự động tái cấu trúc chia nhỏ hàm khi phát hiện vượt giới hạn.
2.  **Xử lý ngoại lệ:** Không được dùng block try-catch rỗng hoặc log lỗi rồi nuốt lỗi (exception swallowing). Mọi lỗi hệ thống SHALL được bao bọc lại bằng `AppError` và ném ra cho Global Exception Handler xử lý.
3.  **Validate dữ liệu:** Zod schema SHALL được định nghĩa tại file router/controller tương ứng và validate trực tiếp tại middleware đầu vào của HTTP route.
4.  **Cơ sở dữ liệu:** Không thực hiện query DB trực tiếp trong file Service. Tất cả SQL/ORM query SHALL nằm trong file Repository tương ứng.
5.  **Tag EARS trong code:** Bắt buộc gắn tag chú thích EARS tương ứng với yêu cầu spec tại dòng xử lý business logic trong service (Ví dụ: `// EARS[Event]: WHEN user...`).
6.  **Traceability Matrix:** Đặt ma trận kiểm thử ở cuối mỗi file test để ánh xạ rõ ràng test case nào verify yêu cầu nào trong spec.