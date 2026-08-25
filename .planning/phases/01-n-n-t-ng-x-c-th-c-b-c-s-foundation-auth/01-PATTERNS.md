# Phase 1: Nền tảng & Xác thực bác sĩ - Pattern Map (Supabase Architecture)

**Mapped:** 2026-08-24
**Stack:** Flutter Web + Supabase (PostgreSQL BaaS)

## Structural Context & Architectural Foundation

As a pure Flutter Web + Supabase architecture, all business logic and state management are encapsulated within the Flutter Web codebase, while Supabase provides Auth and PostgreSQL with Row Level Security (RLS).

Key architectural constraints:
1. **Flutter Layered Architecture:** `View/Screen ➔ StateNotifier/Controller ➔ Repository ➔ SupabaseClient`.
2. **30-line limit per function:** Widget methods and Dart functions MUST be kept modular under 30 lines.
3. **Exception Handling:** Supabase `AuthException` and `PostgrestException` caught and mapped to standardized user messages.
4. **Supabase RLS & Auth:** Security enforced at Database level via RLS policies (`is_admin()`).
5. **Traceability Matrix:** Flutter tests map test cases to SPEC requirements.

---

## File Classification

| New File Path | Role | Description |
|---------------|------|-------------|
| `frontend/pubspec.yaml` | config | Dependencies (`supabase_flutter`, `flutter_riverpod`, `go_router`) |
| `frontend/lib/main.dart` | entrypoint | Initialize Supabase client and App root |
| `frontend/lib/core/config/supabase_config.dart` | config | Supabase URL and Anon Key configuration |
| `frontend/lib/core/network/supabase_client_provider.dart` | provider | Expose global SupabaseClient instance |
| `frontend/lib/features/auth/models/user_profile.dart` | model | User & Profile data model |
| `frontend/lib/features/auth/repositories/auth_repository.dart` | repository | Supabase Auth API wrapper (login, logout, password reset) |
| `frontend/lib/features/auth/controllers/auth_controller.dart` | controller | StateNotifier managing Auth State |
| `frontend/lib/features/auth/views/login_screen.dart` | screen | Login UI (Responsive mobile to desktop) |
| `frontend/lib/features/admin/repositories/admin_user_repository.dart` | repository | Supabase DB queries for doctor account management |
| `frontend/lib/features/admin/views/user_management_screen.dart` | screen | Admin User Management UI |
| `frontend/test/auth_test.dart` | test | Flutter unit and widget tests for Auth |

---

## Pattern Assignments

### 1. Supabase Auth Repository (`frontend/lib/features/auth/repositories/auth_repository.dart`)

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<UserProfile?> fetchCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
        
    return UserProfile.fromJson(response);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
```

### 2. Database RLS Policies (PostgreSQL / Supabase Migration)

```sql
-- RLS Policy: Only Admin can create new doctor accounts / update profile status
CREATE POLICY "Admins full management on profiles" ON public.profiles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'ADMIN' AND status = 'ACTIVE'
    )
  );
```
