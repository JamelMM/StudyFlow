class PracticeExamQuestion {
  const PracticeExamQuestion({
    required this.id,
    required this.practiceExamId,
    required this.markdownText,
    required this.createdAt,
    this.explanationMarkdown,
    this.updatedAt,
  });

  final String id;
  final String practiceExamId;
  final String markdownText;
  final DateTime createdAt;
  final String? explanationMarkdown;
  final DateTime? updatedAt;
}
