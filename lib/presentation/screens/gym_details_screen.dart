import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/gym.dart';
import '../widgets/app_image.dart';
import '../widgets/amenity_card.dart';

class GymDetailsScreen extends StatelessWidget {
  final Gym gym;
  final GymActions actions;

  const GymDetailsScreen({
    super.key,
    required this.gym,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 360,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(
                            source: gym.heroImageUrl,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            top: 20,
                            left: 24,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.65,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 25,
                            right: 24,
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        24,
                        24,
                        120,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFB744),
                                size: 20,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                gym.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${gym.reviewCount} reviews)',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            gym.name,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            gym.location,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            height: 1,
                            color: AppColors.line,
                          ),

                          const SizedBox(height: 22),

                          Text(
                            gym.description,
                            maxLines: gym.descriptionExpanded ? null : 3,
                            overflow: gym.descriptionExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Amenities',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: gym.amenities
                                .map(
                                  (amenity) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right:
                                    amenity !=
                                        gym.amenities.last
                                        ? 12
                                        : 0,
                                  ),
                                  child: AmenityCard(
                                    amenity: amenity,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 104,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.line,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      gym.pricing.formatted,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 160,
                height: 54,
                child: ElevatedButton(
                  onPressed: !actions.reserve.enabled
                      ? null
                      : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Reservation completed successfully!',
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.green,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    actions.reserve.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}