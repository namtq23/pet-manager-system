import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet.dart';
import '../repositories/pet_repository.dart';
import '../../../core/network/supabase_client_provider.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PetRepository(client);
});

class PetController extends StateNotifier<AsyncValue<void>> {
  final PetRepository _repository;

  PetController(this._repository) : super(const AsyncValue.data(null));

  Future<Pet?> addPet({
    required String customerId,
    required String name,
    String? species,
    String gender = 'UNKNOWN',
    String? age,
    double? weight,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final pet = await _repository.addPet(
        customerId: customerId,
        name: name,
        species: species,
        gender: gender,
        age: age,
        weight: weight,
        notes: notes,
      );
      state = const AsyncValue.data(null);
      return pet;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Pet?> updatePet({
    required String petId,
    required String name,
    String? species,
    String gender = 'UNKNOWN',
    String? age,
    double? weight,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final pet = await _repository.updatePet(
        petId: petId,
        name: name,
        species: species,
        gender: gender,
        age: age,
        weight: weight,
        notes: notes,
      );
      state = const AsyncValue.data(null);
      return pet;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deletePet(String petId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePet(petId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final petControllerProvider =
    StateNotifierProvider<PetController, AsyncValue<void>>((ref) {
  final repo = ref.watch(petRepositoryProvider);
  return PetController(repo);
});
