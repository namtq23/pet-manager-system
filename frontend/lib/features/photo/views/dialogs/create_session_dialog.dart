import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/medical_session_controller.dart';
import '../../controllers/photo_upload_controller.dart';

class CreateSessionDialog extends ConsumerStatefulWidget {
  final String petId;
  const CreateSessionDialog({super.key, required this.petId});

  @override
  ConsumerState<CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends ConsumerState<CreateSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  List<UploadPhotoItem> _selectedPhotos = [];
  bool _isLoading = false;

  Future<void> _pickPhotos(bool fromCamera) async {
    final items = await ref.read(photoUploadControllerProvider.notifier).pickImages(fromCamera: fromCamera);
    setState(() => _selectedPhotos.addAll(items));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final session = await ref.read(medicalSessionControllerProvider.notifier).createSession(
            petId: widget.petId,
            title: _titleController.text.trim(),
            diagnosis: _diagnosisController.text.trim(),
            notes: _notesController.text.trim(),
          );

      if (session != null && _selectedPhotos.isNotEmpty) {
        await ref.read(photoUploadControllerProvider.notifier).uploadPhotos(
              sessionId: session.id,
              petId: widget.petId,
              items: _selectedPhotos,
            );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo Lần Khám Mới'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Tiêu đề lần khám *'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                ),
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(labelText: 'Chẩn đoán / Triệu chứng'),
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Ghi chú điều trị'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickPhotos(true),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Chụp ảnh'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickPhotos(false),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Chọn ảnh'),
                    ),
                  ],
                ),
                if (_selectedPhotos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Đã chọn ${_selectedPhotos.length} ảnh'),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Lưu'),
        ),
      ],
    );
  }
}
