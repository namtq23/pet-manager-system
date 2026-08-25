import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/medical_photo.dart';

class MedicalPhotoRepository {
  final SupabaseClient _client;
  static const String _bucket = 'medical-photos';

  MedicalPhotoRepository(this._client);

  // EARS[Event]: Fetch photos for a session
  Future<List<MedicalPhoto>> getPhotosBySessionId(String sessionId) async {
    final response = await _client
        .from('medical_photos')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return (response as List).map((json) => MedicalPhoto.fromJson(json)).toList();
  }

  // EARS[Event]: Upload photo file to storage and record metadata DB
  Future<MedicalPhoto> uploadPhoto({
    required String sessionId,
    required String petId,
    required Uint8List bytes,
    required String fileName,
    String? caption,
  }) async {
    final user = _client.auth.currentUser;
    final String photoId = DateTime.now().millisecondsSinceEpoch.toString();
    final String storagePath = 'pets/$petId/$sessionId/$photoId-$fileName';

    await _client.storage.from(_bucket).uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    final String publicUrl = _client.storage.from(_bucket).getPublicUrl(storagePath);

    final response = await _client
        .from('medical_photos')
        .insert({
          'session_id': sessionId,
          'storage_path': storagePath,
          'public_url': publicUrl,
          'caption': caption?.trim(),
          'created_by': user?.id,
        })
        .select()
        .single();

    return MedicalPhoto.fromJson(response);
  }

  // EARS[Event]: Delete photo from storage and database
  Future<void> deletePhoto(String photoId, String storagePath) async {
    await _client.storage.from(_bucket).remove([storagePath]);
    await _client.from('medical_photos').delete().eq('id', photoId);
  }
}
