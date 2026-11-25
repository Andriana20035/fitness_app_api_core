import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/fitness_data.dart';
import '../cubit/fitness_cubit.dart';
import '../cubit/fitness_state.dart';
import '../cubit/activity_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../../domain/entities/activity.dart';
import '../widgets/activity_summary_card.dart';
import '../widgets/challenge_card.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/error_view.dart';
import '../widgets/featured_plan_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/section_header.dart';
import '../widgets/workout_card.dart';
import 'gym_details_screen.dart';
import 'workout_programs_screen.dart';
import 'workout_session_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<
            FitnessCubit,
            FitnessState>(
          builder: (context, state) {
            if (state
            is FitnessLoading) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            if (state is FitnessError) {
              return ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<FitnessCubit>().loadData(),
              );
            }

            if (state is FitnessSuccess) {
              return _buildContent(
                context,
                state.data,
              );
            }

            if (state is FitnessEmpty) {
              return _buildContent(
                context,
                state.data,
                emptyMessage:
                state.message,
              );
            }

            return const SizedBox
                .shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      FitnessData data, {
        String? emptyMessage,
      }) {
    return RefreshIndicator(
      color: AppColors.green,
      onRefresh: () =>
          context.read<FitnessCubit>().refresh(),
      child: SingleChildScrollView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.fromLTRB(
        24,
        29,
        0,
        30,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(
              right: 24,
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      data.header.date,
                      style:
                      const TextStyle(
                        fontSize: 12,
                        color:
                        AppColors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.header.greeting,
                      style:
                      const TextStyle(
                        fontSize: 19,
                        fontWeight:
                        FontWeight
                            .w700,
                        color:
                        AppColors.ink,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration:
                  BoxDecoration(
                    shape:
                    BoxShape.circle,
                    border:
                    Border.all(
                      color:
                      AppColors.line,
                    ),
                  ),
                  child: Stack(
                    alignment:
                    Alignment.center,
                    children: [
                      const Icon(
                        Icons
                            .notifications_none,
                        size: 25,
                      ),
                      if (data
                          .header
                          .hasUnread)
                        Positioned(
                          right: 14,
                          top: 11,
                          child:
                          Container(
                            width: 6,
                            height: 6,
                            decoration:
                            const BoxDecoration(
                              color: Color(
                                0xFFED475B,
                              ),
                              shape:
                              BoxShape
                                  .circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 29),
          Padding(
            padding:
            const EdgeInsets.only(
              right: 24,
            ),
            child: ChallengeCard(
              challenge:
              data.challenge,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding:
            const EdgeInsets.only(
              right: 24,
            ),
            child: BlocBuilder<
                ActivityCubit,
                ActivitySummary>(
              builder: (context, summary) {
                return ActivitySummaryCard(
                  summary: summary,
                );
              },
            ),
          ),
          const SizedBox(height: 27),
          const Padding(
            padding:
            EdgeInsets.only(
              right: 24,
            ),
            child: SectionHeader(
              title:
              'Featured Plan',
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 144,
            child: ListView.separated(
              scrollDirection:
              Axis.horizontal,
              padding:
              const EdgeInsets.only(
                right: 24,
              ),
              itemCount:
              data.featuredPlans
                  .length,
              separatorBuilder:
                  (context, index) {
                return const SizedBox(
                  width: 16,
                );
              },
              itemBuilder:
                  (context, index) {
                final plan =
                data.featuredPlans[
                index];

                return FeaturedPlanCard(
                  plan: plan,
                  onTap: () {
                    _openGymDetails(
                      context,
                      data,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 27),
          Padding(
            padding:
            const EdgeInsets.only(
              right: 24,
            ),
            child: SectionHeader(
              title:
              'Workout Programs',
              onActionTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const WorkoutProgramsScreen();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection:
              Axis.horizontal,
              itemCount:
              data.filters.length,
              itemBuilder:
                  (context, index) {
                final filter =
                data.filters[index];

                return FilterChipWidget(
                  label: filter.name,
                  selected:
                  filter.selected,
                  onTap: () {
                    context
                        .read<
                        FitnessCubit>()
                        .selectFilter(
                      filter.id,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (data.workouts.isEmpty)
            Padding(
              padding:
              const EdgeInsets.only(
                right: 24,
              ),
              child: EmptyStateView(
                message: emptyMessage ??
                    'No workouts found',
              ),
            )
          else
            SizedBox(
              height: 184,
              child:
              ListView.separated(
                scrollDirection:
                Axis.horizontal,
                padding:
                const EdgeInsets
                    .only(
                  right: 24,
                ),
                itemCount:
                data.workouts
                    .length,
                separatorBuilder:
                    (context, index) {
                  return const SizedBox(
                    width: 16,
                  );
                },
                itemBuilder:
                    (context, index) {
                  final workout =
                  data.workouts[
                  index];

                  return BlocSelector<
                      FavoritesCubit,
                      Set<String>,
                      bool>(
                    selector: (favorites) =>
                        favorites.contains(
                          workout.id,
                        ),
                    builder:
                        (context, isFavorite) {
                      return WorkoutCard(
                        workout: workout,
                        isFavorite: isFavorite,
                        onFavoriteTap: () {
                          context
                              .read<
                              FavoritesCubit>()
                              .toggle(workout.id);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutSessionScreen(
                                workout: workout,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      ),
    );
  }

  void _openGymDetails(
      BuildContext context,
      FitnessData data,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GymDetailsScreen(
            gym: data.gym,
            actions: data.gymActions,
          );
        },
      ),
    );
  }
}