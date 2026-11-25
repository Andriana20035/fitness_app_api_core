import '../../domain/entities/workout_program.dart';

class WorkoutProgramModel extends WorkoutProgram {
  const WorkoutProgramModel({
    required super.id,
    required super.title,
    required super.category,
    required super.calories,
    required super.durationMinutes,
    required super.isPro,
    required super.imageUrl,
    required super.caloriesIconUrl,
    required super.durationIconUrl,
    super.proIconUrl,
  });

  factory WorkoutProgramModel.fromJson(Map<String, dynamic> json) {
    final icons = json['icons'] as Map<String, dynamic>;
    final title = json['title'] as String;

    return WorkoutProgramModel(
      id: json['id'] as String,
      title: title,
      // The API does not send a category, so it is inferred from the title
      // to make the filter chips work.
      category: json['category'] as String? ?? _inferCategory(title),
      calories: json['calories'] as int,
      durationMinutes: json['durationMinutes'] as int,
      isPro: json['isPro'] as bool,
      imageUrl: json['imageUrl'] as String,
      caloriesIconUrl: icons['caloriesIconUrl'] as String,
      durationIconUrl: icons['durationIconUrl'] as String,
      proIconUrl: icons['proIconUrl'] as String?,
    );
  }

  factory WorkoutProgramModel.fromEntity(WorkoutProgram entity) =>
      WorkoutProgramModel(
        id: entity.id,
        title: entity.title,
        category: entity.category,
        calories: entity.calories,
        durationMinutes: entity.durationMinutes,
        isPro: entity.isPro,
        imageUrl: entity.imageUrl,
        caloriesIconUrl: entity.caloriesIconUrl,
        durationIconUrl: entity.durationIconUrl,
        proIconUrl: entity.proIconUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'calories': calories,
        'durationMinutes': durationMinutes,
        'isPro': isPro,
        'imageUrl': imageUrl,
        'icons': {
          'caloriesIconUrl': caloriesIconUrl,
          'durationIconUrl': durationIconUrl,
          if (proIconUrl != null) 'proIconUrl': proIconUrl,
        },
      };

  static const _knownCategories = ['yoga', 'cardio', 'pilates', 'boxing'];

  static String _inferCategory(String title) {
    final lower = title.toLowerCase();
    for (final category in _knownCategories) {
      if (lower.contains(category)) return category;
    }
    return 'other';
  }
}
