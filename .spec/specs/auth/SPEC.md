# Specification: Authentication & Account Management (FT-001)

---

## Thong Tin Kiem Soat (Metadata Header)

| Thuoc tinh | Gia tri | Ghi chu |
| :--- | :--- | :--- |
| **Feature ID** | `FT-001` | Module xac thuc va quan ly tai khoan |
| **Version** | `1.0.0` | Ban dac ta locked va approved |
| **Status** | `APPROVED` | Da duoc phe duyet |
| **Owner** | `@admin` | Nguoi chiu trach nhiem |
| **Approved By** | `@user` | Khach hang / Lead Dev |
| **Milestone** | `v1.0 — Pet Photo Manager` | |
| **Git Tag** | `spec/auth/v1.0.0` | Tag git |

> **Quy tac vang (Locked Spec):** Khi ban Spec da dat trang thai `APPROVED`, nghiem cam sua doi truc tiep. Moi thay doi phat sinh bat buoc phai thong qua tai lieu phu luc (Addendum) hoac tao phien ban moi.

---

## 1. Boi Canh & Muc Tieu (Context & Goal - WHY)

### 1.1. Boi canh Nghiep vu (Business Context)

Benh vien thu y co 5-15 bac si can truy cap he thong Pet Photo Manager de luu tru va tra cuu anh tien trinh dieu tri thu cung. Can mot co che xac thuc de:
- **Xac dinh nguoi thao tac:** Biet bac si nao upload anh, ghi chu — phuc vu truy vet va trach nhiem.
- **Kiem soat truy cap:** Chi nhung nguoi duoc cap phep moi truy cap duoc du lieu anh benh nhan thu y.
- **Quan ly nhan su:** Admin (quan ly benh vien) co the tao/khoa tai khoan bac si khi co thay doi nhan su.

**Pain Point:** Hien tai khong co he thong quan ly truy cap — bat ky ai co link deu co the xem du lieu.

### 1.2. Thuoc do Thanh cong (Success Metrics)

| Chi so | Muc tieu | Cach do |
|--------|----------|---------|
| Thoi gian dang nhap | < 3 giay (tu luc nhan "Dang nhap" den khi vao dashboard) | Do bang Lighthouse / manual timing |
| Ty le dang nhap that bai do loi he thong | < 1% | Log server-side |
| Thoi gian tao tai khoan moi (Admin) | < 30 giay | Manual timing |


---

## 2. Tac Nhan & Vai Tro (Actors & Roles)

### 2.1. Tac nhan Trong pham vi (In-Scope Actors)

| Actor | Mo ta | Quyen han |
|-------|-------|-----------|
| **Admin** | Quan ly benh vien. Co the la bac si kiem nhiem hoac nhan vien van phong. | Tao/sua/vo hieu hoa tai khoan bac si. Reset mat khau. Truy cap toan bo chuc nang Doctor. |
| **Doctor** | Bac si thu y — nguoi dung chinh cua he thong. | Dang nhap, doi mat khau, sua profile ca nhan. Su dung cac module khac (Customer, Photo, Search). |

### 2.2. Tac nhan Ngoai pham vi (Actors Out of Scope)

| Actor | Ly do |
|-------|-------|
| **Guest (chua dang nhap)** | SHALL NOT truy cap bat ky trang nao ngoai trang Login. He thong khong co chuc nang tu dang ky. |
| **Chu thu cung (Pet Owner)** | Khong tuong tac voi he thong. Du lieu cua ho duoc bac si quan ly. |

---

## 3. Yeu Cau Chuc Nang (Functional Requirements - WHAT)

### 3.1. Dang Nhap (Login)

