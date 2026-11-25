import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/gym.dart';

class AmenityCard extends StatelessWidget {
  final Amenity amenity;

  const AmenityCard({
    super.key,
    required this.amenity,
  });

  String _getLocalIcon() {
    switch (amenity.name.toLowerCase()) {
      case 'showers':
        return 'assets/icons/shower.png';

      case 'lockers':
        return 'assets/icons/locker.png';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = _getLocalIcon();

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.line,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          if (iconPath.isNotEmpty)
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
          const SizedBox(width: 12),
          Text(
            amenity.name,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}