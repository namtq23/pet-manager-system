// EARS[Ubiquitous]: THE system SHALL store medical photo records.

class MedicalPhoto {
  final String id;
  final String sessionId;
  final String storagePath;
  final String publicUrl;
  final String? caption;
  final DateTime? takenAt;
  final DateTime createdAt;
  final String? createdBy;

  MedicalPhoto({
    required this.id,
    required this.sessionId,
    required this.storagePath,
    required this.publicUrl,
    this.caption,
    this.takenAt,
    required this.createdAt,
    this.createdBy,
  });

  factory MedicalPhoto.fromJson(Map<String, dynamic> json) {
    return MedicalPhoto(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      storagePath: json['storage_path'] as String,
      publicUrl: json['public_url'] as String,
      caption: json['caption'] as String?,
      takenAt: json['taken_at'] != null
          ? DateTime.parse(json['taken_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'storage_path': storagePath,
      'public_url': publicUrl,
      'caption': caption,
      'taken_at': takenAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
