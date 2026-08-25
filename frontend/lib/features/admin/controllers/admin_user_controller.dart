import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_client_provider.dart';
import '../../auth/models/user_profile.dart';
import '../repositories/admin_user_repository.dart';

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  return AdminUserRepository(ref.watch(supabaseClientProvider));
});

abstract class AdminUserState {}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<UserProfile> doctors;
  AdminUserLoaded(this.doctors);
}

class AdminUserError extends AdminUserState {
  final String message;
  AdminUserError(this.message);
}

class AdminUserController extends StateNotifier<AdminUserState> {
  final AdminUserRepository _repository;

  AdminUserController(this._repository) : super(AdminUserInitial());

  Future<void> loadDoctors() async {
    state = AdminUserLoading();
    try {
      final doctors = await _repository.fetchDoctorUsers();
      state = AdminUserLoaded(doctors);
    } catch (e) {
      state = AdminUserError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> toggleStatus(String userId, String currentStatus) async {
    try {
      await _repository.toggleUserStatus(userId, currentStatus);
      await loadDoctors();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createDoctor({
    required String email,
    required String fullName,
    String? phone,
  }) async {
    try {
      await _repository.createDoctorUser(
        email: email,
        fullName: fullName,
        phone: phone,
      );
      await loadDoctors();
    } catch (e) {
      rethrow;
    }
  }
}

final adminUserControllerProvider =
    StateNotifierProvider<AdminUserController, AdminUserState>((ref) {
  return AdminUserController(ref.watch(adminUserRepositoryProvider));
});
