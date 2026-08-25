import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/customer_controller.dart';
import '../controllers/pet_controller.dart';
import '../models/customer.dart';
import '../models/pet.dart';
import 'pet_form_dialog.dart';
import 'customer_form_dialog.dart';
import '../../photo/views/pet_medical_history_tab.dart';
import '../../photo/views/pet_timeline_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => CustomerFormDialog(customer: customer),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerInfoCard(context),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 450) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Danh sách Thú cưng (${customer.pets.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => PetFormDialog(customerId: customer.id),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm Thú cưng'),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách Thú cưng (${customer.pets.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => PetFormDialog(customerId: customer.id),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm Thú cưng'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            if (customer.pets.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Chưa có thông tin thú cưng nào.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: customer.pets.length,
                itemBuilder: (context, index) {
                  final pet = customer.pets[index];
                  return _buildPetCard(context, ref, pet);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.blue),
              title: Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('SĐT: ${customer.phone}'),
            ),
            if (customer.address != null && customer.address!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('Địa chỉ: ${customer.address}'),
              ),
            if (customer.notes != null && customer.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('Ghi chú: ${customer.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, WidgetRef ref, Pet pet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: const Icon(Icons.pets, color: Colors.orange),
        ),
        title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Giống: ${pet.species ?? "Chưa rõ"}\nTuổi: ${pet.age ?? "Chưa rõ"} | Nặng: ${pet.weight != null ? "${pet.weight} kg" : "Chưa rõ"}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.timeline, color: Colors.blue),
              tooltip: 'Xem Timeline Tiến Trình',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PetTimelineScreen(petId: pet.id),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Chỉnh sửa',
              onPressed: () => showDialog(
                context: context,
                builder: (_) => PetFormDialog(customerId: customer.id, pet: pet),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Xóa thú cưng',
              onPressed: () => _confirmDeletePet(context, ref, pet),
            ),
          ],
        ),
        children: [
          SizedBox(
            height: 350,
            child: PetMedicalHistoryTab(petId: pet.id),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeletePet(BuildContext context, WidgetRef ref, Pet pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa thú cưng "${pet.name}" khỏi hồ sơ khách hàng không?\n(Lưu ý: Tất cả đợt khám và ảnh liên quan cũng sẽ bị xóa)'),
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
      try {
        await ref.read(petControllerProvider.notifier).deletePet(pet.id);
        // Refresh customer list / detail
        ref.read(customerControllerProvider.notifier).searchCustomers('');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã xóa thú cưng "${pet.name}" thành công!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa: $e')),
          );
        }
      }
    }
  }
}
