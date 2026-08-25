import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_session.dart';
import '../repositories/medical_session_repository.dart';
import '../../../core/network/supabase_client_provider.dart';

final medicalSessionRepositoryProvider = Provider<MedicalSessionRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MedicalSessionRepository(client);
});

final medicalSessionsListProvider =
    FutureProvider.family<List<MedicalSession>, String>((ref, petId) async {
  final repo = ref.watch(medicalSessionRepositoryProvider);
  return repo.getSessionsByPetId(petId);
});

class MedicalSessionController extends StateNotifier<AsyncValue<void>> {
  final MedicalSessionRepository _repository;
  MedicalSessionController(this._repository) : super(const AsyncValue.data(null));

  // EARS[Event]: Create medical session
  Future<MedicalSession?> createSession({
    required String petId,
    required String title,
    String? diagnosis,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final session = await _repository.createSession(
        petId: petId,
        title: title,
        diagnosis: diagnosis,
        notes: notes,
      );
      state = const AsyncValue.data(null);
      return session;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // EARS[Event]: Delete medical session
  Future<void> deleteSession(String sessionId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteSession(sessionId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final medicalSessionControllerProvider =
    StateNotifierProvider<MedicalSessionController, AsyncValue<void>>((ref) {
  final repo = ref.watch(medicalSessionRepositoryProvider);
  return MedicalSessionController(repo);
});
