# Quy Trình Thiết Kế Đặc Tả Khả Thực Thi (Specification-Driven Development - SDD)

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
2. Khi bắt đầu một phiên làm việc mới (Session) với AI, luôn dán nội dung **"Bản Giao Kèo Với AI" (Contract)** nằm trong file `constitution.md` và yêu cầu AI xác nhận đã đọc trước khi tiến hành code.