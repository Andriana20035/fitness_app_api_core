import '../../domain/entities/fitness_data.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../datasources/fitness_remote_data_source.dart';
import '../exceptions.dart';
import '../models/feed_response_model.dart';
import '../models/gym_details_model.dart';

class FitnessRepositoryImpl implements FitnessRepository {
  const FitnessRepositoryImpl({required this.remoteDataSource});

  final FitnessRemoteDataSource remoteDataSource;

  @override
  Future<FitnessData> getFitnessData() async {
    try {
      final responses = await Future.wait<Object>([
        remoteDataSource.fetchFeed(),
        remoteDataSource.fetchGymDetails(),
      ]);
      final feed = responses[0] as FeedResponseModel;
      final details = responses[1] as GymDetailsResponseModel;

      return FitnessData(
        header: feed.header,
        challenge: feed.todaysChallenge,
        featuredPlans: feed.featuredPlans,
        filters: feed.filters,
        filterIconUrls: feed.filterIconUrls,
        workouts: feed.workouts,
        gym: details.gym,
        gymActions: details.actions,
      );
    } on DataException catch (e) {
      throw switch (e) {
        NetworkException() => NetworkFailure(e.message),
        ServerException() => ServerFailure(e.message),
        ParsingException() => ParsingFailure(e.message),
      };
    }
  }
}
