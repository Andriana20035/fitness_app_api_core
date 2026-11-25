import '../../domain/entities/featured_plan.dart';

class FeaturedPlanModel extends FeaturedPlan {
  const FeaturedPlanModel({
    required super.id,
    required super.title,
    required super.duration,
    required super.frequency,
    required super.actionLabel,
    required super.imageUrl,
    required super.durationIconUrl,
    required super.frequencyIconUrl,
  });

  factory FeaturedPlanModel.fromJson(Map<String, dynamic> json) {
    final metaIcons = json['metaIcons'] as Map<String, dynamic>;

    return FeaturedPlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      frequency: json['frequency'] as String,
      actionLabel: json['actionLabel'] as String,
      imageUrl: json['imageUrl'] as String,
      durationIconUrl: metaIcons['durationIconUrl'] as String,
      frequencyIconUrl: metaIcons['frequencyIconUrl'] as String,
    );
  }

  factory FeaturedPlanModel.fromEntity(FeaturedPlan entity) =>
      FeaturedPlanModel(
        id: entity.id,
        title: entity.title,
        duration: entity.duration,
        frequency: entity.frequency,
        actionLabel: entity.actionLabel,
        imageUrl: entity.imageUrl,
        durationIconUrl: entity.durationIconUrl,
        frequencyIconUrl: entity.frequencyIconUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'frequency': frequency,
        'actionLabel': actionLabel,
        'imageUrl': imageUrl,
        'metaIcons': {
          'durationIconUrl': durationIconUrl,
          'frequencyIconUrl': frequencyIconUrl,
        },
      };
}
