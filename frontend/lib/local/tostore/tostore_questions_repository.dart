import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';

class ToStoreQuestionsRepository implements QuestionsRepository {
  static const _tableName = 'questions';

  @override
  Future<Question> addQuestion({
    required String quizId,
    required String markdownText,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'quizId': quizId,
      'markdownText': markdownText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (!result.isSuccess) {
      throw Exception('Could not create Question.');
    }

    final generatedId = result.successKeys.first.toString();

    return Question(
      id: generatedId,
      quizId: quizId,
      markdownText: markdownText,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<Question>> getQuestionsByQuizId(String quizId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data.where((row) => row['quizId'].toString() == quizId).map((
      row,
    ) {
      final updatedAtValue = row['updatedAt'];

      return Question(
        id: row['id'].toString(),
        quizId: row['quizId'].toString(),
        markdownText: row['markdownText'].toString(),
        createdAt: DateTime.parse(row['createdAt'].toString()),
        updatedAt: updatedAtValue == null
            ? null
            : DateTime.parse(updatedAtValue.toString()),
      );
    }).toList();
  }

  @override
  Future<void> removeQuestion(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete question.');
    }
  }
}
