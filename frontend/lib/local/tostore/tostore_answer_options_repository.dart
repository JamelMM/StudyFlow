import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/repositories/contracts/answeroptionsrepository.dart';

class ToStoreAnswerOptionsRepository implements AnswerOptionsRepository {
  static const _tableName = 'answer_options';

  @override
  Future<AnswerOption> addAnswerOption({
    required String questionId,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'questionId': questionId,
      'markdownText': markdownText,
      'isCorrect': isCorrect,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (!result.isSuccess) {
      throw Exception('Could not create answer.');
    }

    final generatedId = result.successKeys.first.toString();

    return AnswerOption(
      id: generatedId,
      questionId: questionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<AnswerOption>> getAnswerOptionsByQuestionId(
    String questionId,
  ) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['questionId'].toString() == questionId)
        .map((row) {
          final updatedAtValue = row['updatedAt'];

          return AnswerOption(
            id: row['id'].toString(),
            questionId: row['questionId'].toString(),
            markdownText: row['markdownText'].toString(),
            isCorrect:
                row['isCorrect'] == true ||
                row['isCorrect'].toString() == 'true',
            createdAt: DateTime.parse(row['createdAt'].toString()),
            updatedAt: updatedAtValue == null
                ? null
                : DateTime.parse(updatedAtValue.toString()),
          );
        })
        .toList();
  }

  @override
  Future<void> removeAnswerOption(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete answer.');
    }
  }
}
