import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_photo_manager/features/auth/views/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen renders profile UI elements correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    // Initial state when unauthenticated should prompt login
    expect(find.text('Vui lòng đăng nhập'), findsOneWidget);
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * ProfileScreen renders unauthenticated| SPEC.md 3.4 & AUTH-03
 */
