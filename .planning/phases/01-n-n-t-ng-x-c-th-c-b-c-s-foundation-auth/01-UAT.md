---
status: complete
phase: 01-n-n-t-ng-x-c-th-c-b-c-s-foundation-auth
source: 01-01-SUMMARY.md, 01-02-SUMMARY.md, 01-03-SUMMARY.md
started: 2026-08-24T00:00:00Z
updated: 2026-08-24T00:00:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Cold Start Smoke Test
expected: Kill any running server/service. Clear ephemeral state (temp DBs, caches, lock files). Start the application from scratch. Server boots without errors, any seed/migration completes, and a primary query (health check, homepage load, or basic API call) returns live data.
result: pass

### 2. Bác sĩ Đăng nhập & Xác thực
expected: Truy cập màn hình Đăng nhập (LoginScreen) trên Chrome, nhập Email và Mật khẩu chính xác. Đăng nhập thành công và chuyển sang màn hình chính. Nếu nhập sai email/mật khẩu, hệ thống hiển thị thông báo lỗi bằng tiếng Việt "Email hoặc mật khẩu không đúng".
result: pass

### 3. Duy trì Phiên làm việc & Quản lý Thông tin Bác sĩ
expected: Sau khi đăng nhập, mở màn hình Profile (ProfileScreen). Thông tin Họ tên và Số điện thoại có thể chỉnh sửa và lưu thành công (Email bị khóa không cho sửa). Đồng thời có thể đổi mật khẩu qua ChangePasswordDialog (yêu cầu xác minh mật khẩu hiện tại và mật khẩu mới >= 8 ký tự).
result: pass

### 4. Admin Quản lý Tài khoản Bác sĩ
expected: Đăng nhập với tài khoản Admin và truy cập UserManagementScreen. Hế thống hiển thị danh sách các tài khoản Bác sĩ, có thể tạo tài khoản bác sĩ mới và vô hiệu hóa/kích hoạt tài khoản. Kiểm tra quy tắc bảo vệ: Admin không thể tự vô hiệu hóa tài khoản của chính mình và không thể vô hiệu hóa Admin cuối cùng. Tài khoản có vai trò DOCTOR thường bị từ chối khi vào màn hình này.
result: pass

## Summary

total: 4
passed: 4
issues: 0
pending: 0
skipped: 0

## Gaps

[none yet]