- **EARS[Ubiquitous]:** THE he thong SHALL yeu cau email va password de xac thuc nguoi dung.
- **EARS[Ubiquitous]:** THE he thong SHALL hash password bang thuat toan bcrypt voi cost factor >= 10.
- **EARS[Event]:** WHEN nguoi dung gui form dang nhap voi email va password hop le, THE he thong SHALL tao mot cap JWT token (access token + refresh token) va tra ve HTTP 200 OK.
- **EARS[Event]:** WHEN nguoi dung gui form dang nhap voi email khong ton tai hoac password sai, THE he thong SHALL tra ve HTTP 401 Unauthorized voi ma loi `INVALID_CREDENTIALS`. He thong SHALL NOT phan biet loi "email khong ton tai" va "sai password" de tranh lo thong tin.
- **EARS[Ubiquitous]:** THE access token SHALL co thoi han 1 gio (3600 giay). THE refresh token SHALL co thoi han 7 ngay.
- **EARS[Event]:** WHEN access token het han va client gui refresh token hop le, THE he thong SHALL cap lai access token moi, DONG THOI tao refresh token moi va vo hieu hoa refresh token cu (Token Rotation). Client SHALL luu refresh token moi thay the cho token cu.
- **EARS[Event]:** WHEN client gui refresh token da het han, da bi vo hieu hoa, hoac khong hop le, THE he thong SHALL tra ve HTTP 401 Unauthorized voi ma loi `TOKEN_EXPIRED` va yeu cau dang nhap lai.
- **EARS[Unwanted]:** WHERE refresh token da bi vo hieu hoa (revoked) duoc su dung lai (replay attack), THE he thong SHALL vo hieu hoa TOAN BO refresh token cua user do (revoke family) va tra ve HTTP 401 Unauthorized voi ma loi `TOKEN_REUSE_DETECTED`. User phai dang nhap lai tren tat ca thiet bi.

### 3.2. Dang Xuat (Logout)

- **EARS[Event]:** WHEN nguoi dung nhan "Dang xuat", THE he thong SHALL vo hieu hoa refresh token hien tai (them vao blacklist hoac xoa khoi database) va xoa token phia client.
- **EARS[Ubiquitous]:** THE he thong SHALL NOT cho phep tai su dung refresh token da bi vo hieu hoa.

### 3.3. Quan Ly Tai Khoan Bac Si (Admin Only)

- **EARS[Event]:** WHEN Admin gui yeu cau tao tai khoan moi voi thong tin (fullName, email, password tam, role), THE he thong SHALL tao ban ghi User moi voi trang thai `ACTIVE` va tra ve HTTP 201 Created.
- **EARS[Unwanted]:** WHERE Admin tao tai khoan voi email da ton tai trong he thong, THE he thong SHALL tu choi va tra ve HTTP 409 Conflict voi ma loi `EMAIL_ALREADY_EXISTS`.
- **EARS[Event]:** WHEN Admin vo hieu hoa tai khoan bac si, THE he thong SHALL chuyen trang thai tai khoan sang `INACTIVE`. Bac si bi vo hieu hoa SHALL NOT dang nhap duoc nhung du lieu lich su cua ho SHALL duoc giu nguyen (soft delete).
- **EARS[Unwanted]:** WHERE Admin co gang vo hieu hoa chinh tai khoan cua minh, THE he thong SHALL tu choi va tra ve HTTP 400 Bad Request voi ma loi `CANNOT_DISABLE_SELF`.
- **EARS[Unwanted]:** WHERE he thong chi con duy nhat 1 tai khoan co role ADMIN va Admin do bi yeu cau vo hieu hoa, THE he thong SHALL tu choi va tra ve HTTP 400 Bad Request voi ma loi `LAST_ADMIN_CANNOT_BE_DISABLED`.
- **EARS[Event]:** WHEN Admin kich hoat lai tai khoan bac si da bi vo hieu hoa, THE he thong SHALL chuyen trang thai ve `ACTIVE` va bac si co the dang nhap lai binh thuong.
- **EARS[Event]:** WHEN Admin reset mat khau cho bac si, THE he thong SHALL tao mat khau tam moi, cap nhat vao database va tra ve mat khau tam cho Admin. Bac si SHALL duoc yeu cau doi mat khau khi dang nhap lan dau voi mat khau tam.
- **EARS[Ubiquitous]:** THE he thong SHALL chi cho phep Actor co role `ADMIN` thuc hien cac thao tac quan ly tai khoan. Doctor SHALL NOT truy cap cac API nay.

### 3.4. Quan Ly Profile Ca Nhan (Doctor & Admin)

