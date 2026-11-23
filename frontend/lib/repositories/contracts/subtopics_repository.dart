import 'package:frontend/models/subtopic.dart';

abstract class SubtopicsRepository {
  Future<List<Subtopic>> getSubtopicsByTopicId(String topicId);

  Stream<List<Subtopic>> watchSubtopicsByTopicId(String topicId);

  Future<Subtopic> addSubtopic({required String topicId, required String name});

  Future<void> removeSubtopic(String id);

  Future<void> updateSubtopic({required String id, required String name});
}
