// EARS[Ubiquitous]: THE system SHALL display pet medical session timeline with photos.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/medical_session_controller.dart';
import '../controllers/timeline_controller.dart';
import 'widgets/timeline_node_widget.dart';
import 'widgets/before_after_comparison_viewer.dart';
import 'dialogs/create_session_dialog.dart';

class PetTimelineScreen extends ConsumerWidget {
  final String petId;
  const PetTimelineScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(medicalSessionsListProvider(petId));
    final timelineCtrl = ref.watch(timelineControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến Trình Đợt Khám (Timeline)'),
        actions: [
          if (timelineCtrl.beforePhoto != null || timelineCtrl.afterPhoto != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Bỏ chọn ảnh',
              onPressed: () => ref.read(timelineControllerProvider).clearSelection(),
            ),
          if (timelineCtrl.isComparisonReady())
            IconButton(
              icon: const Icon(Icons.compare, color: Colors.blue),
              tooltip: 'So sánh Trước / Sau',
              onPressed: () => _openComparison(context, timelineCtrl),
            ),
        ],
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('Chưa có tiến trình đợt khám nào.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return TimelineNodeWidget(
                session: session,
                isFirst: index == 0,
                isLast: index == sessions.length - 1,
                onDeleteSession: () async {
                  await ref.read(medicalSessionControllerProvider.notifier).deleteSession(session.id);
                  ref.invalidate(medicalSessionsListProvider(petId));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi tải timeline: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await showDialog<bool>(
            context: context,
            builder: (_) => CreateSessionDialog(petId: petId),
          );
          if (res == true) ref.invalidate(medicalSessionsListProvider(petId));
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Tạo Lần Khám'),
      ),
    );
  }

  void _openComparison(BuildContext context, TimelineController ctrl) {
    final pair = ctrl.getComparisonPair();
    if (pair == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BeforeAfterComparisonViewer(
          beforePhoto: pair.beforePhoto,
          afterPhoto: pair.afterPhoto,
        ),
      ),
    );
  }
}
