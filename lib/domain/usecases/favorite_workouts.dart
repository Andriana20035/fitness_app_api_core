import '../repositories/favorites_repository.dart';

class GetFavoriteWorkoutIds {
  const GetFavoriteWorkoutIds(this._repository);

  final FavoritesRepository _repository;

  Future<Set<String>> call() => _repository.getFavoriteIds();
}

/// Adds the workout to favorites, or removes it if it is already there.
/// Returns the updated set of favorite ids.
class ToggleFavoriteWorkout {
  const ToggleFavoriteWorkout(this._repository);

  final FavoritesRepository _repository;

  Future<Set<String>> call(String workoutId) async {
    final ids = {...await _repository.getFavoriteIds()};
    if (!ids.remove(workoutId)) ids.add(workoutId);
    await _repository.saveFavoriteIds(ids);
    return ids;
  }
}
