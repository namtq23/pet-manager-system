// EARS[Ubiquitous]: THE system SHALL manage timeline and before/after photo comparison state.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comparison_pair.dart';
import '../models/medical_photo.dart';

final timelineControllerProvider = ChangeNotifierProvider((ref) => TimelineController());

class TimelineController extends ChangeNotifier {
  MedicalPhoto? _beforePhoto;
  MedicalPhoto? _afterPhoto;

  MedicalPhoto? get beforePhoto => _beforePhoto;
  MedicalPhoto? get afterPhoto => _afterPhoto;

  // EARS[Event]: WHEN user selects a photo for before position
  void selectBeforePhoto(MedicalPhoto photo) {
    if (_beforePhoto?.id == photo.id) {
      _beforePhoto = null;
    } else {
      _beforePhoto = photo;
      if (_afterPhoto?.id == photo.id) {
        _afterPhoto = null;
      }
    }
    notifyListeners();
  }

  // EARS[Event]: WHEN user selects a photo for after position
  void selectAfterPhoto(MedicalPhoto photo) {
    if (_afterPhoto?.id == photo.id) {
      _afterPhoto = null;
    } else {
      _afterPhoto = photo;
      if (_beforePhoto?.id == photo.id) {
        _beforePhoto = null;
      }
    }
    notifyListeners();
  }

  // EARS[Event]: WHEN user clears photo comparison selection
  void clearSelection() {
    _beforePhoto = null;
    _afterPhoto = null;
    notifyListeners();
  }

  // EARS[State-Driven]: WHILE checking if comparison is ready
  bool isComparisonReady() {
    return _beforePhoto != null && _afterPhoto != null;
  }

  // EARS[State-Driven]: WHILE getting the comparison pair
  ComparisonPair? getComparisonPair() {
    if (!isComparisonReady()) return null;
    return ComparisonPair(
      beforePhoto: _beforePhoto!,
      afterPhoto: _afterPhoto!,
    );
  }
}
