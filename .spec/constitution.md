# Hiến Pháp Dự Án & Quy Ước AI Agent (Constitution)

Tài liệu này là luật tối thượng của dự án. Mọi AI Agent khi thực thi nhiệm vụ trong repository này **SHALL** đọc và tuân thủ 100% các điều khoản dưới đây. Không có ngoại lệ.

---

## 🤝 BẢN GIAO KÈO VỚI AI (AI Agent Contract)
*Copy nội dung này dán vào đầu mỗi phiên chat mới với AI (Cursor/Cline/Claude):*

```markdown
=== AI AGENT CONTRACT ===
Bạn là Outcome Engineer đóng vai trò Senior Developer trong dự án này.
Nhiệm vụ của bạn là thực hiện công việc dựa trên triết lý Specification-Driven Development (SDD).

QUY TẮC BẮT BUỘC:
1. Bạn SHALL đọc kỹ file `.spec/constitution.md` để tuân thủ tech stack, coding conventions và quy trình git.
2. Bạn SHALL KHÔNG ĐƯỢC PHÉP tự ý code khi chưa có bản thiết kế SPEC.md ở trạng thái STATUS: APPROVED.
3. Khi code, bạn SHALL cài đặt các comment tag EARS (ví dụ: `# EARS[Event]: ...`) để dễ dàng truy xuất nguồn gốc.
4. Bạn SHALL KHÔNG ĐƯỢC PHÉP tự ý bổ sung các hành vi, api hoặc giao diện nằm ngoài phạm vi "Out of Scope" của Spec.
5. Nếu có bất kỳ điểm nào chưa rõ hoặc mâu thuẫn trong spec, bạn SHALL dừng lại và hỏi con người (Human-in-the-loop), tuyệt đối không tự ý đoán mò (No Guesswork/No Hallucination).

Xác nhận bằng cách tóm tắt nhiệm vụ hiện tại của bạn trong tối đa 3 gạch đầu dòng trước khi bắt đầu.
```

---

## 💻 Tech Stack Tiêu Chuẩn (Ví dụ Mẫu)

*Lưu ý: Bạn có thể cập nhật phần này cho phù hợp với dự án thực tế.*

*   **Frontend:** React 18 + TypeScript + TailwindCSS
*   **Backend:** Node.js 20 + Express + TypeScript
*   **Database:** PostgreSQL 16 + Prisma ORM
*   **Testing:** Jest + Supertest (Backend), Vitest + React Testing Library (Frontend)
*   **Validation:** Zod Schema
*   **Authentication:** JWT (JSON Web Tokens), bảo mật lưu trữ HttpOnly Cookie

---

## 📐 Quy Tắc Kiến Trúc & Thiết Kế (Architectural Rules)

*   **Pattern bắt buộc:** Áp dụng mô hình phân lớp **Controller ➔ Service ➔ Repository**.
    *   *Controller:* Chỉ chịu trách nhiệm tiếp nhận HTTP Request, validate dữ liệu đầu vào (bằng Zod), và trả về HTTP Response. KHÔNG chứa logic nghiệp vụ.
    *   *Service:* Nơi xử lý 100% logic nghiệp vụ của hệ thống. KHÔNG truy vấn database trực tiếp.
    *   *Repository:* Nơi thực hiện các câu lệnh truy vấn cơ sở dữ liệu (Prisma/SQL). KHÔNG đặt DB queries ở bất kỳ nơi nào khác.
*   **Error Handling:** 
    *   Mọi lỗi nghiệp vụ phát sinh SHALL được ném ra dưới dạng instance của class `AppError` custom (chứa `statusCode` và `errorCode`).
    *   KHÔNG dùng các throw error chung chung hoặc swallow/ignore exception bằng khối catch rỗng.
*   **Validation:** Bắt buộc validate dữ liệu người dùng ở tầng Controller sử dụng thư viện **Zod**.

---

## ✍️ Quy Ước Viết Code (Coding Conventions)

*   **Đặt tên (Naming Conventions):**
    *   Sử dụng **camelCase** cho tên biến, tên hàm, và tên thuộc tính.
    *   Sử dụng **PascalCase** cho tên class, tên type, interface, và React component.
    *   Sử dụng **UPPER_CASE** cho các hằng số (constants).
    *   Sử dụng **kebab-case** cho tên thư mục và tên file (Ví dụ: `auth-service.ts`, `user-controller.ts`).
*   **Kích thước hàm:** Mỗi function/method **SHALL** ngắn gọn, tập trung làm một việc duy nhất và KHÔNG vượt quá **30 dòng code** (loại trừ comment nghiệp vụ).
*   **Nhất quán dữ liệu:** Mọi hành động ghi dữ liệu phức tạp liên quan tới nhiều bảng cơ sở dữ liệu SHALL được thực thi trong một Database Transaction để đảm bảo tính toàn vẹn.

---

## 🔒 Quy Tắc Bảo Mật Tuyệt Đối (Security Rules)

1.  **Secret Management:** 
    *   **NEVER** hardcode các khóa bí mật (secrets), mật khẩu, API keys vào mã nguồn.
    *   **NEVER** paste nội dung file `.env` chứa secret vào prompt của AI chat công cộng.
2.  **Database Security:** 
    *   Tránh hoàn toàn lỗi SQL Injection bằng việc sử dụng Prisma Query Builder hoặc Parameterized Queries. Bắt buộc cấm cộng chuỗi SQL trực tiếp.
3.  **Authentication & Authorization:**
    *   Mọi API cần bảo mật SHALL đi qua middleware xác thực JWT.
    *   Kiểm tra phân quyền chặt chẽ (RBAC) ở tầng Service trước khi thực hiện hành động ghi/sửa/xóa.

---

## 🌿 Quy Trình Git & Phê Duyệt (Git Workflow)

*   **Đặt tên nhánh (Branching):** `feature/{feature-id}-{short-description}` hoặc `bugfix/{issue-id}-{short-description}`.
*   **Cam kết spec:** Mọi thay đổi đối với tài liệu đặc tả đặc biệt là bản SPEC.md APPROVED SHALL được cam kết trong Git với tiền tố `spec({feature_name}): {description}` và gắn Git Tag `spec/{feature_name}/v1.x.x`.
*   **Pull Request (PR):** 
    *   Mỗi PR tương ứng với một tính năng hoàn thành.
    *   PR SHALL bao gồm đầy đủ mã nguồn đã qua kiểm thử đạt 100% GREEN và bảng đối chiếu Traceability Matrix.
    *   Bắt buộc phải có ít nhất **1 nhân sự con người (Lead/Reviewer)** phê duyệt trước khi merge vào nhánh chính (`main`/`develop`).