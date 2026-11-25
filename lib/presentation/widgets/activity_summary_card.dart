import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/activity.dart';

/// "Today's Activity" card: workouts, burned calories and active minutes.
class ActivitySummaryCard extends StatelessWidget {
  final ActivitySummary summary;

  const ActivitySummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              icon: Icons.fitness_center,
              value: '${summary.workoutsCount}',
              label: 'Workouts',
            ),
          ),
          Expanded(
            child: StatItem(
              icon: Icons.local_fire_department_outlined,
              value: '${summary.caloriesBurned}',
              label: 'kcal',
            ),
          ),
          Expanded(
            child: StatItem(
              icon: Icons.schedule,
              value: '${summary.activeMinutes}',
              label: 'min',
            ),
          ),
        ],
      ),
    );
  }
}

/// Small icon + value + label block, reused on the session summary too.
class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFE7FFF1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.green),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
