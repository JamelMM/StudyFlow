class PracticeExam {
  const PracticeExam({
    required this.id,
    required this.examSectionId,
    required this.name,
    required this.passingPercentage,
    required this.createdAt,
    this.durationMinutes,
    this.updatedAt,
  });

  final String id;
  final String examSectionId;
  final String name;
  final int passingPercentage;
  final DateTime createdAt;
  final int? durationMinutes;
  final DateTime? updatedAt;
}
