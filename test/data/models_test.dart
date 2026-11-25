import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app_lab3_android/data/models/feed_response_model.dart';
import 'package:fitness_app_lab3_android/data/models/gym_details_model.dart';

import '../fixtures/fixtures.dart';

void main() {
  group('FeedResponseModel', () {
    test('fromJson parses the /feed response', () {
      final model = FeedResponseModel.fromJson(fixtureJson('feed.json'));

      expect(model.header.greeting, 'Good Morning');
      expect(model.header.hasUnread, isTrue);
      expect(model.todaysChallenge.progress, 0.75);
      expect(model.featuredPlans, hasLength(2));
      expect(model.featuredPlans.first.title, 'Massive Upper Body');
      expect(model.filters.map((f) => f.id),
          ['all', 'pilates', 'cardio', 'boxing', 'yoga']);
      expect(model.workouts, hasLength(3));
      expect(model.workouts[1].isPro, isTrue);
      expect(model.workouts[1].proIconUrl, isNotNull);
    });

    test('infers workout category from the title', () {
      final model = FeedResponseModel.fromJson(fixtureJson('feed.json'));

      expect(model.workouts.map((w) => w.category),
          ['yoga', 'other', 'cardio']);
    });

    test('toJson -> fromJson round-trip keeps the data', () {
      final original = FeedResponseModel.fromJson(fixtureJson('feed.json'));
      final encoded = jsonEncode(original.toJson());
      final decoded = FeedResponseModel.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );

      expect(decoded.toJson(), original.toJson());
    });
  });

  group('GymDetailsResponseModel', () {
    test('fromJson parses the /feed/details response', () {
      final model =
          GymDetailsResponseModel.fromJson(fixtureJson('details.json'));

      expect(model.gym.name, 'Mid City Gym Training');
      expect(model.gym.rating, 4.5);
      expect(model.gym.reviewCount, 1232);
      expect(model.gym.amenities.map((a) => a.name), ['Showers', 'Lockers']);
      expect(model.gym.pricing.formatted, r'$69.00 /week');
      expect(model.actions.reserve.label, 'Reserve');
      expect(model.actions.reserve.enabled, isTrue);
    });

    test('toJson reproduces the original API JSON', () {
      final json = fixtureJson('details.json');
      final model = GymDetailsResponseModel.fromJson(json);

      expect(model.toJson(), json);
    });
  });
}
