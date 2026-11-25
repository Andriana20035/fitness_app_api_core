import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completed_workout_model.dart';

/// Local persistence (on-device) for user data that the API does not store:
/// favorite workouts and completed workout history.
class FitnessLocalDataSource {
  FitnessLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'favorite_workout_ids';
  static const _historyKey = 'completed_workouts';
  static const _maxHistory = 100;

  Set<String> getFavoriteIds() =>
      (_prefs.getStringList(_favoritesKey) ?? const <String>[]).toSet();

  Future<void> saveFavoriteIds(Set<String> ids) =>
      _prefs.setStringList(_favoritesKey, ids.toList());

  List<CompletedWorkoutModel> getHistory() {
    final raw = _prefs.getString(_historyKey);
    if (raw == null) return [];

    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => CompletedWorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return [];
    } on TypeError {
      // Corrupted / outdated data: start with an empty history.
      return [];
    }
  }

  Future<void> saveHistory(List<CompletedWorkoutModel> history) {
    final trimmed = history.take(_maxHistory).map((e) => e.toJson()).toList();
    return _prefs.setString(_historyKey, jsonEncode(trimmed));
  }
}
