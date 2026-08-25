// EARS[Ubiquitous]: THE system SHALL store pet records.

class Pet {
  final String id;
  final String customerId;
  final String name;
  final String? species;
  final String gender;
  final String? age;
  final double? weight;
  final String? notes;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.customerId,
    required this.name,
    this.species,
    this.gender = 'UNKNOWN',
    this.age,
    this.weight,
    this.notes,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      name: json['name'] as String,
      species: json['species'] as String?,
      gender: json['gender'] as String? ?? 'UNKNOWN',
      age: json['age'] as String?,
      weight: (json['weight'] != null)
          ? double.tryParse(json['weight'].toString())
          : null,
      notes: json['notes'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'name': name,
      'species': species,
      'gender': gender,
      'age': age,
      'weight': weight,
      'notes': notes,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