- **EARS[Event]:** WHEN nguoi dung gui yeu cau cap nhat profile (fullName, phone), THE he thong SHALL cap nhat thong tin va tra ve HTTP 200 OK.
- **EARS[Ubiquitous]:** THE he thong SHALL NOT cho phep nguoi dung tu doi email cua minh (email la dinh danh duy nhat, chi Admin moi doi duoc).
- **EARS[Event]:** WHEN nguoi dung gui yeu cau doi mat khau voi (currentPassword, newPassword), THE he thong SHALL xac minh currentPassword dung truoc khi cap nhat. Neu sai, tra ve HTTP 400 Bad Request voi ma loi `WRONG_CURRENT_PASSWORD`.
- **EARS[Event]:** WHEN nguoi dung doi mat khau thanh cong, THE he thong SHALL vo hieu hoa (revoke) TOAN BO refresh token hien co cua nguoi dung do. Nguoi dung phai dang nhap lai tren tat ca thiet bi.
- **EARS[Ubiquitous]:** THE newPassword SHALL co do dai toi thieu 8 ky tu.

### 3.5. Bao Ve Route & Phan Quyen (Authorization)

- **EARS[Ubiquitous]:** THE he thong SHALL bao ve toan bo API endpoints (ngoai tru `/api/auth/login` va `/api/auth/refresh`) bang JWT middleware. Moi request khong co token hop le SHALL bi tra ve HTTP 401 Unauthorized.
- **EARS[Ubiquitous]:** THE he thong SHALL kiem tra role cua nguoi dung truoc khi cho phep truy cap cac API chi danh cho Admin. Doctor truy cap API Admin SHALL bi tra ve HTTP 403 Forbidden voi ma loi `INSUFFICIENT_PERMISSIONS`.
- **EARS[State]:** WHILE tai khoan nguoi dung o trang thai `INACTIVE`, THE he thong SHALL tu choi moi request dang nhap va tra ve HTTP 403 Forbidden voi ma loi `ACCOUNT_DISABLED`.
- **EARS[Ubiquitous]:** THE he thong SHALL cho phep mot nguoi dung dang nhap dong thoi tren nhieu thiet bi (multi-device). Moi thiet bi/session se co refresh token doc lap.

### 3.6. Khong Cho Phep Cac Hanh Vi Sau (Unwanted Behaviors)

- **EARS[Unwanted]:** WHERE nguoi dung nhap sai mat khau lien tiep 5 lan trong vong 15 phut, THE he thong SHALL khoa tam tai khoan trong 15 phut va tra ve HTTP 429 Too Many Requests voi ma loi `ACCOUNT_TEMPORARILY_LOCKED`.
- **EARS[Unwanted]:** WHERE request API co token JWT bi chinh sua (tampered), THE he thong SHALL tu choi va tra ve HTTP 401 Unauthorized voi ma loi `INVALID_TOKEN`.

---

## 4. Yeu Cau Phi Chuc Nang (Non-Functional Requirements)

| Phan nhom | Tieu chuan cu the | Phuong phap do luong |
| :--- | :--- | :--- |
| **Hieu nang** | API Login SHALL phan hoi voi Latency P95 < 500ms duoi tai trong 15 nguoi dung dong thoi | Load test (k6/Artillery) |
| **Bao mat** | Password SHALL duoc hash bang bcrypt (cost >= 10). Token JWT SHALL duoc ky bang thuat toan HS256 hoac RS256 voi secret key >= 256 bit | Source code audit |
| **Bao mat** | He thong SHALL NOT luu plain-text password trong database hoac log | Audit DB schema + log config |
| **Bao mat** | Refresh token SHALL duoc luu tru an toan (database, khong cookie client-side cho web) | Source code audit |
| **Do tin cay** | API Auth SHALL co uptime >= 99.5% (cho phep ~3.6h downtime/thang) | Monitoring |
| **Tuong thich** | Giao dien dang nhap SHALL responsive, hoat dong tot tren man hinh tu 360px den 1920px | Manual test tren nhieu thiet bi |

---

