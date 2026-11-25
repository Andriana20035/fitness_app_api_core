import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app_lab3_android/data/models/feed_response_model.dart';
import 'package:fitness_app_lab3_android/data/models/gym_details_model.dart';
import 'package:fitness_app_lab3_android/domain/entities/fitness_data.dart';
import 'package:fitness_app_lab3_android/domain/failures.dart';
import 'package:fitness_app_lab3_android/domain/repositories/fitness_repository.dart';
import 'package:fitness_app_lab3_android/domain/usecases/get_fitness_data.dart';
import 'package:fitness_app_lab3_android/presentation/widgets/error_view.dart';
import 'package:fitness_app_lab3_android/presentation/widgets/favorite_button.dart';

import 'fixtures/fixtures.dart';
import 'helpers/fakes.dart';

class _FakeFitnessRepository implements FitnessRepository {
  _FakeFitnessRepository(this._load);

  final Future<FitnessData> Function() _load;
  int calls = 0;

  @override
  Future<FitnessData> getFitnessData() {
    calls++;
    return _load();
  }
}

FitnessData _fixtureData() {
  final feed = FeedResponseModel.fromJson(fixtureJson('feed.json'));
  final details = GymDetailsResponseModel.fromJson(fixtureJson('details.json'));
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
}

void main() {
  testWidgets('loads fitness data and shows home content', (tester) async {
    final data = _fixtureData();

    await tester.pumpWidget(
      buildTestApp(
        GetFitnessData(_FakeFitnessRepository(() async => data)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good Morning'), findsOneWidget);
    expect(find.text('Featured Plan'), findsOneWidget);
    expect(find.text('Workout Programs'), findsOneWidget);
    expect(find.text('Yoga'), findsNWidgets(2));
  });

  testWidgets('shows ErrorView and retries on failure', (tester) async {
    final data = _fixtureData();
    var shouldFail = true;
    final repository = _FakeFitnessRepository(() async {
      if (shouldFail) {
        throw const NetworkFailure('Nu există conexiune la internet.');
      }
      return data;
    });

    await tester.pumpWidget(buildTestApp(GetFitnessData(repository)));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Nu există conexiune la internet.'), findsOneWidget);

    shouldFail = false;
    await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.byType(ErrorView), findsNothing);
    expect(find.text('Good Morning'), findsOneWidget);
  });

  testWidgets('heart button saves a workout as favorite', (tester) async {
    final data = _fixtureData();
    final favorites = InMemoryFavoritesRepository();

    await tester.pumpWidget(
      buildTestApp(
        GetFitnessData(_FakeFitnessRepository(() async => data)),
        favorites: favorites,
      ),
    );
    await tester.pumpAndSettle();

    final heart = find.byType(FavoriteButton).first;
    await tester.ensureVisible(heart);
    await tester.pumpAndSettle();
    await tester.tap(heart);
    await tester.pumpAndSettle();

    expect(favorites.ids, {'wp001'});
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
