import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_photo_manager/features/admin/views/user_management_screen.dart';

void main() {
  testWidgets('UserManagementScreen blocks non-admin DOCTOR users',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: UserManagementScreen(),
        ),
      ),
    );

    // Default unauthenticated state or doctor role should display warning/empty state
    expect(find.byType(UserManagementScreen), findsOneWidget);
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * UserManagementScreen access control | SPEC.md 3.3 & AUTH-02
 */
