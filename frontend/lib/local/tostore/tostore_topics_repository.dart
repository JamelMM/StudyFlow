import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';

class ToStoreTopicsRepository implements TopicsRepository {
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

  @override
  Future<void> removeTopic(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete topic.');
    }
  }

  @override
  Future<void> updateTopic({required String id, required String name}) async {
    final updatedAt = DateTime.now();

    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'updatedAt': updatedAt.toIso8601String(),
        })
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not update topic.');
    }
  }
}
