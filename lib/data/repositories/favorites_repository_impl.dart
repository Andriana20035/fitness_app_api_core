import '../../domain/repositories/favorites_repository.dart';
import '../datasources/fitness_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl({required this.localDataSource});

  final FitnessLocalDataSource localDataSource;

  @override
  Future<Set<String>> getFavoriteIds() async =>
      localDataSource.getFavoriteIds();

  @override
  Future<void> saveFavoriteIds(Set<String> ids) =>
      localDataSource.saveFavoriteIds(ids);
}
