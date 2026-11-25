import '../entities/fitness_data.dart';

abstract interface class FitnessRepository {
  /// Loads the home feed and gym details.
  ///
  /// Throws a [Failure] (see `domain/failures.dart`) when the data
  /// cannot be loaded.
  Future<FitnessData> getFitnessData();
}
