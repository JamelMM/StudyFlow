import 'package:frontend/models/topic.dart';

abstract class TopicsRepository {
  List<Topic> getTopicsBySubjectId(String subjectId);

  void addTopic(Topic topic);
}
