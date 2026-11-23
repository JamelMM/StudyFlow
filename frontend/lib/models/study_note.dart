class StudyNote {
  const StudyNote({
    required this.id,
    required this.subtopicId,
    required this.name,
    required this.markdownText,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String subtopicId;
  final String name;
  final String markdownText;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
