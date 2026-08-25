import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_photo_manager/features/photo/models/medical_session.dart';
import 'package:pet_photo_manager/features/photo/models/medical_photo.dart';
import 'package:pet_photo_manager/core/utils/image_compressor.dart';

void main() {
  group('Phase 3 - Medical Sessions & Photo Unit Tests', () {
    test('MedicalSession Model parses JSON correctly', () {
      final json = {
        'id': 'session-123',
        'pet_id': 'pet-456',
        'session_date': '2026-08-24T10:00:00.000Z',
        'title': 'Lần 1 - Khám viêm da',
        'diagnosis': 'Viêm da dị ứng vùng lưng',
        'notes': 'Bôi thuốc ngày 2 lần',
        'created_at': '2026-08-24T10:00:00.000Z',
        'updated_at': '2026-08-24T10:00:00.000Z',
        'created_by': 'user-789',
      };

      final session = MedicalSession.fromJson(json);

      expect(session.id, equals('session-123'));
      expect(session.petId, equals('pet-456'));
      expect(session.title, equals('Lần 1 - Khám viêm da'));
      expect(session.diagnosis, equals('Viêm da dị ứng vùng lưng'));
      expect(session.notes, equals('Bôi thuốc ngày 2 lần'));
    });

    test('MedicalPhoto Model parses JSON correctly', () {
      final json = {
        'id': 'photo-123',
        'session_id': 'session-123',
        'storage_path': 'pets/pet-456/session-123/123-photo.jpg',
        'public_url': 'https://example.com/photo.jpg',
        'caption': 'Vết đỏ diện rộng',
        'taken_at': '2026-08-24T10:00:00.000Z',
        'created_at': '2026-08-24T10:00:00.000Z',
        'created_by': 'user-789',
      };

      final photo = MedicalPhoto.fromJson(json);

      expect(photo.id, equals('photo-123'));
      expect(photo.sessionId, equals('session-123'));
      expect(photo.storagePath, equals('pets/pet-456/session-123/123-photo.jpg'));
      expect(photo.publicUrl, equals('https://example.com/photo.jpg'));
      expect(photo.caption, equals('Vết đỏ diện rộng'));
    });

    test('ImageCompressor handles invalid bytes safely', () {
      final invalidBytes = Uint8List.fromList([0, 1, 2, 3]);
      final result = ImageCompressor.compressImage(invalidBytes);
      expect(result, equals(invalidBytes));
    });
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * MedicalSession.fromJson             | SPEC.md 3.1 & PHOTO-02
 * MedicalPhoto.fromJson               | SPEC.md 3.2 & PHOTO-01
 * ImageCompressor Client-side Compression| SPEC.md 4.0 & PHOTO-01
 */
