import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';
import 'customer_detail_screen.dart';
import 'customer_form_dialog.dart';
import '../../admin/views/user_management_screen.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/profile_screen.dart';

class CustomerSearchScreen extends ConsumerStatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  ConsumerState<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends ConsumerState<CustomerSearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(customerControllerProvider.notifier).searchCustomers(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final isAdmin = authState is AuthAuthenticated && authState.profile.role == 'ADMIN';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_hospital),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Bệnh Viện Thú Y Mỹ Đình',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Quản lý Bác sĩ (Admin)',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserManagementScreen()),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Trang cá nhân',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Thêm Khách hàng',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const CustomerFormDialog(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Nhập SĐT hoặc Tên chủ nuôi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.errorMessage != null)
              Expanded(
                child: Center(
                  child: Text('Lỗi: ${state.errorMessage}', style: const TextStyle(color: Colors.red)),
                ),
              )
            else if (state.customers.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Không tìm thấy thông tin chủ nuôi phù hợp'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => const CustomerFormDialog(),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm Khách hàng Mới'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.customers.length,
                  itemBuilder: (context, index) {
                    final customer = state.customers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(customer.fullName.isNotEmpty ? customer.fullName[0].toUpperCase() : '?'),
                        ),
                        title: Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('SĐT: ${customer.phone} | Cún: ${customer.pets.map((p) => p.name).join(", ")}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CustomerDetailScreen(customer: customer),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
