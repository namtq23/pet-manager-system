# Changelog: Authentication & Account Management (FT-001)

## [1.0.0] - 2026-08-21 — APPROVED (LOCKED)

### Changed
- Phe duyet va thiet lap trang thai APPROVED (LOCKED) cho phien ban v1.0.0.
- Nâng cap bao mat theo ket qua phan bien AI: Token Rotation, Revoke Family trog Replay Attack, Khoa vo hieu Admin cuoi va Revoke tokens khi doi mat khau.

## [0.1.0] - 2026-08-21 — DRAFT

### Added
- Ban nhap dau tien cua SPEC.md cho module Auth
- CONTEXT.md voi 5 cau hoi co ban
- 6 nhom chuc nang: Login, Logout, Admin Account Mgmt, Profile, Authorization, Unwanted Behaviors
- 11 API endpoints duoc dinh nghia chi tiet
- 10 kich ban nghiem thu (Acceptance Criteria) theo BDD format
- 11 ma loi nghiep vu (Error Codes)
- Database schema cho bang users va refresh_tokens

### Decisions
- Dang nhap bang Email + Password (khong OTP)
- Admin tao tai khoan (khong self-register)
- 2 roles: ADMIN va DOCTOR
- Soft delete (vo hieu hoa, khong xoa vinh vien)
- JWT: access token 1h, refresh token 7 ngay
