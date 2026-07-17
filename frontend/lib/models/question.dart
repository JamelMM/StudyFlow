class Question {
  const Question({
    required this.id,
    required this.quizId,
    required this.markdownText,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String quizId;
  final String markdownText;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
