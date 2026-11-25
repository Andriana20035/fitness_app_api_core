import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/time_format.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/workout_program.dart';
import '../cubit/activity_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/workout_timer_cubit.dart';
import '../widgets/activity_summary_card.dart';
import '../widgets/app_image.dart';
import '../widgets/favorite_button.dart';

/// Guided workout session with a countdown timer.
class WorkoutSessionScreen extends StatelessWidget {
  final WorkoutProgram workout;

  const WorkoutSessionScreen({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutTimerCubit(
        durationSeconds: workout.durationMinutes * 60,
      ),
      child: _WorkoutSessionView(workout: workout),
    );
  }
}

class _WorkoutSessionView extends StatelessWidget {
  final WorkoutProgram workout;

  const _WorkoutSessionView({required this.workout});

  int _burnedCalories(WorkoutTimerState state) =>
      (workout.calories * state.progress).round();

  bool _isInProgress(WorkoutTimerState state) =>
      state.hasStarted && state.status != TimerStatus.finished;

  Future<void> _onFinished(
    BuildContext context,
    WorkoutTimerState state,
  ) async {
    if (state.elapsedSeconds == 0) {
      Navigator.pop(context);
      return;
    }

    final calories = _burnedCalories(state);
    await context.read<ActivityCubit>().recordWorkout(
          CompletedWorkout(
            workoutId: workout.id,
            title: workout.title,
            caloriesBurned: calories,
            durationSeconds: state.elapsedSeconds,
            completedAt: DateTime.now(),
          ),
        );

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SessionSummarySheet(
        title: workout.title,
        calories: calories,
        elapsedSeconds: state.elapsedSeconds,
      ),
    );

    if (context.mounted) Navigator.pop(context);
  }

  Future<bool> _confirmLeave(BuildContext context) async {
    final timer = context.read<WorkoutTimerCubit>();
    timer.pause();

    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Leave workout?',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
        content: const Text(
          'Your progress in this session will not be saved.',
          style: TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Continue',
              style: TextStyle(color: AppColors.green),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Leave',
              style: TextStyle(color: Color(0xFFED475B)),
            ),
          ),
        ],
      ),
    );

    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutTimerCubit, WorkoutTimerState>(
      listenWhen: (prev, curr) =>
          prev.status != TimerStatus.finished &&
          curr.status == TimerStatus.finished,
      listener: _onFinished,
      builder: (context, state) {
        return PopScope(
          canPop: !_isInProgress(state),
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (await _confirmLeave(context) && context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHero(context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${workout.calories} kcal  •  '
                            '${workout.durationMinutes} min',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(height: 1, color: AppColors.line),
                          const SizedBox(height: 32),
                          Center(child: _TimerRing(state: state)),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: StatItem(
                                  icon: Icons.local_fire_department_outlined,
                                  value: '${_burnedCalories(state)}',
                                  label: 'kcal burned',
                                ),
                              ),
                              Expanded(
                                child: StatItem(
                                  icon: Icons.timer_outlined,
                                  value: formatClock(state.elapsedSeconds),
                                  label: 'elapsed',
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
            ),
            bottomNavigationBar: _buildControls(context, state),
          ),
        );
      },
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(source: workout.imageUrl, fit: BoxFit.cover),
          Positioned(
            top: 20,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 24,
            child: BlocBuilder<FavoritesCubit, Set<String>>(
              builder: (context, favorites) => FavoriteButton(
                size: 48,
                isFavorite: favorites.contains(workout.id),
                onTap: () =>
                    context.read<FavoritesCubit>().toggle(workout.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, WorkoutTimerState state) {
    final timer = context.read<WorkoutTimerCubit>();

    final (String label, IconData icon, VoidCallback? action) =
        switch (state.status) {
      TimerStatus.initial => ('Start', Icons.play_arrow_rounded, timer.start),
      TimerStatus.running => ('Pause', Icons.pause_rounded, timer.pause),
      TimerStatus.paused => ('Resume', Icons.play_arrow_rounded, timer.resume),
      TimerStatus.finished => ('Done', Icons.check_rounded, null),
    };

    return SafeArea(
      child: Container(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: state.hasStarted &&
                          state.status != TimerStatus.finished
                      ? timer.finish
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: action,
                  icon: Icon(icon),
                  label: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final WorkoutTimerState state;

  const _TimerRing({required this.state});

  @override
  Widget build(BuildContext context) {
    final statusText = switch (state.status) {
      TimerStatus.initial => 'Ready',
      TimerStatus.running => 'remaining',
      TimerStatus.paused => 'Paused',
      TimerStatus.finished => 'Completed',
    };

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: state.progress),
              duration: const Duration(milliseconds: 400),
              builder: (_, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.line,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.green),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatClock(state.remainingSeconds),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionSummarySheet extends StatelessWidget {
  final String title;
  final int calories;
  final int elapsedSeconds;

  const _SessionSummarySheet({
    required this.title,
    required this.calories,
    required this.elapsedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE7FFF1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.green,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Great job!',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You completed $title',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: StatItem(
                    icon: Icons.local_fire_department_outlined,
                    value: '$calories',
                    label: 'kcal burned',
                  ),
                ),
                Expanded(
                  child: StatItem(
                    icon: Icons.timer_outlined,
                    value: formatClock(elapsedSeconds),
                    label: 'duration',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
