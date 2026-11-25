import '../../domain/entities/fitness_data.dart';
import 'featured_plan_model.dart';
import 'workout_program_model.dart';

class HeaderDataModel extends HeaderData {
  const HeaderDataModel({
    required super.date,
    required super.greeting,
    required super.hasUnread,
    required super.notificationIconUrl,
  });

  factory HeaderDataModel.fromJson(Map<String, dynamic> json) {
    final notification = json['notification'] as Map<String, dynamic>;
    return HeaderDataModel(
      date: json['date'] as String,
      greeting: json['greeting'] as String,
      hasUnread: notification['hasUnread'] as bool,
      notificationIconUrl: notification['iconUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'greeting': greeting,
        'notification': {
          'hasUnread': hasUnread,
          'iconUrl': notificationIconUrl,
        },
      };
}

class ChallengeDataModel extends ChallengeData {
  const ChallengeDataModel({
    required super.title,
    required super.activity,
    required super.completed,
    required super.total,
    required super.progress,
    required super.iconUrl,
  });

  factory ChallengeDataModel.fromJson(Map<String, dynamic> json) =>
      ChallengeDataModel(
        title: json['title'] as String,
        activity: json['activity'] as String,
        completed: json['completed'] as int,
        total: json['total'] as int,
        progress: (json['progress'] as num).toDouble(),
        iconUrl: json['iconUrl'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'activity': activity,
        'completed': completed,
        'total': total,
        'progress': progress,
        'iconUrl': iconUrl,
      };
}

class WorkoutFilterModel extends WorkoutFilter {
  const WorkoutFilterModel({
    required super.id,
    required super.name,
    required super.selected,
  });

  factory WorkoutFilterModel.fromJson(Map<String, dynamic> json) =>
      WorkoutFilterModel(
        id: json['id'] as String,
        name: json['name'] as String,
        selected: json['selected'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'selected': selected,
      };
}

/// Response of `GET /lab2026/v3/feed`.
class FeedResponseModel {
  final HeaderDataModel header;
  final ChallengeDataModel todaysChallenge;
  final List<FeaturedPlanModel> featuredPlans;
  final List<WorkoutFilterModel> filters;
  final Map<String, String> filterIconUrls;
  final List<WorkoutProgramModel> workouts;

  const FeedResponseModel({
    required this.header,
    required this.todaysChallenge,
    required this.featuredPlans,
    required this.filters,
    required this.filterIconUrls,
    required this.workouts,
  });

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) {
    final programs = json['workoutPrograms'] as Map<String, dynamic>;

    return FeedResponseModel(
      header: HeaderDataModel.fromJson(json['header'] as Map<String, dynamic>),
      todaysChallenge: ChallengeDataModel.fromJson(
        json['todaysChallenge'] as Map<String, dynamic>,
      ),
      featuredPlans: (json['featuredPlans'] as List<dynamic>)
          .map((e) => FeaturedPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      filters: (programs['filters'] as List<dynamic>)
          .map((e) => WorkoutFilterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      filterIconUrls: (programs['filterIconUrls'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String)),
      workouts: (programs['items'] as List<dynamic>)
          .map((e) => WorkoutProgramModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'todaysChallenge': todaysChallenge.toJson(),
        'featuredPlans': featuredPlans.map((e) => e.toJson()).toList(),
        'workoutPrograms': {
          'filters': filters.map((e) => e.toJson()).toList(),
          'filterIconUrls': filterIconUrls,
          'items': workouts.map((e) => e.toJson()).toList(),
        },
      };
}
