import 'package:frontend/models/topic.dart';

abstract class TopicsRepository {
  Future<List<Topic>> getTopicsBySubjectId(String subjectId);

  Future<Topic> addTopic({required String subjectId, required String name});
}
