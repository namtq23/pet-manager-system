import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/timeline_controller.dart';
import '../../models/medical_photo.dart';
import 'photo_lightbox_viewer.dart';

class PhotoGalleryGrid extends ConsumerWidget {
  final List<MedicalPhoto> photos;
  final Function(MedicalPhoto)? onDelete;

  const PhotoGalleryGrid({
    super.key,
    required this.photos,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (photos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Chưa có ảnh chụp nào cho đợt khám này.', style: TextStyle(color: Colors.grey)),
      );
    }

    final timelineCtrl = ref.watch(timelineControllerProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final isBefore = timelineCtrl.beforePhoto?.id == photo.id;
        final isAfter = timelineCtrl.afterPhoto?.id == photo.id;
        final isSelected = isBefore || isAfter;

        return InkWell(
          onTap: () => PhotoLightboxViewer.show(context, photos, index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: isBefore ? Colors.blue : Colors.green,
                          width: 3,
                        )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(photo.publicUrl, fit: BoxFit.cover),
                ),
              ),
              // Selection Badges
              Positioned(
                bottom: 4,
                left: 4,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => ref.read(timelineControllerProvider).selectBeforePhoto(photo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isBefore ? Colors.blue : Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Trước',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: isBefore ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => ref.read(timelineControllerProvider).selectAfterPhoto(photo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isAfter ? Colors.green : Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Sau',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: isAfter ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogCtx) => AlertDialog(
                          title: const Text('Xác nhận xóa ảnh'),
                          content: const Text('Bạn có chắc chắn muốn xóa ảnh này khỏi đợt khám không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogCtx).pop(false),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.of(dialogCtx).pop(true),
                              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        onDelete!(photo);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete, size: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
