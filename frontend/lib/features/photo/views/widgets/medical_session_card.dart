import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/medical_session.dart';
import '../../controllers/photo_upload_controller.dart';
import 'photo_gallery_grid.dart';

class MedicalSessionCard extends ConsumerWidget {
  final MedicalSession session;
  final VoidCallback? onDeleteSession;

  const MedicalSessionCard({
    super.key,
    required this.session,
    this.onDeleteSession,
  });

  Future<void> _confirmDeleteSession(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Xác nhận xóa đợt khám'),
        content: Text(
          'Bạn có chắc chắn muốn xóa đợt khám "${session.title}" không?\n(Lưu ý: Tất cả ảnh và ghi chú trong đợt khám này sẽ bị xóa vĩnh viễn)',
        ),
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

    if (confirmed == true && onDeleteSession != null) {
      onDeleteSession!();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(sessionPhotosProvider(session.id));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDeleteSession != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Xóa đợt khám',
                    onPressed: () => _confirmDeleteSession(context, ref),
                  ),
              ],
            ),
            Text(
              'Ngày khám: ${session.sessionDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            if (session.diagnosis != null && session.diagnosis!.isNotEmpty)
              Text('Chẩn đoán: ${session.diagnosis}'),
            if (session.notes != null && session.notes!.isNotEmpty)
              Text('Ghi chú: ${session.notes}'),
            const SizedBox(height: 12),
            photosAsync.when(
              data: (photos) => PhotoGalleryGrid(
                photos: photos,
                onDelete: (photo) async {
                  await ref.read(photoUploadControllerProvider.notifier).deletePhoto(photo.id, photo.storagePath);
                  ref.invalidate(sessionPhotosProvider(session.id));
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Lỗi tải ảnh: $err'),
            ),
          ],
        ),
      ),
    );
  }
}
