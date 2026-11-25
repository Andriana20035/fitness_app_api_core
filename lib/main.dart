import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'data/datasources/fitness_local_data_source.dart';
import 'data/datasources/fitness_remote_data_source.dart';
import 'data/repositories/activity_repository_impl.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'data/repositories/fitness_repository_impl.dart';
import 'domain/usecases/favorite_workouts.dart';
import 'domain/usecases/get_fitness_data.dart';
import 'domain/usecases/workout_activity.dart';
import 'presentation/cubit/activity_cubit.dart';
import 'presentation/cubit/favorites_cubit.dart';
import 'presentation/cubit/fitness_cubit.dart';
import 'presentation/screens/home_screen.dart';

/// Composition root: wires Data -> Domain -> Presentation.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Data sources
  final remoteDataSource = FitnessRemoteDataSourceImpl();
  final localDataSource =
      FitnessLocalDataSource(await SharedPreferences.getInstance());

  // Repositories
  final fitnessRepository =
      FitnessRepositoryImpl(remoteDataSource: remoteDataSource);
  final favoritesRepository =
      FavoritesRepositoryImpl(localDataSource: localDataSource);
  final activityRepository =
      ActivityRepositoryImpl(localDataSource: localDataSource);

  runApp(
    FitnessApp(
      getFitnessData: GetFitnessData(fitnessRepository),
      getFavoriteWorkoutIds: GetFavoriteWorkoutIds(favoritesRepository),
      toggleFavoriteWorkout: ToggleFavoriteWorkout(favoritesRepository),
      getTodayActivity: GetTodayActivity(activityRepository),
      saveCompletedWorkout: SaveCompletedWorkout(activityRepository),
    ),
  );
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({
    super.key,
    required this.getFitnessData,
    required this.getFavoriteWorkoutIds,
    required this.toggleFavoriteWorkout,
    required this.getTodayActivity,
    required this.saveCompletedWorkout,
  });

  final GetFitnessData getFitnessData;
  final GetFavoriteWorkoutIds getFavoriteWorkoutIds;
  final ToggleFavoriteWorkout toggleFavoriteWorkout;
  final GetTodayActivity getTodayActivity;
  final SaveCompletedWorkout saveCompletedWorkout;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              FitnessCubit(getFitnessData: getFitnessData)..loadData(),
        ),
        BlocProvider(
          create: (_) => FavoritesCubit(
            getFavoriteWorkoutIds: getFavoriteWorkoutIds,
            toggleFavoriteWorkout: toggleFavoriteWorkout,
          )..load(),
        ),
        BlocProvider(
          create: (_) => ActivityCubit(
            getTodayActivity: getTodayActivity,
            saveCompletedWorkout: saveCompletedWorkout,
          )..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'PlusJakartaSans',
          scaffoldBackgroundColor: AppColors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
