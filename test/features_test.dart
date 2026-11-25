import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app_lab3_android/core/utils/ticker.dart';
import 'package:fitness_app_lab3_android/core/utils/time_format.dart';
import 'package:fitness_app_lab3_android/data/datasources/fitness_local_data_source.dart';
import 'package:fitness_app_lab3_android/data/models/completed_workout_model.dart';
import 'package:fitness_app_lab3_android/data/repositories/activity_repository_impl.dart';
import 'package:fitness_app_lab3_android/data/repositories/favorites_repository_impl.dart';
import 'package:fitness_app_lab3_android/domain/entities/activity.dart';
import 'package:fitness_app_lab3_android/domain/usecases/favorite_workouts.dart';
import 'package:fitness_app_lab3_android/domain/usecases/workout_activity.dart';
import 'package:fitness_app_lab3_android/presentation/cubit/workout_timer_cubit.dart';

import 'helpers/fakes.dart';

/// Ticker controlled manually by the test.
class _FakeTicker implements Ticker {
  final controller = StreamController<int>();

  @override
  Stream<int> tick({required int ticks}) => controller.stream;
}

CompletedWorkout _session(DateTime at, {int kcal = 100, int seconds = 600}) =>
    CompletedWorkout(
      workoutId: 'wp001',
      title: 'Yoga',
      caloriesBurned: kcal,
      durationSeconds: seconds,
      completedAt: at,
    );

void main() {
  group('Favorites', () {
    test('ToggleFavoriteWorkout adds then removes an id', () async {
      final repo = InMemoryFavoritesRepository();
      final toggle = ToggleFavoriteWorkout(repo);

      expect(await toggle('wp001'), {'wp001'});
      expect(await toggle('wp002'), {'wp001', 'wp002'});
      expect(await toggle('wp001'), {'wp002'});
      expect(repo.ids, {'wp002'});
    });

    test('favorites are persisted in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final local = FitnessLocalDataSource(
        await SharedPreferences.getInstance(),
      );
      final toggle =
          ToggleFavoriteWorkout(FavoritesRepositoryImpl(localDataSource: local));

      await toggle('wp003');

      final reloaded = FitnessLocalDataSource(
        await SharedPreferences.getInstance(),
      );
      expect(reloaded.getFavoriteIds(), {'wp003'});
    });
  });

  group('Activity', () {
    test('CompletedWorkoutModel JSON round-trip', () {
      final model = CompletedWorkoutModel.fromEntity(
        _session(DateTime.utc(2026, 5, 20, 8, 30)),
      );
      final decoded = CompletedWorkoutModel.fromJson(model.toJson());

      expect(decoded.toJson(), model.toJson());
      expect(decoded.completedAt, DateTime.utc(2026, 5, 20, 8, 30));
    });

    test('GetTodayActivity sums only today sessions', () async {
      final repo = InMemoryActivityRepository()
        ..history.addAll([
          _session(DateTime(2026, 5, 20, 9), kcal: 120, seconds: 900),
          _session(DateTime(2026, 5, 20, 18), kcal: 80, seconds: 300),
          _session(DateTime(2026, 5, 19, 18), kcal: 500, seconds: 3600),
        ]);
      final getToday =
          GetTodayActivity(repo, clock: () => DateTime(2026, 5, 20, 21));

      final summary = await getToday();

      expect(summary.workoutsCount, 2);
      expect(summary.caloriesBurned, 200);
      expect(summary.activeMinutes, 20);
    });

    test('history is stored as JSON in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ActivityRepositoryImpl(
        localDataSource: FitnessLocalDataSource(prefs),
      );

      await repo.addCompletedWorkout(_session(DateTime.utc(2026, 5, 20)));
      await repo.addCompletedWorkout(
        _session(DateTime.utc(2026, 5, 21), kcal: 42),
      );

      final history = await repo.getHistory();
      expect(history.map((w) => w.caloriesBurned), [42, 100]);
      expect(prefs.getString('completed_workouts'), contains('"workoutId"'));
    });

    test('corrupted history falls back to empty list', () async {
      SharedPreferences.setMockInitialValues(
        {'completed_workouts': 'not json'},
      );
      final local = FitnessLocalDataSource(
        await SharedPreferences.getInstance(),
      );

      expect(local.getHistory(), isEmpty);
    });
  });

  group('WorkoutTimerCubit', () {
    test('start, tick, pause, resume and finish', () async {
      final ticker = _FakeTicker();
      final cubit = WorkoutTimerCubit(durationSeconds: 3, ticker: ticker);

      expect(cubit.state.status, TimerStatus.initial);

      cubit.start();
      expect(cubit.state.status, TimerStatus.running);

      ticker.controller.add(2);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.remainingSeconds, 2);
      expect(cubit.state.elapsedSeconds, 1);

      cubit.pause();
      expect(cubit.state.status, TimerStatus.paused);
      cubit.resume();
      expect(cubit.state.status, TimerStatus.running);

      ticker.controller
        ..add(1)
        ..add(0);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.status, TimerStatus.finished);
      expect(cubit.state.progress, 1.0);

      await cubit.close();
    });

    test('finish() ends early and keeps elapsed time', () async {
      final ticker = _FakeTicker();
      final cubit = WorkoutTimerCubit(durationSeconds: 10, ticker: ticker)
        ..start();

      ticker.controller.add(9);
      await Future<void>.delayed(Duration.zero);
      cubit.finish();

      expect(cubit.state.status, TimerStatus.finished);
      expect(cubit.state.elapsedSeconds, 1);
      await cubit.close();
    });
  });

  test('formatClock', () {
    expect(formatClock(0), '00:00');
    expect(formatClock(75), '01:15');
    expect(formatClock(7200), '2:00:00');
  });
}
