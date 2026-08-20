# Pet Photo Manager

## What This Is

Hệ thống web app cho bệnh viện thú y, giúp bác sĩ lưu trữ và tra cứu ảnh tiến trình điều trị của thú cưng. Bác sĩ chụp ảnh trực tiếp hoặc upload, gắn vào hồ sơ từng con thú cưng, và tra cứu nhanh bằng số điện thoại chủ. Hệ thống hiển thị timeline ảnh trước/sau để đánh giá tiến triển bệnh.

## Core Value

Bác sĩ có thể tra cứu ngay ảnh tiến trình điều trị của bất kỳ thú cưng nào khi khách hàng hỏi về tình trạng bệnh — thay vì lục tìm ảnh rải rác trên điện thoại cá nhân.

## Current Milestone

**v1.0 — Pet Photo Manager**

Xây dựng toàn bộ hệ thống từ đầu: quản lý tài khoản bác sĩ, quản lý khách hàng & thú cưng, upload/chụp ảnh, timeline ảnh theo lần khám, tra cứu bằng SĐT.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] Đăng nhập/quản lý tài khoản bác sĩ (5-15 người)
- [ ] Quản lý khách hàng (chủ): tên, SĐT, địa chỉ
- [ ] Quản lý thú cưng: tên, giống, tuổi, cân nặng (1 chủ nhiều cún)
- [ ] Upload ảnh + chụp trực tiếp từ điện thoại
- [ ] Nhóm ảnh theo lần khám (lần 1, lần 2...)
- [ ] Ghi chú theo ảnh: triệu chứng, tình trạng
- [ ] Timeline ảnh: hiển thị tiến trình trước/sau
- [ ] Tra cứu: SĐT → danh sách cún → timeline ảnh
- [ ] Nhiều bác sĩ cùng truy cập, biết ai upload

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Hồ sơ bệnh chi tiết (đơn thuốc, chẩn đoán) — không phải phần mềm quản lý bệnh viện, chỉ tập trung ảnh + tra cứu
- Mobile app native — v1 là web app responsive, truy cập qua trình duyệt điện thoại
- Chat/tin nhắn giữa bác sĩ và chủ — ngoài phạm vi, dùng Zalo/SMS hiện tại
- Thanh toán/hóa đơn — hệ thống riêng biệt

## Context

- Bệnh viện thú y quy mô trung bình (5-15 bác sĩ)
- 50-200 ca khám/tháng
- Hiện tại: ảnh nằm rải rác trên điện thoại cá nhân từng bác sĩ, không tra cứu được
- Pain point chính: khách hàng hỏi "bệnh đỡ chưa?" → bác sĩ không có ảnh so sánh
- Web app cần responsive để bác sĩ dùng trên điện thoại (chụp ảnh, upload) và máy tính (tra cứu, xem timeline)

## Constraints

- **Tech stack**: Flutter/Dart (Web) + PostgreSQL — yêu cầu của khách hàng
- **Storage**: Cần giải pháp lưu trữ ảnh phù hợp (local/cloud storage)
- **Responsive**: Web app phải dùng tốt trên cả điện thoại và máy tính
- **Concurrent access**: 5-15 bác sĩ truy cập đồng thời

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Flutter Web + PostgreSQL | Yêu cầu khách hàng | — Pending |
| Web app (không mobile native) | Giảm phức tạp v1, responsive thay thế | — Pending |
| Tập trung ảnh + tra cứu (không hồ sơ bệnh) | Giải quyết đúng pain point, tránh scope creep | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-08-20 after milestone v1.0 initialization*
