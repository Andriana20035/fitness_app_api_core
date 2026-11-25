import '../../domain/entities/activity.dart';

class CompletedWorkoutModel extends CompletedWorkout {
  const CompletedWorkoutModel({
    required super.workoutId,
    required super.title,
    required super.caloriesBurned,
    required super.durationSeconds,
    required super.completedAt,
  });

  factory CompletedWorkoutModel.fromJson(Map<String, dynamic> json) =>
      CompletedWorkoutModel(
        workoutId: json['workoutId'] as String,
        title: json['title'] as String,
        caloriesBurned: json['caloriesBurned'] as int,
        durationSeconds: json['durationSeconds'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  factory CompletedWorkoutModel.fromEntity(CompletedWorkout entity) =>
      CompletedWorkoutModel(
        workoutId: entity.workoutId,
        title: entity.title,
        caloriesBurned: entity.caloriesBurned,
        durationSeconds: entity.durationSeconds,
        completedAt: entity.completedAt,
      );

  Map<String, dynamic> toJson() => {
        'workoutId': workoutId,
        'title': title,
        'caloriesBurned': caloriesBurned,
        'durationSeconds': durationSeconds,
        'completedAt': completedAt.toUtc().toIso8601String(),
      };
}
