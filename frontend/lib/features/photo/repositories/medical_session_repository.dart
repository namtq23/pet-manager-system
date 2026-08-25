import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/medical_session.dart';

class MedicalSessionRepository {
  final SupabaseClient _client;
  MedicalSessionRepository(this._client);

  // EARS[Event]: Fetch medical sessions by pet_id sorted newest first
  Future<List<MedicalSession>> getSessionsByPetId(String petId) async {
    final response = await _client
        .from('medical_sessions')
        .select()
        .eq('pet_id', petId)
        .order('session_date', ascending: false);
    return (response as List).map((json) => MedicalSession.fromJson(json)).toList();
  }

  // EARS[Event]: WHEN Doctor creates a new medical session
  Future<MedicalSession> createSession({
    required String petId,
    required String title,
    String? diagnosis,
    String? notes,
    DateTime? sessionDate,
  }) async {
    final user = _client.auth.currentUser;
    final response = await _client
        .from('medical_sessions')
        .insert({
          'pet_id': petId,
          'title': title.trim(),
          'diagnosis': diagnosis?.trim(),
          'notes': notes?.trim(),
          'session_date': (sessionDate ?? DateTime.now()).toIso8601String(),
          'created_by': user?.id,
        })
        .select()
        .single();
    return MedicalSession.fromJson(response);
  }

  // EARS[Event]: Update session details
  Future<MedicalSession> updateSession({
    required String sessionId,
    required String title,
    String? diagnosis,
    String? notes,
  }) async {
    final response = await _client
        .from('medical_sessions')
        .update({
          'title': title.trim(),
          'diagnosis': diagnosis?.trim(),
          'notes': notes?.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', sessionId)
        .select()
        .single();
    return MedicalSession.fromJson(response);
  }

  // EARS[Event]: Delete medical session and cascade photos
  Future<void> deleteSession(String sessionId) async {
    await _client.from('medical_sessions').delete().eq('id', sessionId);
  }
}
