import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/pet_controller.dart';
import '../models/pet.dart';

class PetFormDialog extends ConsumerStatefulWidget {
  final String customerId;
  final Pet? pet;

  const PetFormDialog({
    super.key,
    required this.customerId,
    this.pet,
  });

  @override
  ConsumerState<PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends ConsumerState<PetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _speciesCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _notesCtrl;
  String _gender = 'UNKNOWN';
  bool _isSubmitting = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.pet?.name ?? '');
    _speciesCtrl = TextEditingController(text: widget.pet?.species ?? '');
    _ageCtrl = TextEditingController(text: widget.pet?.age ?? '');
    _weightCtrl = TextEditingController(text: widget.pet?.weight?.toString() ?? '');
    _notesCtrl = TextEditingController(text: widget.pet?.notes ?? '');
    if (widget.pet != null) {
      _gender = widget.pet!.gender;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMsg = null;
    });

    try {
      final controller = ref.read(petControllerProvider.notifier);
      final weightVal = double.tryParse(_weightCtrl.text.trim());
      if (widget.pet == null) {
        final newPet = await controller.addPet(
          customerId: widget.customerId,
          name: _nameCtrl.text,
          species: _speciesCtrl.text,
          gender: _gender,
          age: _ageCtrl.text,
          weight: weightVal,
          notes: _notesCtrl.text,
        );
        if (mounted) Navigator.of(context).pop(newPet);
      } else {
        final updatedPet = await controller.updatePet(
          petId: widget.pet!.id,
          name: _nameCtrl.text,
          species: _speciesCtrl.text,
          gender: _gender,
          age: _ageCtrl.text,
          weight: weightVal,
          notes: _notesCtrl.text,
        );
        if (mounted) Navigator.of(context).pop(updatedPet);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pet != null;
    return AlertDialog(
      title: Text(isEdit ? 'Chỉnh sửa Thú cưng' : 'Thêm Thú cưng Mới'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMsg != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text(_errorMsg!, style: TextStyle(color: Colors.red.shade900)),
                  ),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên cún *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên cún' : null,
                ),
                TextFormField(
                  controller: _speciesCtrl,
                  decoration: const InputDecoration(labelText: 'Giống cún (VD: Poodle, Corgi)'),
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Giới tính'),
                  items: const [
                    DropdownMenuItem(value: 'UNKNOWN', child: Text('Chưa rõ')),
                    DropdownMenuItem(value: 'MALE', child: Text('Đực')),
                    DropdownMenuItem(value: 'FEMALE', child: Text('Cái')),
                  ],
                  onChanged: (val) => setState(() => _gender = val ?? 'UNKNOWN'),
                ),
                TextFormField(
                  controller: _ageCtrl,
                  decoration: const InputDecoration(labelText: 'Tuổi (VD: 2 tuổi, 6 tháng)'),
                ),
                TextFormField(
                  controller: _weightCtrl,
                  decoration: const InputDecoration(labelText: 'Cân nặng (kg)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(labelText: 'Ghi chú sức khỏe/Đặc điểm'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(isEdit ? 'Lưu' : 'Thêm'),
        ),
      ],
    );
  }
}
