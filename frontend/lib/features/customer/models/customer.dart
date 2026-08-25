import 'pet.dart';

// EARS[Ubiquitous]: THE system SHALL store customer profiles.

class Customer {
  final String id;
  final String fullName;
  final String phone;
  final String? address;
  final String? notes;
  final List<Pet> pets;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.fullName,
    required this.phone,
    this.address,
    this.notes,
    this.pets = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    var rawPets = json['pets'];
    List<Pet> petsList = [];
    if (rawPets is List) {
      petsList = rawPets.map((p) => Pet.fromJson(p as Map<String, dynamic>)).toList();
    }
    return Customer(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      pets: petsList,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
