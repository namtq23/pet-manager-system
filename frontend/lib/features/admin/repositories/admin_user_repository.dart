import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/config/supabase_config.dart';
import '../../auth/models/user_profile.dart';

class AdminUserRepository {
  final supabase.SupabaseClient _client;

  AdminUserRepository(this._client);

  Future<List<UserProfile>> fetchDoctorUsers() async {
    final response = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => UserProfile.fromJson(json))
        .toList();
  }

  Future<void> toggleUserStatus(String targetUserId, String currentStatus) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('Người dùng chưa đăng nhập');

    if (targetUserId == currentUser.id) {
      throw Exception('Không thể vô hiệu hóa chính tài khoản của bạn');
    }

    final newStatus = currentStatus == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';

    if (newStatus == 'INACTIVE') {
      final adminCountResponse = await _client
          .from('profiles')
          .select()
          .eq('role', 'ADMIN')
          .eq('status', 'ACTIVE');

      final activeAdmins = adminCountResponse as List;
      final targetProfile = await _client
          .from('profiles')
          .select('role')
          .eq('id', targetUserId)
          .single();

      if (targetProfile['role'] == 'ADMIN' && activeAdmins.length <= 1) {
        throw Exception('Cần ít nhất 1 tài khoản Admin trong hệ thống');
      }
    }

    await _client
        .from('profiles')
        .update({'status': newStatus})
        .eq('id', targetUserId);
  }

  Future<void> createDoctorUser({
    required String email,
    required String fullName,
    String? phone,
  }) async {
    final existing = await _client
        .from('profiles')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Email này đã được sử dụng trong hệ thống');
    }

    final url = Uri.parse('${SupabaseConfig.supabaseUrl}/auth/v1/signup');

    final response = await http.post(
      url,
      headers: {
        'apikey': SupabaseConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': 'Doctor123!@#',
        'data': {
          'full_name': fullName,
          'role': 'DOCTOR',
        },
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      final msg = errorData['msg'] ?? errorData['message'] ?? 'Lỗi khi tạo tài khoản bác sĩ';
      throw Exception(msg);
    }

    if (phone != null && phone.isNotEmpty) {
      await _client
          .from('profiles')
          .update({'phone': phone})
          .eq('email', email);
    }
  }
}
