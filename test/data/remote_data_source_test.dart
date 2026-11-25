import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:fitness_app_lab3_android/data/datasources/fitness_remote_data_source.dart';
import 'package:fitness_app_lab3_android/data/exceptions.dart';
import 'package:fitness_app_lab3_android/data/repositories/fitness_repository_impl.dart';
import 'package:fitness_app_lab3_android/domain/failures.dart';

import '../fixtures/fixtures.dart';

FitnessRemoteDataSourceImpl _dataSource(MockClientHandler handler) =>
    FitnessRemoteDataSourceImpl(client: MockClient(handler));

Future<http.Response> _apiHandler(http.Request request) async {
  final path = request.url.path;
  if (path.endsWith('/feed')) {
    return http.Response(fixtureString('feed.json'), 200);
  }
  if (path.endsWith('/feed/details')) {
    return http.Response(fixtureString('details.json'), 200);
  }
  return http.Response('Not found', 404);
}

void main() {
  group('FitnessRemoteDataSourceImpl', () {
    test('calls the correct endpoints and parses JSON', () async {
      final requested = <String>[];
      final dataSource = _dataSource((request) {
        requested.add(request.url.toString());
        return _apiHandler(request);
      });

      final feed = await dataSource.fetchFeed();
      final details = await dataSource.fetchGymDetails();

      expect(requested, [
        'https://test-api-jlbn.onrender.com/lab2026/v3/feed',
        'https://test-api-jlbn.onrender.com/lab2026/v3/feed/details',
      ]);
      expect(feed.workouts, hasLength(3));
      expect(details.gym.id, 'gym001');
    });

    test('throws ServerException on non-2xx status', () {
      final dataSource =
          _dataSource((_) async => http.Response('boom', 500));

      expect(
        dataSource.fetchFeed(),
        throwsA(isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 500)),
      );
    });

    test('throws ParsingException on invalid JSON', () {
      final dataSource =
          _dataSource((_) async => http.Response('<html>', 200));

      expect(dataSource.fetchFeed(), throwsA(isA<ParsingException>()));
    });

    test('throws ParsingException when JSON structure is wrong', () {
      final dataSource =
          _dataSource((_) async => http.Response('{"header": 1}', 200));

      expect(dataSource.fetchFeed(), throwsA(isA<ParsingException>()));
    });

    test('throws NetworkException when the connection fails', () {
      final dataSource = _dataSource(
        (_) async => throw http.ClientException('no internet'),
      );

      expect(dataSource.fetchFeed(), throwsA(isA<NetworkException>()));
    });
  });

  group('FitnessRepositoryImpl', () {
    test('combines both endpoints into FitnessData', () async {
      final repository = FitnessRepositoryImpl(
        remoteDataSource: _dataSource(_apiHandler),
      );

      final data = await repository.getFitnessData();

      expect(data.header.greeting, 'Good Morning');
      expect(data.workouts, hasLength(3));
      expect(data.gym.name, 'Mid City Gym Training');
      expect(data.gymActions.reserve.label, 'Reserve');
    });

    test('maps data exceptions to domain failures', () {
      final repository = FitnessRepositoryImpl(
        remoteDataSource:
            _dataSource((_) async => http.Response('boom', 503)),
      );

      expect(repository.getFitnessData(), throwsA(isA<ServerFailure>()));
    });

    test('maps network errors to NetworkFailure', () {
      final repository = FitnessRepositoryImpl(
        remoteDataSource: _dataSource(
          (_) async => throw http.ClientException('offline'),
        ),
      );

      expect(repository.getFitnessData(), throwsA(isA<NetworkFailure>()));
    });
  });
}
