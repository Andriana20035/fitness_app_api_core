import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/enums/workout_sort_option.dart';
import '../../domain/entities/fitness_data.dart';
import '../../domain/entities/workout_program.dart';
import '../cubit/fitness_cubit.dart';
import '../cubit/fitness_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/workout_card.dart';
import '../cubit/favorites_cubit.dart';
import 'workout_session_screen.dart';

class WorkoutProgramsScreen
    extends StatefulWidget {
  const WorkoutProgramsScreen({
    super.key,
  });

  @override
  State<WorkoutProgramsScreen>
  createState() =>
      _WorkoutProgramsScreenState();
}

class _WorkoutProgramsScreenState
    extends State<WorkoutProgramsScreen> {
  final TextEditingController
  _searchController =
  TextEditingController();

  FitnessCubit? _fitnessCubit;

  /// Show only workouts saved with the heart button.
  bool _savedOnly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fitnessCubit ??=
        context.read<FitnessCubit>();
  }

  @override
  void dispose() {
    final cubit = _fitnessCubit;

    if (cubit != null &&
        !cubit.isClosed) {
      cubit.resetWorkoutOptions();
    }

    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor:
        Colors.transparent,
        elevation: 0,
        title: const Text(
          'Workout Programs',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<
              WorkoutSortOption>(
            tooltip: 'Sort workouts',
            icon: const Icon(
              Icons.sort,
              color: AppColors.ink,
            ),
            onSelected: (option) {
              context
                  .read<FitnessCubit>()
                  .sortWorkouts(option);
            },
            itemBuilder: (context) {
              return WorkoutSortOption
                  .values
                  .where(
                    (option) =>
                option !=
                    WorkoutSortOption
                        .none,
              )
                  .map(
                    (option) =>
                    PopupMenuItem<
                        WorkoutSortOption>(
                      value: option,
                      child: Text(
                        option.label,
                      ),
                    ),
              )
                  .toList();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<
          FitnessCubit,
          FitnessState>(
        builder: (context, state) {
          if (state is FitnessLoading) {
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

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      FitnessData data, {
        String? emptyMessage,
      }) {
    return SingleChildScrollView(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        30,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          TextField(
            controller:
            _searchController,
            onChanged: (value) {
              context
                  .read<FitnessCubit>()
                  .searchWorkouts(value);
            },
            decoration: InputDecoration(
              hintText:
              'Search workouts...',
              hintStyle:
              const TextStyle(
                color: AppColors.grey,
              ),
              prefixIcon:
              const Icon(
                Icons.search,
                color: AppColors.grey,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();

                  context
                      .read<FitnessCubit>()
                      .searchWorkouts('');
                },
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor:
              const Color(0xFFF7F8FA),
              contentPadding:
              const EdgeInsets.symmetric(
                vertical: 14,
              ),
              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                borderSide:
                BorderSide.none,
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                borderSide:
                const BorderSide(
                  color: AppColors.line,
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                borderSide:
                const BorderSide(
                  color: AppColors.green,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection:
              Axis.horizontal,
              itemCount:
              data.filters.length + 1,
              itemBuilder:
                  (context, index) {
                if (index == 0) {
                  return FilterChipWidget(
                    label: '♥ Saved',
                    selected: _savedOnly,
                    onTap: () {
                      setState(() {
                        _savedOnly = !_savedOnly;
                      });
                    },
                  );
                }

                final filter =
                data.filters[index - 1];

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
          const SizedBox(height: 22),
          BlocBuilder<
              FavoritesCubit,
              Set<String>>(
            builder: (context, favorites) {
              final workouts = _savedOnly
                  ? data.workouts
                  .where(
                    (w) => favorites
                    .contains(w.id),
              )
                  .toList()
                  : data.workouts;

              final message =
              _savedOnly &&
                  data.workouts
                      .isNotEmpty
                  ? 'No saved workouts yet.\n'
                  'Tap ♥ on a workout to save it.'
                  : emptyMessage ??
                  'No workouts found';

              return _buildResults(
                context,
                workouts,
                favorites,
                message,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResults(
      BuildContext context,
      List<WorkoutProgram> workouts,
      Set<String> favorites,
      String emptyMessage,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              const Text(
                'Results',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
              Text(
                '${workouts.length} found',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (workouts.isEmpty)
            EmptyStateView(
              message: emptyMessage,
              iconSize: 42,
              padding:
              const EdgeInsets.symmetric(
                vertical: 55,
                horizontal: 24,
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children:
              workouts.map(
                    (workout) {
                  return SizedBox(
                    width: 156,
                    height: 184,
                    child: WorkoutCard(
                      workout: workout,
                      isFavorite: favorites
                          .contains(workout.id),
                      onFavoriteTap: () {
                        context
                            .read<FavoritesCubit>()
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
                    ),
                  );
                },
              ).toList(),
            ),
      ],
    );
  }

}