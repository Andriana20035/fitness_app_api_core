import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/favorite_workouts.dart';

/// State = set of favorite workout ids.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit({
    required this.getFavoriteWorkoutIds,
    required this.toggleFavoriteWorkout,
  }) : super(const <String>{});

  final GetFavoriteWorkoutIds getFavoriteWorkoutIds;
  final ToggleFavoriteWorkout toggleFavoriteWorkout;

  Future<void> load() async {
    try {
      final ids = await getFavoriteWorkoutIds();
      if (!isClosed) emit(ids);
    } catch (_) {
      // Favorites are optional; keep the empty set if storage fails.
    }
  }

  Future<void> toggle(String workoutId) async {
    final previous = state;
    // Optimistic update so the heart reacts instantly.
    final optimistic = {...previous};
    if (!optimistic.remove(workoutId)) optimistic.add(workoutId);
    emit(optimistic);

    try {
      final saved = await toggleFavoriteWorkout(workoutId);
      if (!isClosed) emit(saved);
    } catch (_) {
      if (!isClosed) emit(previous);
    }
  }
}
