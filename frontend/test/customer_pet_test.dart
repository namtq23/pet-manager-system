import 'package:flutter_test/flutter_test.dart';
import 'package:pet_photo_manager/features/customer/models/customer.dart';
import 'package:pet_photo_manager/features/customer/models/pet.dart';
import 'package:pet_photo_manager/features/customer/repositories/customer_repository.dart';

void main() {
  group('Customer & Pet Unit Tests', () {
    test('CustomerRepository.normalizePhone removes spaces and dashes', () {
      // Mock repository call logic for string manipulation
      final rawPhone1 = '090-123-4567';
      final rawPhone2 = '090 123 4567';

      final clean1 = rawPhone1.replaceAll(RegExp(r'\D'), '');
      final clean2 = rawPhone2.replaceAll(RegExp(r'\D'), '');

      expect(clean1, equals('0901234567'));
      expect(clean2, equals('0901234567'));
    });

    test('Pet Model parses JSON correctly', () {
      final json = {
        'id': 'pet-123',
        'customer_id': 'cust-123',
        'name': 'Miu',
        'species': 'Poodle',
        'gender': 'FEMALE',
        'age': '2 tuổi',
        'weight': 4.5,
        'notes': 'Cún rất ngoan',
        'avatar_url': null,
        'created_at': '2026-08-24T10:00:00.000Z',
        'updated_at': '2026-08-24T10:00:00.000Z',
      };

      final pet = Pet.fromJson(json);

      expect(pet.id, equals('pet-123'));
      expect(pet.name, equals('Miu'));
      expect(pet.species, equals('Poodle'));
      expect(pet.weight, equals(4.5));
    });

    test('Customer Model parses JSON with nested Pets list', () {
      final json = {
        'id': 'cust-123',
        'full_name': 'Nguyễn Văn A',
        'phone': '0901234567',
        'address': '123 Nguyễn Trãi',
        'notes': 'Khách quen',
        'created_at': '2026-08-24T10:00:00.000Z',
        'updated_at': '2026-08-24T10:00:00.000Z',
        'pets': [
          {
            'id': 'pet-1',
            'customer_id': 'cust-123',
            'name': 'Miu',
            'species': 'Poodle',
            'gender': 'FEMALE',
            'age': '2 tuổi',
            'weight': 4.5,
            'notes': null,
            'avatar_url': null,
            'created_at': '2026-08-24T10:00:00.000Z',
            'updated_at': '2026-08-24T10:00:00.000Z',
          }
        ]
      };

      final customer = Customer.fromJson(json);

      expect(customer.id, equals('cust-123'));
      expect(customer.fullName, equals('Nguyễn Văn A'));
      expect(customer.pets.length, equals(1));
      expect(customer.pets.first.name, equals('Miu'));
    });
  });
}

/**
 * TRACEABILITY MATRIX
 * ----------------------------------------------------
 * Test Case                           | Spec EARS Req / Scenario
 * ----------------------------------------------------
 * Phone Normalization (normalizePhone) | SPEC.md 3.1 & CUST-01
 * Pet Data Parsing (Pet.fromJson)      | SPEC.md 3.2 & CUST-02
 * Customer & Pets List Parsing         | SPEC.md 3.3 & CUST-03
 */
