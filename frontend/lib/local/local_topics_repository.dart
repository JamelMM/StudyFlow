import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalTopicRepository implements TopicsRepository {
  final List<Topic> _topics = [...exampleTopics];

  @override
  List<Topic> getTopicsBySubjectId(int subjectId) {
    return _topics.where((topic) => topic.subjectId == subjectId).toList();
  }

  @override
  void addTopic(Topic topic) {
    _topics.add(topic);
  }
}
