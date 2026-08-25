import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_photo_manager/features/photo/models/medical_photo.dart';
import 'package:pet_photo_manager/features/photo/views/widgets/before_after_comparison_viewer.dart';

void main() {
  group('Phase 4 - Responsive Layout Tests', () {
    late MedicalPhoto photo1;
    late MedicalPhoto photo2;

    setUp(() {
      photo1 = MedicalPhoto(
        id: 'photo-1',
        sessionId: 'session-1',
        storagePath: 'p1.jpg',
        publicUrl: 'https://example.com/p1.jpg',
        createdAt: DateTime(2026, 8, 24),
      );
      photo2 = MedicalPhoto(
        id: 'photo-2',
        sessionId: 'session-2',
        storagePath: 'p2.jpg',
        publicUrl: 'https://example.com/p2.jpg',
        createdAt: DateTime(2026, 8, 25),
      );
    });

    testWidgets('Renders properly on Mobile (<600px width)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: BeforeAfterComparisonViewer(
            beforePhoto: photo1,
            afterPhoto: photo2,
          ),
        ),
      );

      expect(find.text('So sánh Trước / Sau'), findsOneWidget);
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('Renders properly on Desktop (>=600px width)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: BeforeAfterComparisonViewer(
            beforePhoto: photo1,
            afterPhoto: photo2,
          ),
        ),
      );

      expect(find.text('So sánh Trước / Sau'), findsOneWidget);
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Requirement
 * ----------------------------------------------------
 * Mobile Viewport (<600px)            | PHOTO-04 & EARS[Ubiquitous]
 * Desktop Viewport (>=600px)          | PHOTO-04 & EARS[Ubiquitous]
 */
