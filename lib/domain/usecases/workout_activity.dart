import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class SaveCompletedWorkout {
  const SaveCompletedWorkout(this._repository);

  final ActivityRepository _repository;

  Future<void> call(CompletedWorkout workout) =>
      _repository.addCompletedWorkout(workout);
}

/// Sums up the sessions completed today.
class GetTodayActivity {
  GetTodayActivity(this._repository, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final ActivityRepository _repository;
  final DateTime Function() _clock;

  Future<ActivitySummary> call() async {
    final now = _clock();
    final today = (await _repository.getHistory()).where((w) {
      final d = w.completedAt.toLocal();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    });

    return ActivitySummary(
      workoutsCount: today.length,
      caloriesBurned: today.fold(0, (sum, w) => sum + w.caloriesBurned),
      activeSeconds: today.fold(0, (sum, w) => sum + w.durationSeconds),
    );
  }
}
