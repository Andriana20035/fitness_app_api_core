import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/fitness_local_data_source.dart';
import '../models/completed_workout_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl({required this.localDataSource});

  final FitnessLocalDataSource localDataSource;

  @override
  Future<List<CompletedWorkout>> getHistory() async =>
      localDataSource.getHistory();

  @override
  Future<void> addCompletedWorkout(CompletedWorkout workout) {
    final history = [
      CompletedWorkoutModel.fromEntity(workout),
      ...localDataSource.getHistory(),
    ];
    return localDataSource.saveHistory(history);
  }
}
