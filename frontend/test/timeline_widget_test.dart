import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_photo_manager/features/photo/models/medical_session.dart';
import 'package:pet_photo_manager/features/photo/models/medical_photo.dart';
import 'package:pet_photo_manager/features/photo/views/widgets/timeline_node_widget.dart';
import 'package:pet_photo_manager/features/photo/views/widgets/before_after_comparison_viewer.dart';

void main() {
  group('Phase 4 - Timeline Widget Tests', () {
    late MedicalSession session;
    late MedicalPhoto photo1;
    late MedicalPhoto photo2;

    setUp(() {
      session = MedicalSession(
        id: 'session-1',
        petId: 'pet-1',
        sessionDate: DateTime(2026, 8, 24),
        title: 'Đợt khám 1',
        diagnosis: 'Khám da liễu',
        createdAt: DateTime(2026, 8, 24),
        updatedAt: DateTime(2026, 8, 24),
      );
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

    testWidgets('TimelineNodeWidget renders title and date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimelineNodeWidget(
              session: session,
              isFirst: true,
              isLast: true,
            ),
          ),
        ),
      );

      expect(find.text('Đợt khám 1'), findsOneWidget);
    });

    testWidgets('BeforeAfterComparisonViewer renders app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BeforeAfterComparisonViewer(
            beforePhoto: photo1,
            afterPhoto: photo2,
          ),
        ),
      );

      expect(find.text('So sánh Trước / Sau'), findsOneWidget);
    });
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Requirement
 * ----------------------------------------------------
 * TimelineNodeWidget renders session  | PHOTO-04 & EARS[Ubiquitous]
 * BeforeAfterComparisonViewer title   | PHOTO-04 & EARS[Ubiquitous]
 */
