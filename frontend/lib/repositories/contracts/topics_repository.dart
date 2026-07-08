import 'package:frontend/models/topic.dart';

abstract class TopicsRepository {
  List<Topic> getTopicsBySubjectId(int subjectId);

  void addTopic(Topic topic);
}
