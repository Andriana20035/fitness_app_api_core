import '../entities/fitness_data.dart';
import '../repositories/fitness_repository.dart';

class GetFitnessData {
  const GetFitnessData(this._repository);

  final FitnessRepository _repository;

  Future<FitnessData> call() => _repository.getFitnessData();
}
