class AnswerOption {
  const AnswerOption({
    required this.id,
    required this.questionId,
    required this.markdownText,
    required this.isCorrect,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String questionId;
  final String markdownText;
  final bool isCorrect;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
