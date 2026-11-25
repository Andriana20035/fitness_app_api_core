import '../entities/activity.dart';

abstract interface class ActivityRepository {
  /// Completed sessions, newest first.
  Future<List<CompletedWorkout>> getHistory();

  Future<void> addCompletedWorkout(CompletedWorkout workout);
}
