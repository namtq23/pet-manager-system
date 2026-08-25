// EARS[Ubiquitous]: THE system SHALL store medical session records.

class MedicalSession {
  final String id;
  final String petId;
  final DateTime sessionDate;
  final String title;
  final String? diagnosis;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;

  MedicalSession({
    required this.id,
    required this.petId,
    required this.sessionDate,
    required this.title,
    this.diagnosis,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  factory MedicalSession.fromJson(Map<String, dynamic> json) {
    return MedicalSession(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      sessionDate: DateTime.parse(json['session_date'] as String),
      title: json['title'] as String,
      diagnosis: json['diagnosis'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'session_date': sessionDate.toIso8601String(),
      'title': title,
      'diagnosis': diagnosis,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
