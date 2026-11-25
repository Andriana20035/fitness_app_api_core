import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/workout_sort_option.dart';
import '../../domain/entities/fitness_data.dart';
import '../../domain/entities/workout_program.dart';
import '../../domain/failures.dart';
import '../../domain/usecases/get_fitness_data.dart';
import 'fitness_state.dart';

class FitnessCubit extends Cubit<FitnessState> {
  final GetFitnessData getFitnessData;

  FitnessData? _originalData;

  String _selectedFilter = 'all';
  String _searchQuery = '';
  WorkoutSortOption _sortOption = WorkoutSortOption.none;

  FitnessCubit({
    required this.getFitnessData,
  }) : super(const FitnessInitial());

  /// Full load: shows the loading indicator and resets filters.
  Future<void> loadData() async {
    emit(const FitnessLoading());
    _resetInternalOptions();
    await _fetch();
  }

  /// Pull-to-refresh: reloads without the full-screen loader and keeps the
  /// current filter / search / sort.
  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    try {
      final data = await getFitnessData();
      if (isClosed) return;

      _originalData = data;

      if (data.workouts.isEmpty) {
        emit(FitnessEmpty(data, message: 'No workouts are available.'));
        return;
      }

      _applyWorkoutOperations();
    } on Failure catch (failure) {
      if (!isClosed) emit(FitnessError(failure.message));
    } catch (_) {
      if (!isClosed) {
        emit(const FitnessError(
          'A apărut o eroare neașteptată. Încearcă din nou.',
        ));
      }
    }
  }

  void selectFilter(String filterId) {
    _selectedFilter = filterId.toLowerCase();
    _applyWorkoutOperations();
  }

  void searchWorkouts(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyWorkoutOperations();
  }

  void sortWorkouts(WorkoutSortOption option) {
    _sortOption = option;
    _applyWorkoutOperations();
  }

  void resetWorkoutOptions() {
    _resetInternalOptions();
    _applyWorkoutOperations();
  }

  void _resetInternalOptions() {
    _selectedFilter = 'all';
    _searchQuery = '';
    _sortOption = WorkoutSortOption.none;
  }

  void _applyWorkoutOperations() {
    final originalData = _originalData;
    if (originalData == null) return;

    var workouts = List<WorkoutProgram>.from(originalData.workouts);
    workouts = _applyFilter(workouts);
    workouts = _applySearch(workouts);
    _applySort(workouts);

    final updatedFilters = originalData.filters
        .map((filter) => filter.copyWith(
              selected: filter.id.toLowerCase() == _selectedFilter,
            ))
        .toList();

    final updatedData = originalData.copyWith(
      workouts: workouts,
      filters: updatedFilters,
    );

    if (workouts.isEmpty) {
      emit(FitnessEmpty(updatedData, message: 'No workouts found'));
      return;
    }

    emit(FitnessSuccess(updatedData));
  }

  List<WorkoutProgram> _applyFilter(List<WorkoutProgram> workouts) {
    if (_selectedFilter == 'all') return workouts;

    return workouts
        .where((w) => w.category.toLowerCase() == _selectedFilter)
        .toList();
  }

  List<WorkoutProgram> _applySearch(List<WorkoutProgram> workouts) {
    if (_searchQuery.isEmpty) return workouts;

    return workouts.where((w) {
      return w.title.toLowerCase().contains(_searchQuery) ||
          w.category.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _applySort(List<WorkoutProgram> workouts) {
    switch (_sortOption) {
      case WorkoutSortOption.none:
        break;
      case WorkoutSortOption.nameAsc:
        workouts.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case WorkoutSortOption.caloriesAsc:
        workouts.sort((a, b) => a.calories.compareTo(b.calories));
      case WorkoutSortOption.caloriesDesc:
        workouts.sort((a, b) => b.calories.compareTo(a.calories));
      case WorkoutSortOption.durationAsc:
        workouts.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
      case WorkoutSortOption.durationDesc:
        workouts.sort((a, b) => b.durationMinutes.compareTo(a.durationMinutes));
    }
  }
}
