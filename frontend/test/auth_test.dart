import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_photo_manager/features/auth/views/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Pet Photo Manager'), findsOneWidget);
    expect(find.text('Đăng nhập dành cho Bác sĩ'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * LoginScreen renders UI correctly   | SPEC.md 3.1 & AUTH-01
 */
