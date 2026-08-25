import 'package:flutter_test/flutter_test.dart';
import 'package:pet_photo_manager/features/photo/controllers/timeline_controller.dart';
import 'package:pet_photo_manager/features/photo/models/medical_photo.dart';

void main() {
  group('Phase 4 - TimelineController Unit Tests', () {
    late TimelineController controller;
    late MedicalPhoto photoBefore;
    late MedicalPhoto photoAfter;

    setUp(() {
      controller = TimelineController();
      photoBefore = MedicalPhoto(
        id: 'photo-1',
        sessionId: 'session-1',
        storagePath: 'path/1.jpg',
        publicUrl: 'https://example.com/1.jpg',
        createdAt: DateTime.now(),
      );
      photoAfter = MedicalPhoto(
        id: 'photo-2',
        sessionId: 'session-2',
        storagePath: 'path/2.jpg',
        publicUrl: 'https://example.com/2.jpg',
        createdAt: DateTime.now(),
      );
    });

    test('Initial selection state should be null and comparison not ready', () {
      expect(controller.beforePhoto, isNull);
      expect(controller.afterPhoto, isNull);
      expect(controller.isComparisonReady(), isFalse);
      expect(controller.getComparisonPair(), isNull);
    });

    test('Selecting before and after photos updates state correctly', () {
      controller.selectBeforePhoto(photoBefore);
      expect(controller.beforePhoto, equals(photoBefore));
      expect(controller.isComparisonReady(), isFalse);

      controller.selectAfterPhoto(photoAfter);
      expect(controller.afterPhoto, equals(photoAfter));
      expect(controller.isComparisonReady(), isTrue);

      final pair = controller.getComparisonPair();
      expect(pair, isNotNull);
      expect(pair!.beforePhoto, equals(photoBefore));
      expect(pair.afterPhoto, equals(photoAfter));
    });

    test('clearSelection resets selected photos', () {
      controller.selectBeforePhoto(photoBefore);
      controller.selectAfterPhoto(photoAfter);
      expect(controller.isComparisonReady(), isTrue);

      controller.clearSelection();
      expect(controller.beforePhoto, isNull);
      expect(controller.afterPhoto, isNull);
      expect(controller.isComparisonReady(), isFalse);
    });
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Requirement
 * ----------------------------------------------------
 * Initial selection state             | PHOTO-04 & EARS[State-Driven]
 * Selecting before/after photos       | PHOTO-04 & EARS[Event]
 * clearSelection resets selection      | PHOTO-04 & EARS[Event]
 */
