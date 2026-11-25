import 'package:fitness_app_lab3_android/domain/entities/activity.dart';
import 'package:fitness_app_lab3_android/domain/repositories/activity_repository.dart';
import 'package:fitness_app_lab3_android/domain/repositories/favorites_repository.dart';
import 'package:fitness_app_lab3_android/domain/usecases/favorite_workouts.dart';
import 'package:fitness_app_lab3_android/domain/usecases/get_fitness_data.dart';
import 'package:fitness_app_lab3_android/domain/usecases/workout_activity.dart';
import 'package:fitness_app_lab3_android/main.dart';

class InMemoryFavoritesRepository implements FavoritesRepository {
  Set<String> ids = {};

  @override
  Future<Set<String>> getFavoriteIds() async => {...ids};

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async => this.ids = {...ids};
}

class InMemoryActivityRepository implements ActivityRepository {
  final List<CompletedWorkout> history = [];

  @override
  Future<List<CompletedWorkout>> getHistory() async => List.of(history);

  @override
  Future<void> addCompletedWorkout(CompletedWorkout workout) async =>
      history.insert(0, workout);
}

FitnessApp buildTestApp(
  GetFitnessData getFitnessData, {
  FavoritesRepository? favorites,
  ActivityRepository? activity,
}) {
  final favoritesRepo = favorites ?? InMemoryFavoritesRepository();
  final activityRepo = activity ?? InMemoryActivityRepository();
  return FitnessApp(
    getFitnessData: getFitnessData,
    getFavoriteWorkoutIds: GetFavoriteWorkoutIds(favoritesRepo),
    toggleFavoriteWorkout: ToggleFavoriteWorkout(favoritesRepo),
    getTodayActivity: GetTodayActivity(activityRepo),
    saveCompletedWorkout: SaveCompletedWorkout(activityRepo),
  );
}