## 5. Mo Hinh Du Lieu & API Contracts (Data Model)

### 5.1. Database Schema (PostgreSQL)

```sql
-- Bang nguoi dung
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'DOCTOR',  -- 'ADMIN' | 'DOCTOR'
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', -- 'ACTIVE' | 'INACTIVE'
    must_change_password BOOLEAN NOT NULL DEFAULT false,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES users(id)
);

-- Bang refresh token
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Index
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_expires ON refresh_tokens(expires_at);
```

### 5.2. API Contracts

#### POST /api/auth/login
- **Authentication:** Khong can (public endpoint)
- **Request Body:**
```json
{
  "email": "doctor@clinic.vn",
  "password": "securePassword123"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "dGhpcyBpcyBhIHJlZnJlc2g...",
    "expiresIn": 3600,
    "user": {
      "id": "uuid-1234",
      "email": "doctor@clinic.vn",
      "fullName": "BS. Nguyen Van A",
      "role": "DOCTOR",
      "mustChangePassword": false
    }
  }
}
```
- **Response (401 Unauthorized):**
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email hoac mat khau khong dung"
  }
}
```

#### POST /api/auth/refresh
- **Request Body:**
```json
{
  "refreshToken": "dGhpcyBpcyBhIHJlZnJlc2g..."
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "bmV3UmVmcmVzaFRva2Vu...",
    "expiresIn": 3600
  }
}
```
> **Luu y:** Response tra ve refreshToken moi (Token Rotation). Client SHALL thay the refresh token cu bang token moi nay. Token cu se bi vo hieu hoa.

#### POST /api/auth/logout
- **Authentication:** Bearer Token (bat buoc)
- **Request Body:**
```json
{
  "refreshToken": "dGhpcyBpcyBhIHJlZnJlc2g..."
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Dang xuat thanh cong"
}
```

#### POST /api/admin/users
- **Authentication:** Bearer Token (Admin only)
- **Request Body:**
```json
{
  "email": "newdoctor@clinic.vn",
  "fullName": "BS. Tran Van B",
  "password": "tempPass123!",
  "role": "DOCTOR",
  "phone": "0901234567"
}
```
- **Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "uuid-5678",
    "email": "newdoctor@clinic.vn",
    "fullName": "BS. Tran Van B",
    "role": "DOCTOR",
    "status": "ACTIVE",
    "mustChangePassword": true,
    "createdAt": "2026-08-21T07:00:00Z"
  }
}
```

