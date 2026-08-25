# init-spec-kit.py
# Chạy file này bằng lệnh: python init-spec-kit.py tại thư mục gốc dự án của bạn.

import os

def init_spec_folder():
    base_dir = ".spec"
    
    # Định nghĩa cấu trúc các file nghiệp vụ
    files = {
        # Thư mục gốc .spec/
        "README.md": """# Quy Trình Thiết Kế Đặc Tả Khả Thực Thi (Specification-Driven Development - SDD)

Thư mục `.spec/` này là trung tâm điều phối "ý định" của dự án, đóng vai trò là **Shared Context Layer** (Lớp ngữ cảnh dùng chung) giữa Con người và AI Agent (như Cursor, Cline, Claude Code, GitHub Spec Kit).

> 📌 **Triết lý bất biến của SDD:** 
> *"Code là artifact tạm thời. Spec mới là nguồn sự thật lâu dài."*
> *"Sai ở đâu, sửa ở Spec đó" (Fix the Spec, not the Code).*

---

## 🔄 Quy trình SDD 5 Pha (SDD Pipeline)

Quy trình phát triển một tính năng mới SHALL tuân thủ nghiêm ngặt 5 pha tuyến tính dưới đây. **Không được phép chuyển sang pha tiếp theo khi pha hiện tại chưa hoàn thành 100% Definition of Done (DoD).**

```
 [Pha 0: Context Discovery]
            │ (Tạo CONTEXT.md để hiểu Why & Constraints)
            ▼
   [Pha 1: Specification]
            │ (Viết SPEC.md bằng cú pháp EARS, review & lock v1.0.0 APPROVED)
            ▼
     [Pha 2: Planning]
            │ (AI thiết kế PLAN.md: Components, Data Flow & Risks)
            ▼
[Pha 3: Task Decomposition]
            │ (AI phân rã thành TASKS.md: các task độc lập ≤ 4 giờ)
            ▼
[Pha 4: Implementation & Validation]
            │ (AI viết Code + Tests có gắn tag EARS; chạy test & đối chiếu Spec)
            ▼
        [XONG]
```

### 📋 định nghĩa Hoàn thành (Definition of Done) từng Pha

#### 🟢 Pha 0: Context Discovery (Tìm hiểu bối cảnh - Con người chủ trì)
*   **Đầu ra:** File `CONTEXT.md` trong thư mục của feature.
*   **DoD:** Trả lời rõ ràng 5 câu hỏi: Vấn đề thực sự là gì? Thuật ngữ nghiệp vụ là gì? Stakeholders gồm ai? Những ràng buộc cứng (Constraints) là gì? Những giả định (Assumptions) & câu hỏi chưa rõ là gì?

#### 🟢 Pha 1: Specification (Viết đặc tả - Con người chủ trì, AI review)
*   **Đầu ra:** File `SPEC.md` và `CHANGELOG.md` trong thư mục của feature.
*   **DoD:** 
    *   Bản spec có đủ **8 thành phần cốt lõi** (Metadata, Context, Actors, Functional, NFR, Data Schema, Error Handling, Out of Scope).
    *   Mỗi yêu cầu chức năng phải viết bằng **EARS Notation** (Ubiquitous, Event-driven, State-driven, Optional, Unwanted).
    *   Phân cấp nghĩa vụ nghiêm ngặt bằng **SHALL** (bắt buộc), **SHALL NOT** (cấm), **SHOULD** (khuyến nghị), **MAY** (tùy chọn).
    *   Đưa draft spec cho AI đóng vai Senior Developer để phản biện, giải quyết toàn bộ Logic Gaps & Mơ hồ.
    *   **Lock spec** bằng cách chuyển trạng thái sang `APPROVED`, nâng phiên bản lên `1.0.0` và commit vào git kèm git tag dạng `spec/{feature_name}/v1.0.0`.

#### 🟢 Pha 2: Planning (Lập kế hoạch kiến trúc - AI lập, Con người approve)
*   **Đầu ra:** File `PLAN.md` trong thư mục của feature.
*   **DoD:** AI dựa trên `SPEC.md` và `constitution.md` để đề xuất kiến trúc (Component, Data Flow, File Paths), đánh giá ít nhất 3 rủi ro kỹ thuật (Risks & Mitigations) và đặt câu hỏi làm rõ. Con người review, chỉnh sửa và phê duyệt bản thiết kế này trước khi AI code.

#### 🟢 Pha 3: Task Decomposition (Phân rã tác vụ - AI làm)
*   **Đầu ra:** File `TASKS.md` trong thư mục của feature.
*   **DoD:** AI chia nhỏ quy trình code thành danh sách các task nguyên tử (Atomic), độc lập (Independent) và kiểm thử được (Verifiable). Mỗi task tối đa 4 giờ. Nếu task > 4h, bắt buộc phải chia nhỏ hơn.

#### 🟢 Pha 4: Implementation & Validation (Hiện thực hóa & Kiểm thử - AI code, Con người verify)
*   **Đầu ra:** Mã nguồn hoàn chỉnh, Unit Tests và file nghiệm thu (Validation report).
*   **DoD:** 
    *   Mã nguồn phải ghi chú rõ các tag EARS tham chiếu ngược về Spec (Ví dụ: `# EARS[Event]: WHEN user submits...`).
    *   Unit Tests cover 100% các Acceptance Criteria trong Spec.
    *   Không được tự ý viết code vượt ngoài phạm vi Spec (`Out of Scope`).
    *   Chạy test suite đạt 100% GREEN. Tạo bảng ma trận truy xuất nguồn gốc (Traceability Matrix) ánh xạ trực tiếp từ Test -> Spec Section.

---

## 📁 Cấu trúc Thư mục `.spec/`

*   `README.md`: File hướng dẫn bạn đang đọc.
*   `constitution.md`: Bất biến của dự án. Chứa quy ước chung về Tech Stack, Coding Conventions, quy tắc bảo mật và Git Workflow mà AI bắt buộc phải đọc trước khi làm việc.
*   `CLAUDE.md`: File cấu trúc lệnh và phím tắt nhanh cho các Agent (như Cline hoặc Claude Code).
*   `specs/`: Thư mục chứa đặc tả của từng tính năng nghiệp vụ.
    *   `_template.md`: Template đặc tả chuẩn 8 thành phần mẫu dùng để nhân bản cho mọi feature mới.
    *   `sample-feature/`: Thư mục tính năng mẫu hoàn chỉnh (đã qua 5 pha SDD) để tham khảo thực hành.
*   `reviews/`: Nơi lưu các file markdown phản biện spec thô từ AI (để lưu vết lịch sử phản biện logic).
*   `metrics/`: Thư mục lưu vết hiệu năng token và độ ổn định của spec qua các chu kỳ sprint.

---

## 🛠️ Hướng dẫn tích hợp với Cursor & Cline (Roo Code)

Để các AI Coding Agents luôn tuân thủ quy trình này, bạn hãy:
1. Giao cấu hình trong file `.cursorrules` hoặc System Prompt của Cline trỏ đến `.spec/constitution.md` làm tài liệu hướng dẫn tối thượng.
2. Khi bắt đầu một phiên làm việc mới (Session) với AI, luôn dán nội dung **"Bản Giao Kèo Với AI" (Contract)** nằm trong file `constitution.md` và yêu cầu AI xác nhận đã đọc trước khi tiến hành code.""",
        "constitution.md": """# Hiến Pháp Dự Án & Quy Ước AI Agent (Constitution)

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
    *   Bắt buộc phải có ít nhất **1 nhân sự con người (Lead/Reviewer)** phê duyệt trước khi merge vào nhánh chính (`main`/`develop`).""",
        "CLAUDE.md": """# CLAUDE.md - Phím Tắt Nghiệp Vụ & Chỉ Thị Cho AI Agents

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
6.  **Traceability Matrix:** Đặt ma trận kiểm thử ở cuối mỗi file test để ánh xạ rõ ràng test case nào verify yêu cầu nào trong spec.""",
        
        # Thư mục specs/
        "specs/_template.md": """# [Tên Tính Năng] Specification

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
*   Trang quản trị (Admin Dashboard) để thống kê báo cáo tính năng này **SHALL NOT** được làm trong pha này và sẽ dời sang Sprint tiếp theo.""",
        
        # Thư mục sample-feature/
        "specs/sample-feature/CONTEXT.md": """# Context Discovery: Feature Product Review & Rating

Tài liệu này ghi nhận kết quả khám phá bối cảnh của tính năng Đánh giá sản phẩm (Product Review & Rating) cho ứng dụng e-commerce.

---

## 1. Problem Statement (Vấn đề thực tế)
*   **Nỗi đau người dùng:** Người mua hàng trên trang web e-commerce hiện tại cảm thấy thiếu niềm tin khi quyết định mua hàng vì không thấy ý kiến đánh giá trực quan từ những người đã mua trước đó.
*   **Nhu cầu kinh doanh:** Tăng tỷ lệ chuyển đổi đơn hàng thành công (Conversion Rate) bằng cách tạo lập bằng chứng xã hội (Social Proof) đáng tin cậy.

## 2. Domain Knowledge (Kiến thức nghiệp vụ)
*   **Người mua thực tế (Verified Buyer):** Chỉ những khách hàng đã mua sản phẩm này và trạng thái đơn hàng đã chuyển sang `DELIVERED` (Đã giao hàng thành công) mới được phép đánh giá sản phẩm. Điều này giúp ngăn chặn hoàn toàn review rác (fake reviews).
*   **Thang điểm đánh giá (Rating Scale):** Sử dụng thang điểm số nguyên từ 1 đến 5 sao.

## 3. Stakeholders (Bên liên quan)
*   **Buyer (Người mua):** Người tạo đánh giá, viết nhận xét và chấm sao sản phẩm.
*   **Merchant (Người bán):** Người xem đánh giá của sản phẩm mình bán, có nhu cầu phản hồi phản biện đánh giá của người mua.
*   **Admin/Moderator (Quản trị viên):** Người kiểm duyệt nội dung đánh giá nếu phát hiện từ ngữ thô tục hoặc spam.

## 4. Constraints (Ràng buộc cứng không thể thay đổi)
*   **Tech Constraint:** Bắt buộc sử dụng Prisma ORM và DB PostgreSQL hiện tại để lưu thông tin đánh giá.
*   **Business Constraint:** Hệ thống tính toán điểm trung bình sản phẩm phải cập nhật bất đồng bộ (Asynchronous) hoặc cập nhật trong vòng tối đa 5 phút để tránh nghẽn DB khi có hàng triệu lượt truy cập.

## 5. Assumptions & Open Questions (Giả định & Câu hỏi mở)
*   *Câu hỏi mở:* Nếu một người mua đặt mua cùng một sản phẩm trong 2 đơn hàng khác nhau và cả hai đơn hàng đều đã giao thành công, người dùng đó được phép đánh giá mấy lần?
    *   ➔ *Quyết định nghiệp vụ:* Cho phép đánh giá tối đa 1 lần duy nhất cho mỗi mã sản phẩm (`product_id`) để tránh spam điểm số, bất kể số lượng đơn hàng đã đặt.
*   *Giả định:* Giả định rằng hệ thống kiểm duyệt thô tục tự động chưa cần thiết cho pha 1, quản trị viên sẽ tự kiểm duyệt thủ công nếu có báo cáo.""",
        "specs/sample-feature/SPEC.md": """# Specification: Product Review & Rating (FT-042)

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
*   Hệ thống **SHALL NOT** hỗ trợ tích hợp kiểm duyệt tự động bằng AI của bên thứ ba, việc lọc thô tục chỉ sử dụng thư viện regex đối chiếu từ khóa cấm trong file cấu hình local.""",
        "specs/sample-feature/PLAN.md": """# PLAN.md: Architecture & Components for FT-042

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
    *   ➔ *Human confirm:* Merchant được phản hồi nhiều lần để hỗ trợ Buyer sửa lỗi, nhưng hệ thống chỉ hiển thị phản hồi mới nhất.""",
        "specs/sample-feature/TASKS.md": """# TASKS.md: Task Decomposition for FT-042

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
*   Khi hoàn thành xong một task, hãy cập nhật trạng thái của task sang `Done` và log lại kết quả chạy test.""",
        "specs/sample-feature/CHANGELOG.md": """# Changelog: Feature FT-042 Specification

Tài liệu ghi lại toàn bộ lịch sử thay đổi của bản Spec này nhằm kiểm soát lịch sử phát triển và tránh lỗi mất dấu thông tin.

---

## [1.0.0] - 2026-08-21
### Added
*   Khóa bản spec phiên bản đầu tiên chính thức sau khi hoàn thành quy trình duyệt.
*   Bổ sung thêm 3 kịch bản EARS Unwanted Patterns xử lý lỗi chưa mua hàng, đánh giá trùng lặp và bộ lọc từ cấm.
*   Bổ sung quy tắc chống trùng lặp Idempotency tại tầng NFR.

## [0.2.0] - 2026-08-20
### Changed
*   Cập nhật quy tắc: Cho phép Buyer đánh giá tối đa 1 lần duy nhất cho mỗi mã sản phẩm (`product_id`) thay vì cho phép đánh giá theo mỗi đơn hàng khác nhau để tránh spam điểm số.

## [0.1.0] - 2026-08-19
### Added
*   Khởi tạo bản nháp Spec đầu tiên (Draft).""",
    }

    print("🚀 Bắt đầu khởi tạo cấu trúc thư mục .spec/ theo chuẩn SDD...")
    
    # Tạo các thư mục reviews và metrics
    os.makedirs(os.path.join(base_dir, "reviews"), exist_ok=True)
    os.makedirs(os.path.join(base_dir, "metrics"), exist_ok=True)
    
    # Tạo gitkeep
    with open(os.path.join(base_dir, "reviews", ".gitkeep"), "w") as f:
        f.write("")
    with open(os.path.join(base_dir, "metrics", ".gitkeep"), "w") as f:
        f.write("")

    # Viết nội dung cho từng file
    for rel_path, content in files.items():
        full_path = os.path.join(base_dir, rel_path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        with open(full_path, "w", encoding="utf-8") as f:
            f.write(content.strip())
        print(f"  ✔ Đã tạo: {full_path}")

    print("\n🎉 Khởi tạo thành công! Hãy đọc file .spec/README.md để bắt đầu quy trình phát triển.")

if __name__ == "__main__":
    init_spec_folder()
