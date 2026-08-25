// EARS[Ubiquitous]: THE system SHALL display medical session nodes in a vertical timeline structure.

import 'package:flutter/material.dart';
import '../../models/medical_session.dart';
import 'medical_session_card.dart';

class TimelineNodeWidget extends StatelessWidget {
  final MedicalSession session;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onDeleteSession;

  const TimelineNodeWidget({
    super.key,
    required this.session,
    this.isFirst = false,
    this.isLast = false,
    this.onDeleteSession,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Timeline vertical connecting line stretching full height of node
        Positioned(
          left: 7,
          top: isFirst ? 24 : 0,
          bottom: isLast ? 24 : 0,
          child: Container(
            width: 2,
            color: Colors.grey.shade300,
          ),
        ),
        // Timeline indicator dot
        Positioned(
          left: 0,
          top: 24,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        // Card content defining node height
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: MedicalSessionCard(
            session: session,
            onDeleteSession: onDeleteSession,
          ),
        ),
      ],
    );
  }
}
