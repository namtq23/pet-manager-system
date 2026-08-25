import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_client_provider.dart';
import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfile profile;
  AuthAuthenticated(this.profile);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(AuthInitial()) {
    _initSessionListener();
  }

  void _initSessionListener() {
    _repository.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await refreshProfile();
      } else {
        state = AuthUnauthenticated();
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final response = await _repository.signInWithEmail(email, password);
      if (response.user != null) {
        await refreshProfile();
      } else {
        state = AuthError('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> refreshProfile() async {
    try {
      final profile = await _repository.fetchCurrentProfile();
      if (profile != null) {
        state = AuthAuthenticated(profile);
      } else {
        state = AuthError('Không tìm thấy thông tin bác sĩ.');
      }
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    try {
      final updated = await _repository.updateProfile(
        fullName: fullName,
        phone: phone,
      );
      state = AuthAuthenticated(updated);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    await _repository.signOut();
    state = AuthUnauthenticated();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
