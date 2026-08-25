import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/medical_photo.dart';
import '../repositories/medical_photo_repository.dart';
import '../../../core/utils/image_compressor.dart';
import '../../../core/network/supabase_client_provider.dart';

final medicalPhotoRepositoryProvider = Provider<MedicalPhotoRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MedicalPhotoRepository(client);
});

final sessionPhotosProvider =
    FutureProvider.family<List<MedicalPhoto>, String>((ref, sessionId) async {
  final repo = ref.watch(medicalPhotoRepositoryProvider);
  return repo.getPhotosBySessionId(sessionId);
});

class UploadPhotoItem {
  final Uint8List bytes;
  final String fileName;
  final String? caption;

  UploadPhotoItem({
    required this.bytes,
    required this.fileName,
    this.caption,
  });
}

class PhotoUploadController extends StateNotifier<AsyncValue<void>> {
  final MedicalPhotoRepository _repository;
  final ImagePicker _picker = ImagePicker();

  PhotoUploadController(this._repository) : super(const AsyncValue.data(null));

  // EARS[Event]: Pick images from camera/gallery
  Future<List<UploadPhotoItem>> pickImages({bool fromCamera = false}) async {
    if (fromCamera) {
      final XFile? file = await _picker.pickImage(source: ImageSource.camera);
      if (file == null) return [];
      final bytes = await file.readAsBytes();
      final compressed = ImageCompressor.compressImage(bytes);
      return [UploadPhotoItem(bytes: compressed, fileName: file.name)];
    } else {
      final List<XFile> files = await _picker.pickMultiImage();
      final List<UploadPhotoItem> items = [];
      for (final file in files) {
        final bytes = await file.readAsBytes();
        final compressed = ImageCompressor.compressImage(bytes);
        items.add(UploadPhotoItem(bytes: compressed, fileName: file.name));
      }
      return items;
    }
  }

  // EARS[Event]: Batch upload photos for a session
  Future<List<MedicalPhoto>> uploadPhotos({
    required String sessionId,
    required String petId,
    required List<UploadPhotoItem> items,
  }) async {
    state = const AsyncValue.loading();
    try {
      final List<MedicalPhoto> uploaded = [];
      for (final item in items) {
        final photo = await _repository.uploadPhoto(
          sessionId: sessionId,
          petId: petId,
          bytes: item.bytes,
          fileName: item.fileName,
          caption: item.caption,
        );
        uploaded.add(photo);
      }
      state = const AsyncValue.data(null);
      return uploaded;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // EARS[Event]: Delete single photo
  Future<void> deletePhoto(String photoId, String storagePath) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePhoto(photoId, storagePath);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final photoUploadControllerProvider =
    StateNotifierProvider<PhotoUploadController, AsyncValue<void>>((ref) {
  final repo = ref.watch(medicalPhotoRepositoryProvider);
  return PhotoUploadController(repo);
});
