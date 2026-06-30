class StudyNote {
  const StudyNote({
    required this.id,
    required this.topicId,
    required this.title,
    required this.content,
  });

  final int id;
  final int topicId;
  final String title;
  final String content;
}
