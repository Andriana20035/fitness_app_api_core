import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/fitness_data.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeData challenge;

  const ChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    color: Color(0xFFABB1C0),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  challenge.activity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: challenge.progress,
                    strokeWidth: 4,
                    backgroundColor: const Color(0xFF34343C),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.green,
                    ),
                  ),
                ),
                Text(
                  '${challenge.completed}/${challenge.total}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}