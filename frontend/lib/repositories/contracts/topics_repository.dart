import 'package:frontend/models/topic.dart';

abstract class TopicsRepository {
  Future<List<Topic>> getTopicsBySubjectId(String subjectId);

  Future<Topic> addTopic({required String subjectId, required String name});

  Future<void> removeTopic(String id);

  Future<void> updateTopic({required String id, required String name});
}
