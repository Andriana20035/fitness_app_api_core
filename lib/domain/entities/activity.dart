/// A workout session the user finished (fully or partially).
class CompletedWorkout {
  final String workoutId;
  final String title;
  final int caloriesBurned;
  final int durationSeconds;
  final DateTime completedAt;

  const CompletedWorkout({
    required this.workoutId,
    required this.title,
    required this.caloriesBurned,
    required this.durationSeconds,
    required this.completedAt,
  });
}

/// Aggregated activity for one day.
class ActivitySummary {
  final int workoutsCount;
  final int caloriesBurned;
  final int activeSeconds;

  const ActivitySummary({
    required this.workoutsCount,
    required this.caloriesBurned,
    required this.activeSeconds,
  });

  static const empty = ActivitySummary(
    workoutsCount: 0,
    caloriesBurned: 0,
    activeSeconds: 0,
  );

  int get activeMinutes => (activeSeconds / 60).round();
}
