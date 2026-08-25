# Changelog: Feature FT-042 Specification

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
*   Khởi tạo bản nháp Spec đầu tiên (Draft).