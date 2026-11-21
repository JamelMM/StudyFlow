class PracticeExamAnswerOption {
  const PracticeExamAnswerOption({
    required this.id,
    required this.practiceExamQuestionId,
    required this.isCorrect,
    required this.markdownText,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String practiceExamQuestionId;
  final bool isCorrect;
  final String markdownText;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
