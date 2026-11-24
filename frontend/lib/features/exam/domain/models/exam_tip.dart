class ExamTip {
  const ExamTip({
    required this.id,
    required this.examSectionId,
    required this.name,
    required this.markdownText,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String examSectionId;
  final String name;
  final String markdownText;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
