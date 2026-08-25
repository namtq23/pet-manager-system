# Phase 4 Validation Strategy: Timeline ảnh & Tối ưu Responsive

## Phase Metadata
- **Phase Number**: 04
- **Phase Slug**: timeline-nh-t-i-u-responsive-timeline-ux
- **Date**: 2026-08-24
- **Requirement**: PHOTO-04

---

## Validation Architecture

### Dimension 1: Functional Requirements (PHOTO-04)
- [ ] **Timeline View**: Hiển thị danh sách các đợt khám (`medical_sessions`) theo thứ tự thời gian giảm dần với mốc thời gian (Timeline node).
- [ ] **Photo Selection for Comparison**: Bác sĩ có thể chọn 2 ảnh bất kỳ (Ảnh Before & Ảnh After) từ danh sách đợt khám.
- [ ] **Before / After Comparison**: Hiển thị so sánh song song (Side-by-Side) và hỗ trợ thanh trượt so sánh đè (Interactive Slider Overlay).
- [ ] **Responsive Design**: Đảm bảo hiển thị hoàn hảo trên Mobile Web (<600px) và PC Web (≥600px).

### Dimension 2: Code Quality & Performance Constraints (`.spec/CLAUDE.md`)
- [ ] Mọi hàm UI Widget & Controller < 30 dòng code.
- [ ] Traceability Matrix đầy đủ ở cuối mỗi file test.
- [ ] Comment tag EARS trong code xử lý nghiệp vụ (`// EARS[Event]: WHEN...`).

---

## Test Plan Execution Matrix

| Test File | Type | Target Feature / Method | Traceability Requirement |
|-----------|------|------------------------|-------------------------|
| `test/timeline_controller_test.dart` | Unit Test | `TimelineController` (selectBeforePhoto, selectAfterPhoto, resetSelection) | PHOTO-04 |
| `test/timeline_widget_test.dart` | Widget Test | `PetTimelineScreen`, `BeforeAfterComparisonViewer` | PHOTO-04 |
| `test/responsive_layout_test.dart` | Widget Test | `ResponsiveLayoutBuilder` (Mobile vs Desktop verification) | PHOTO-04 |

---

## Verification Sign-off Criteria
1. Chạy toàn bộ test suite pass 100%.
2. Verify bằng tay trên cả điện thoại di động và máy tính qua Flutter Web.
