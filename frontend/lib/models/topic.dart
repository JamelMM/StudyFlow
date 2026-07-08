class Topic {
  const Topic({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.createdAt,
    this.nextReviewDate,
    this.lastReviewedAt,
    this.currentScore,
  });

  final int id;
  final int subjectId;
  final String name;
  final DateTime createdAt;
  final DateTime? nextReviewDate;
  final DateTime? lastReviewedAt;
  final int? currentScore;
}
