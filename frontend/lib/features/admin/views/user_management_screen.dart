import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_user_controller.dart';
import 'create_doctor_dialog.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState
    extends ConsumerState<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminUserControllerProvider.notifier).loadDoctors();
    });
  }

  Future<void> _toggleStatus(String userId, String currentStatus) async {
    try {
      await ref
          .read(adminUserControllerProvider.notifier)
          .toggleStatus(userId, currentStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật trạng thái thành công!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Guard: Only ADMIN role can access this screen
    if (authState is AuthAuthenticated && authState.profile.role != 'ADMIN') {
      return Scaffold(
        appBar: AppBar(title: const Text('Truy cập bị từ chối')),
        body: const Center(
          child: Text('Bạn không có quyền truy cập trang Quản lý Admin.'),
        ),
      );
    }

    final adminState = ref.watch(adminUserControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Tài khoản Bác sĩ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(adminUserControllerProvider.notifier).loadDoctors(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const CreateDoctorDialog(),
          );
          if (result == true) {
            ref.read(adminUserControllerProvider.notifier).loadDoctors();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm Bác sĩ'),
      ),
      body: _buildBody(adminState),
    );
  }

  Widget _buildBody(AdminUserState state) {
    if (state is AdminUserLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminUserError) {
      return Center(
        child: Text(
          'Lỗi: ${state.message}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state is AdminUserLoaded) {
      final doctors = state.doctors;
      if (doctors.isEmpty) {
        return const Center(child: Text('Chưa có bác sĩ nào trong hệ thống.'));
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final doc = doctors[index];
          final isActive = doc.status == 'ACTIVE';

          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isActive ? Colors.blue.shade100 : Colors.grey.shade300,
                      child: Text(
                        doc.fullName.isNotEmpty ? doc.fullName[0].toUpperCase() : 'D',
                      ),
                    ),
                    title: Text(
                      doc.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${doc.email}\nSĐT: ${doc.phone ?? "Chưa có SĐT"}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            isActive ? 'ĐANG HOẠT ĐỘNG' : 'ĐÃ VÔ HIỆU HÓA',
                            style: TextStyle(
                              fontSize: 11,
                              color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                          backgroundColor:
                              isActive ? Colors.green.shade50 : Colors.red.shade50,
                        ),
                        IconButton(
                          icon: Icon(
                            isActive ? Icons.block : Icons.check_circle_outline,
                            color: isActive ? Colors.red : Colors.green,
                          ),
                          tooltip: isActive ? 'Vô hiệu hóa' : 'Kích hoạt lại',
                          onPressed: () => _toggleStatus(doc.id, doc.status),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const SizedBox();
  }
}
