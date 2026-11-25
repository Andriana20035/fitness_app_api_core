class WorkoutProgram {
  final String id;
  final String title;
  final String category;
  final int calories;
  final int durationMinutes;
  final bool isPro;
  final String imageUrl;
  final String caloriesIconUrl;
  final String durationIconUrl;
  final String? proIconUrl;

  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.category,
    required this.calories,
    required this.durationMinutes,
    required this.isPro,
    required this.imageUrl,
    required this.caloriesIconUrl,
    required this.durationIconUrl,
    this.proIconUrl,
  });
}
