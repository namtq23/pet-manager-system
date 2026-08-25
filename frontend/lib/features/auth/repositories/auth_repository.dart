import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_profile.dart';

class AuthRepository {
  final supabase.SupabaseClient _client;

  AuthRepository(this._client);

  Stream<supabase.AuthState> get onAuthStateChange =>
      _client.auth.onAuthStateChange;

  Future<supabase.AuthResponse> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on supabase.AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  Future<UserProfile?> fetchCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;
    final profile = UserProfile.fromJson(data);

    if (profile.status == 'INACTIVE') {
      await _client.auth.signOut();
      throw Exception('Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ Admin.');
    }

    return profile;
  }

  Future<UserProfile> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');

    final updatedData = await _client
        .from('profiles')
        .update({
          'full_name': fullName,
          'phone': phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id)
        .select()
        .single();

    return UserProfile.fromJson(updatedData);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    if (newPassword.length < 8) {
      throw Exception('Mật khẩu mới phải có tối thiểu 8 ký tự');
    }

    try {
      await _client.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );
    } catch (_) {
      throw Exception('Mật khẩu hiện tại không đúng');
    }

    await _client.auth.updateUser(
      supabase.UserAttributes(password: newPassword),
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Exception _mapAuthException(supabase.AuthException e) {
    if (e.message.contains('Invalid login credentials')) {
      return Exception('Email hoặc mật khẩu không đúng');
    }
    return Exception('Đã xảy ra lỗi đăng nhập: ${e.message}');
  }
}
