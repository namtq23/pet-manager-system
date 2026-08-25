# Phase 1 Context: Nền tảng & Xác thực bác sĩ (Foundation & Auth) - Supabase Architecture

## Executive Summary
Phase 1 establishes the baseline infrastructure using Flutter Web + Supabase (PostgreSQL BaaS) and implements full Doctor Authentication and Account Management based on approved specification **FT-001** (`.spec/specs/auth/SPEC.md`).

## Locked Technical & Business Decisions

### 1. Requirements Scope
- **AUTH-01**: Doctor authentication (email/password login with Supabase Auth JWT session management).
- **AUTH-02**: Account management for 5-15 doctors (Admin role creating accounts, resetting passwords, toggling active/inactive status).
- **AUTH-03**: Session persistence (Supabase Auth session token auto-refresh, Flutter Secure Storage / Web local storage) and request auditing (attaching doctor identity to operations).

### 2. Architecture & Tech Stack
- **Frontend / Client**: Flutter Web (responsive layout for mobile browser & desktop).
- **Backend / Database (BaaS)**: Supabase (PostgreSQL with Row Level Security - RLS, Supabase Auth, Supabase Database).
- **Security & Database Policy**:
  - Supabase Auth handles password hashing (Bcrypt) & JWT session Tokens.
  - PostgreSQL Row Level Security (RLS) policies enforce `ADMIN` vs `DOCTOR` permissions directly at the database layer.
  - User profiles and doctor accounts stored in `public.profiles` / `public.doctors` table synced with `auth.users`.
  - Account status (`ACTIVE` vs `INACTIVE`) checked via Supabase Auth & RLS policies / custom Auth functions or triggers.

### 3. Code Standards & Architecture Pattern (`.spec/CLAUDE.md`)
- **Flutter Architecture**: Feature-first / Layered Architecture (`Screen -> Controller/Notifier -> Service/Repository -> SupabaseClient`).
- **30-line function limit**: Keep UI widgets and service methods modular (< 30 lines per function).
- **Error Handling**: Standardized Exception handling catching `AuthException` / `PostgrestException` and mapping to user-friendly Vietnamese messages.
- **Traceability Matrix**: Widget and Unit test files map tests to requirement IDs (`AUTH-01`, `AUTH-02`, `AUTH-03`).

### 4. Database Schema (Supabase SQL / RLS)

```sql
-- Profiles table extending auth.users
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'DOCTOR' CHECK (role IN ('ADMIN', 'DOCTOR')),
  status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
  must_change_password BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Helper function to check if current user is ADMIN
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'ADMIN' AND status = 'ACTIVE'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS Policies
-- Users can read their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles" ON public.profiles
  FOR SELECT USING (public.is_admin());

-- Admins can insert/update profiles
CREATE POLICY "Admins can insert profiles" ON public.profiles
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admins can update profiles" ON public.profiles
  FOR UPDATE USING (public.is_admin());
```
