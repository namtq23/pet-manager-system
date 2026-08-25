# Phase 1 Validation Strategy: Nền tảng & Xác thực bác sĩ (Foundation & Auth)

## Executive Summary
This document defines the validation strategy for Phase 1 (Requirements: `AUTH-01`, `AUTH-02`, `AUTH-03` based on Specification `FT-001`).

## Automated Test Harness & Tooling
- **Backend Unit & Integration Tests**: Jest + Supertest (or Vitest) running against test PostgreSQL instance or isolated database schemas.
- **Frontend UI / Integration Tests**: Flutter Test (`flutter test`) for widget & unit testing.
- **API E2E Tests**: Automated HTTP execution testing JWT dual-token flow, lockouts, token rotation, and RBAC guardrails.

## Verification Matrix

| Requirement | Spec Feature | Automated Verification Command | Target Coverage / Output |
| :--- | :--- | :--- | :--- |
| **`AUTH-01`** | Doctor Login & Dual Tokens | `npm run test -- tests/auth.tracer.test.ts` | 100% pass: HTTP 200 on valid credentials, HTTP 401 `INVALID_CREDENTIALS` on bad pass/missing email. |
| **`AUTH-01`**, **`AUTH-03`** | Token Rotation & Replay Detection | `npm run test -- tests/auth.lifecycle.test.ts` | 100% pass: Token rotation succeeds, reused refresh token revokes token family (`TOKEN_REUSE_DETECTED`). |
| **`AUTH-01`** | Account Lockout | `npm run test -- tests/auth.lifecycle.test.ts` | 100% pass: 5 bad password attempts trigger 15-minute lock (`ACCOUNT_TEMPORARILY_LOCKED`). |
| **`AUTH-02`**, **`AUTH-03`** | Admin User Management & RBAC | `npm run test -- tests/admin.user_mgmt.test.ts` | 100% pass: Doctor creation, password reset, soft-delete toggle, guardrails (`CANNOT_DISABLE_SELF`, `LAST_ADMIN_CANNOT_BE_DISABLED`, `INSUFFICIENT_PERMISSIONS`). |
| **`AUTH-01`**, **`AUTH-02`** | Flutter Web UI Widgets | `cd frontend && flutter test` | 100% pass: Login form validation & state management, Admin user management list & dialogs. |

## Code Standards & EARS Traceability Auditing
1. **Rule 30-lines**: Checked via ESLint / static checks (`npm run lint`).
2. **AppError Wrapping**: Verified in unit/integration test assertions (all error responses conform to `{ success: false, error: { code, message } }`).
3. **Zod Validation**: Verified at HTTP router level returning HTTP 400 for bad payloads.
4. **EARS Annotations & Traceability Matrix**: Verified during code review and checked in test suites via comments `// Traceability: AUTH-01...`.
