import 'featured_plan.dart';
import 'gym.dart';
import 'workout_program.dart';

class HeaderData {
  final String date;
  final String greeting;
  final bool hasUnread;
  final String notificationIconUrl;

  const HeaderData({
    required this.date,
    required this.greeting,
    required this.hasUnread,
    required this.notificationIconUrl,
  });
}

class ChallengeData {
  final String title;
  final String activity;
  final int completed;
  final int total;
  final double progress;
  final String iconUrl;

  const ChallengeData({
    required this.title,
    required this.activity,
    required this.completed,
    required this.total,
    required this.progress,
    required this.iconUrl,
  });
}

class WorkoutFilter {
  final String id;
  final String name;
  final bool selected;

  const WorkoutFilter({
    required this.id,
    required this.name,
    required this.selected,
  });

  WorkoutFilter copyWith({String? id, String? name, bool? selected}) =>
      WorkoutFilter(
        id: id ?? this.id,
        name: name ?? this.name,
        selected: selected ?? this.selected,
      );
}

/// Aggregated data shown by the app: the home feed plus the gym details.
class FitnessData {
  final HeaderData header;
  final ChallengeData challenge;
  final List<FeaturedPlan> featuredPlans;
  final List<WorkoutFilter> filters;
  final Map<String, String> filterIconUrls;
  final List<WorkoutProgram> workouts;
  final Gym gym;
  final GymActions gymActions;

  const FitnessData({
    required this.header,
    required this.challenge,
    required this.featuredPlans,
    required this.filters,
    required this.filterIconUrls,
    required this.workouts,
    required this.gym,
    required this.gymActions,
  });

  FitnessData copyWith({
    HeaderData? header,
    ChallengeData? challenge,
    List<FeaturedPlan>? featuredPlans,
    List<WorkoutFilter>? filters,
    Map<String, String>? filterIconUrls,
    List<WorkoutProgram>? workouts,
    Gym? gym,
    GymActions? gymActions,
  }) =>
      FitnessData(
        header: header ?? this.header,
        challenge: challenge ?? this.challenge,
        featuredPlans: featuredPlans ?? this.featuredPlans,
        filters: filters ?? this.filters,
        filterIconUrls: filterIconUrls ?? this.filterIconUrls,
        workouts: workouts ?? this.workouts,
        gym: gym ?? this.gym,
        gymActions: gymActions ?? this.gymActions,
      );
}
