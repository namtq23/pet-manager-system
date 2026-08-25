import 'dart:typed_data';
import 'package:image/image.dart' as img;

// EARS[Event]: WHEN Bác sĩ chọn ảnh, THE system SHALL nén client-side (max 1920px, JPEG 85%).

class ImageCompressor {
  static const int maxDimension = 1920;
  static const int jpegQuality = 85;

  static Uint8List compressImage(Uint8List inputBytes) {
    final original = img.decodeImage(inputBytes);
    if (original == null) return inputBytes;

    img.Image resized = original;
    if (original.width > maxDimension || original.height > maxDimension) {
      if (original.width >= original.height) {
        resized = img.copyResize(original, width: maxDimension);
      } else {
        resized = img.copyResize(original, height: maxDimension);
      }
    }

    final compressed = img.encodeJpg(resized, quality: jpegQuality);
    return Uint8List.fromList(compressed);
  }
}
