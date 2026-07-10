import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';

class TostoreTopicsRepository implements TopicsRepository {
  static const _tableName = 'topics';

  @override
  Future<Topic> addTopic({
    required String subjectId,
    required String name,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'subjectId': subjectId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    });

    if (!result.isSuccess) {
      throw Exception('Could not create topic.');
    }

    final generatedId = result.successKeys.first.toString();

    return Topic(
      id: generatedId,
      subjectId: subjectId,
      name: name,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<Topic>> getTopicsBySubjectId(String subjectId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['subjectId'].toString() == subjectId)
        .map((row) {
          return Topic(
            id: row['id'].toString(),
            subjectId: row['subjectId'].toString(),
            name: row['name'].toString(),
            createdAt: DateTime.parse(row['createdAt'].toString()),
          );
        })
        .toList();
  }
}
