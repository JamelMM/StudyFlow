import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/repositories/contracts/subtopics_repository.dart';
import 'package:frontend/models/subtopic.dart';

class ToStoreSubtopicsRepository implements SubtopicsRepository {
  static const _tableName = 'subtopics';

  Subtopic _mapRow(Map<String, dynamic> row) {
    final updatedAt = row['updatedAt'];

    return Subtopic(
      id: row['id'].toString(),
      topicId: row['topicId'].toString(),
      name: row['name'].toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<Subtopic> addSubtopic({
    required String topicId,
    required String name,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'topicId': topicId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (result.hasErrors) {
      throw Exception('Could not create subtopic.');
    }

    final generatedId = result.firstPrimaryKey.toString();

    return Subtopic(
      id: generatedId,
      topicId: topicId,
      name: name,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<Subtopic>> getSubtopicsByTopicId(String topicId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['topicId'].toString() == topicId)
        .map(_mapRow)
        .toList();
  }

  @override
  Future<void> removeSubtopic(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete subtopic.');
    }
  }

  @override
  Future<void> updateSubtopic({
    required String id,
    required String name,
  }) async {
    final updatedAt = DateTime.now();

    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'updatedAt': updatedAt.toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update subtopic.');
    }
  }

  @override
  Stream<List<Subtopic>> watchSubtopicsByTopicId(String topicId) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where((row) => row['topicId'].toString() == topicId)
          .map(_mapRow)
          .toList();
    });
  }
}
