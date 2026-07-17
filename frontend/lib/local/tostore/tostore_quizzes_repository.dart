import 'package:frontend/models/quiz.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:frontend/local/tostore/studyflow_database.dart';

class ToStoreQuizzesRepository implements QuizzesRepository {
  static const _tableName = 'quizzes';

  @override
  Future<Quiz> addQuiz({required String name, required String topicId}) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'name': name,
      'topicId': topicId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (!result.isSuccess) {
      throw Exception('Could not create Quiz.');
    }

    final generatedId = result.successKeys.first.toString();

    return Quiz(
      id: generatedId,
      topicId: topicId,
      name: name,
      createdAt: createdAt,
    );
  }

  @override
  Future<Quiz?> getQuizByTopicId(String topicId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    final rows = result.data
        .where((row) => row['topicId'].toString() == topicId)
        .toList();

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.first;
    final updatedAtValue = row['updatedAt'];

    return Quiz(
      id: row['id'].toString(),
      topicId: row['topicId'].toString(),
      name: row['name'].toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAtValue == null
          ? null
          : DateTime.parse(updatedAtValue.toString()),
    );
  }

  @override
  Future<void> removeQuiz(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete the quiz.');
    }
  }
}