#### GET /api/admin/users
- **Authentication:** Bearer Token (Admin only)
- **Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-1234",
      "email": "doctor@clinic.vn",
      "fullName": "BS. Nguyen Van A",
      "role": "DOCTOR",
      "status": "ACTIVE",
      "createdAt": "2026-08-01T00:00:00Z"
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "pageSize": 20
  }
}
```

#### PATCH /api/admin/users/:id/status
- **Authentication:** Bearer Token (Admin only)
- **Request Body:**
```json
{
  "status": "INACTIVE"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid-5678",
    "status": "INACTIVE",
    "updatedAt": "2026-08-21T08:00:00Z"
  }
}
```

#### PATCH /api/admin/users/:id/reset-password
- **Authentication:** Bearer Token (Admin only)
- **Request Body:**
```json
{
  "newPassword": "newTempPass456!"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Mat khau da duoc reset thanh cong"
}
```

#### PATCH /api/users/me/profile
- **Authentication:** Bearer Token (Doctor hoac Admin)
- **Request Body:**
```json
{
  "fullName": "BS. Nguyen Van A (Updated)",
  "phone": "0909876543"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid-1234",
    "fullName": "BS. Nguyen Van A (Updated)",
    "phone": "0909876543",
    "updatedAt": "2026-08-21T09:00:00Z"
  }
}
```

#### PATCH /api/users/me/password
- **Authentication:** Bearer Token (Doctor hoac Admin)
- **Request Body:**
```json
{
  "currentPassword": "oldPassword123",
  "newPassword": "newSecurePass456!"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Doi mat khau thanh cong"
}
```
- **Response (400 Bad Request):**
```json
{
  "success": false,
  "error": {
    "code": "WRONG_CURRENT_PASSWORD",
    "message": "Mat khau hien tai khong dung"
  }
}
```

---

## 6. Xu Ly Loi Nghiep Vu (Error Handling - ERR)

| Dieu kien kich hoat loi | HTTP Status | Ma loi custom (`error_code`) | Hanh dong he thong (SHALL) |
| :--- | :--- | :--- | :--- |
| Email hoac password sai khi dang nhap | `401 Unauthorized` | `INVALID_CREDENTIALS` | Tra ve thong bao loi chung, KHONG phan biet email sai hay password sai |
| Access token het han | `401 Unauthorized` | `TOKEN_EXPIRED` | Yeu cau client dung refresh token de lay token moi |
| Token JWT bi chinh sua hoac khong hop le | `401 Unauthorized` | `INVALID_TOKEN` | Tu choi request |
| Refresh token het han hoac da bi thu hoi | `401 Unauthorized` | `TOKEN_EXPIRED` | Yeu cau dang nhap lai |
| Doctor truy cap API danh rieng cho Admin | `403 Forbidden` | `INSUFFICIENT_PERMISSIONS` | Tu choi va ghi log canh bao |
| Tai khoan bi vo hieu hoa | `403 Forbidden` | `ACCOUNT_DISABLED` | Tu choi dang nhap, thong bao lien he Admin |
| Tai khoan bi khoa tam (5 lan sai password) | `429 Too Many Requests` | `ACCOUNT_TEMPORARILY_LOCKED` | Thong bao thoi gian con lai de mo khoa |
| Email da ton tai khi tao tai khoan | `409 Conflict` | `EMAIL_ALREADY_EXISTS` | Tu choi tao tai khoan, thong bao email trung |
| Mat khau hien tai sai khi doi mat khau | `400 Bad Request` | `WRONG_CURRENT_PASSWORD` | Tu choi doi mat khau |
| Mat khau moi khong du 8 ky tu | `400 Bad Request` | `VALIDATION_FAILED` | Tra ve thong bao loi validation |
| Admin tu vo hieu hoa chinh minh | `400 Bad Request` | `CANNOT_DISABLE_SELF` | Tu choi thao tac |
| Vo hieu hoa Admin duy nhat con lai | `400 Bad Request` | `LAST_ADMIN_CANNOT_BE_DISABLED` | Tu choi, thong bao can it nhat 1 Admin |
| Refresh token da revoke duoc su dung lai | `401 Unauthorized` | `TOKEN_REUSE_DETECTED` | Revoke toan bo token family cua user, yeu cau dang nhap lai |

---

## 7. Tieu Chi Nghiem Thu (Acceptance Criteria - BDD Format)

### Kich ban 1: Dang nhap thanh cong (Happy Path)
- **Given:** Bac si `@doctor_01` co tai khoan ACTIVE voi email `doctor01@clinic.vn` va password da duoc hash trong DB.
- **When:** `@doctor_01` gui POST `/api/auth/login` voi email va password dung.
- **Then:** He thong SHALL tra ve HTTP 200 OK, kem accessToken, refreshToken va thong tin user. accessToken co thoi han 1 gio.

### Kich ban 2: Dang nhap that bai — sai password
- **Given:** Bac si `@doctor_01` co tai khoan ACTIVE.
- **When:** `@doctor_01` gui POST `/api/auth/login` voi email dung nhung password sai.
- **Then:** He thong SHALL tra ve HTTP 401 Unauthorized voi ma loi `INVALID_CREDENTIALS`. He thong SHALL tang failed_login_attempts len 1.

### Kich ban 3: Tai khoan bi khoa tam sau 5 lan sai
- **Given:** Bac si `@doctor_01` da nhap sai password 4 lan truoc do trong vong 15 phut.
- **When:** `@doctor_01` nhap sai password lan thu 5.
- **Then:** He thong SHALL khoa tai khoan trong 15 phut, tra ve HTTP 429 voi ma loi `ACCOUNT_TEMPORARILY_LOCKED`. Moi request dang nhap tiep theo trong 15 phut SHALL bi tu choi.

### Kich ban 4: Admin tao tai khoan bac si moi
- **Given:** Nguoi dung `@admin_01` co role ADMIN da dang nhap.
- **When:** `@admin_01` gui POST `/api/admin/users` voi thong tin bac si moi (email chua ton tai).
- **Then:** He thong SHALL tao tai khoan moi voi status=ACTIVE, mustChangePassword=true, tra ve HTTP 201 Created.

### Kich ban 5: Admin tao tai khoan voi email da ton tai
- **Given:** Email `existing@clinic.vn` da duoc dang ky trong he thong.
- **When:** Admin gui POST `/api/admin/users` voi email `existing@clinic.vn`.
- **Then:** He thong SHALL tu choi, tra ve HTTP 409 Conflict voi ma loi `EMAIL_ALREADY_EXISTS`.

### Kich ban 6: Admin vo hieu hoa tai khoan bac si
- **Given:** Bac si `@doctor_02` co tai khoan ACTIVE.
- **When:** Admin gui PATCH `/api/admin/users/{doctor_02_id}/status` voi body `{"status": "INACTIVE"}`.
- **Then:** He thong SHALL cap nhat status sang INACTIVE. `@doctor_02` SHALL khong dang nhap duoc nua nhung du lieu lich su van ton tai.

### Kich ban 7: Bac si doi mat khau thanh cong
- **Given:** Bac si `@doctor_01` da dang nhap.
- **When:** `@doctor_01` gui PATCH `/api/users/me/password` voi currentPassword dung va newPassword (>= 8 ky tu).
- **Then:** He thong SHALL cap nhat password moi (hash bcrypt), tra ve HTTP 200 OK.

### Kich ban 8: Bac si doi mat khau — sai mat khau hien tai
- **Given:** Bac si `@doctor_01` da dang nhap.
- **When:** `@doctor_01` gui PATCH `/api/users/me/password` voi currentPassword SAI.
- **Then:** He thong SHALL tra ve HTTP 400 Bad Request voi ma loi `WRONG_CURRENT_PASSWORD`. Password SHALL khong bi thay doi.

### Kich ban 9: Doctor truy cap API Admin
- **Given:** Bac si `@doctor_01` co role DOCTOR da dang nhap.
- **When:** `@doctor_01` gui POST `/api/admin/users` (tao tai khoan — chi Admin).
- **Then:** He thong SHALL tra ve HTTP 403 Forbidden voi ma loi `INSUFFICIENT_PERMISSIONS`.

### Kich ban 10: Refresh token thanh cong
- **Given:** Bac si `@doctor_01` co refreshToken hop le (chua het han, chua bi revoke).
- **When:** Client gui POST `/api/auth/refresh` voi refreshToken.
- **Then:** He thong SHALL tra ve accessToken moi voi thoi han 1 gio. refreshToken cu SHALL van hop le cho den khi het han hoac bi logout.

---

## 8. Ngoai Pham Vi Tinh Nang (Out of Scope - Ranh Gioi Thep)

- He thong **SHALL NOT** ho tro tu dang ky (Self-registration). Tai khoan chi duoc tao boi Admin.
- He thong **SHALL NOT** ho tro dang nhap bang mang xa hoi (Google, Facebook, OAuth) trong v1.0.
- He thong **SHALL NOT** ho tro xac thuc 2 lop (2FA/MFA) trong v1.0.
- He thong **SHALL NOT** ho tro quen mat khau qua email (password reset email). Bac si lien he Admin de reset.
- He thong **SHALL NOT** ho tro audit log chi tiet (ghi lai moi hanh dong cua nguoi dung). Day la tinh nang cho phien ban sau.
- He thong **SHALL NOT** xoa vinh vien tai khoan (hard delete). Chi ho tro vo hieu hoa (soft delete).
- He thong **SHALL NOT** ho tro multi-tenant (nhieu benh vien tren 1 he thong). v1.0 la single-tenant.

---

*Document Version: 1.0.0 APPROVED (LOCKED) — Moi thay doi phat sinh bat buoc thong qua Addendum hoac nhat ky phien ban noi tiep.*
