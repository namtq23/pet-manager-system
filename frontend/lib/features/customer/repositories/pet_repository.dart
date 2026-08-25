import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet.dart';

class PetRepository {
  final SupabaseClient _client;
  PetRepository(this._client);

  // EARS[Event]: WHEN Doctor adds a new pet for customer
  Future<Pet> addPet({
    required String customerId,
    required String name,
    String? species,
    String gender = 'UNKNOWN',
    String? age,
    double? weight,
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    final response = await _client
        .from('pets')
        .insert({
          'customer_id': customerId,
          'name': name.trim(),
          'species': species?.trim(),
          'gender': gender,
          'age': age?.trim(),
          'weight': weight,
          'notes': notes?.trim(),
          'created_by': user?.id,
        })
        .select()
        .single();
    return Pet.fromJson(response);
  }

  // EARS[Event]: WHEN Doctor updates pet info
  Future<Pet> updatePet({
    required String petId,
    required String name,
    String? species,
    String gender = 'UNKNOWN',
    String? age,
    double? weight,
    String? notes,
  }) async {
    final response = await _client
        .from('pets')
        .update({
          'name': name.trim(),
          'species': species?.trim(),
          'gender': gender,
          'age': age?.trim(),
          'weight': weight,
          'notes': notes?.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', petId)
        .select()
        .single();
    return Pet.fromJson(response);
  }

  // EARS[Event]: Delete pet record
  Future<void> deletePet(String petId) async {
    await _client.from('pets').delete().eq('id', petId);
  }
}
