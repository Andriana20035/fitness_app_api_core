import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/activity.dart';
import '../../domain/usecases/workout_activity.dart';

/// Holds today's activity summary shown on the Home screen.
class ActivityCubit extends Cubit<ActivitySummary> {
  ActivityCubit({
    required this.getTodayActivity,
    required this.saveCompletedWorkout,
  }) : super(ActivitySummary.empty);

  final GetTodayActivity getTodayActivity;
  final SaveCompletedWorkout saveCompletedWorkout;

  Future<void> load() async {
    try {
      final summary = await getTodayActivity();
      if (!isClosed) emit(summary);
    } catch (_) {
      // Keep the previous summary if local storage cannot be read.
    }
  }

  Future<void> recordWorkout(CompletedWorkout workout) async {
    try {
      await saveCompletedWorkout(workout);
    } catch (_) {
      // Saving history must never block the session summary.
    }
    await load();
  }
}
