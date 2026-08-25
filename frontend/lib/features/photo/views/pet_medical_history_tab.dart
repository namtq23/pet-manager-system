import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/medical_session_controller.dart';
import 'widgets/medical_session_card.dart';
import 'dialogs/create_session_dialog.dart';

class PetMedicalHistoryTab extends ConsumerWidget {
  final String petId;
  const PetMedicalHistoryTab({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(medicalSessionsListProvider(petId));

    return Scaffold(
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu đợt khám nào.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return MedicalSessionCard(
                session: session,
                onDeleteSession: () async {
                  await ref.read(medicalSessionControllerProvider.notifier).deleteSession(session.id);
                  ref.invalidate(medicalSessionsListProvider(petId));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi tải danh sách lần khám: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await showDialog<bool>(
            context: context,
            builder: (_) => CreateSessionDialog(petId: petId),
          );
          if (res == true) {
            ref.invalidate(medicalSessionsListProvider(petId));
          }
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Tạo Lần Khám'),
      ),
    );
  }
}
