import 'package:flutter/material.dart';
import 'app_image.dart';
import 'favorite_button.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/workout_program.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutProgram workout;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              source: workout.imageUrl,
              fit: BoxFit.cover,
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xD9000000),
                  ],
                  stops: [0.38, 1],
                ),
              ),
            ),

            if (onFavoriteTap != null)
              Positioned(
                top: 8,
                left: 8,
                child: FavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap!,
                ),
              ),

            if (workout.isPro)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7FFF1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/pro_crown.png',
                        width: 12,
                        height: 10,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'Pro',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Positioned(
              left: 13,
              right: 10,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/flame.png',
                              width: 11,
                              height: 11,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '${workout.calories} kcl',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 11,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '${workout.durationMinutes} min',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}