import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Reusable "nothing to show" placeholder (e.g. no workouts match a filter).
class EmptyStateView extends StatelessWidget {
  final String message;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const EmptyStateView({
    super.key,
    required this.message,
    this.iconSize = 32,
    this.padding = const EdgeInsets.symmetric(vertical: 31, horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            color: AppColors.grey,
            size: iconSize,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
