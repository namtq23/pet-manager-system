// EARS[Ubiquitous]: THE system SHALL store comparison pair records for before and after photos.

import 'medical_photo.dart';

class ComparisonPair {
  final MedicalPhoto beforePhoto;
  final MedicalPhoto afterPhoto;

  const ComparisonPair({
    required this.beforePhoto,
    required this.afterPhoto,
  });
}
