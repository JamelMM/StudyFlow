class Quiz {
  const Quiz({
    required this.id,
    required this.topicId,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String topicId;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
