import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalTopicRepository implements TopicsRepository {
  final List<Topic> _topics = [...exampleTopics];

  @override
  Future<List<Topic>> getTopicsBySubjectId(String subjectId) async {
    return _topics.where((topic) => topic.subjectId == subjectId).toList();
  }

  @override
  Future<Topic> addTopic({
    required String subjectId,
    required String name,
  }) async {
    final newTopic = Topic(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjectId: subjectId,
      name: name,
      createdAt: DateTime.now(),
    );

    _topics.add(newTopic);

    return newTopic;
  }
}
