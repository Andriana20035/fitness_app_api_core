enum WorkoutSortOption {
  none,
  nameAsc,
  caloriesAsc,
  caloriesDesc,
  durationAsc,
  durationDesc,
}

extension WorkoutSortOptionLabel on WorkoutSortOption {
  String get label {
    switch (this) {
      case WorkoutSortOption.none:
        return 'Default';

      case WorkoutSortOption.nameAsc:
        return 'Name A-Z';

      case WorkoutSortOption.caloriesAsc:
        return 'Calories: Low to High';

      case WorkoutSortOption.caloriesDesc:
        return 'Calories: High to Low';

      case WorkoutSortOption.durationAsc:
        return 'Duration: Shortest';

      case WorkoutSortOption.durationDesc:
        return 'Duration: Longest';
    }
  }
}