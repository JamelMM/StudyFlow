import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';

class ToStorePracticeExamAnswerOptionsRepository
    implements PracticeExamAnswerOptionsRepository {
  static const _tableName = 'practice_exam_answer_options';

  PracticeExamAnswerOption _mapRow(Map<String, dynamic> row) {
    final updatedAt = row['updatedAt'];

    return PracticeExamAnswerOption(
      id: row['id'].toString(),
      practiceExamQuestionId: row['practiceExamQuestionId'].toString(),
      markdownText: row['markdownText'].toString(),
      isCorrect:
          row['isCorrect'] == true || row['isCorrect'].toString() == 'true',
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<PracticeExamAnswerOption> addAnswerOption({
    required String practiceExamQuestionId,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'practiceExamQuestionId': practiceExamQuestionId,
      'markdownText': markdownText,
      'isCorrect': isCorrect,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });
    if (result.hasErrors) {
      throw Exception('Could not create answer.');
    }

    return PracticeExamAnswerOption(
      id: result.firstPrimaryKey.toString(),
      practiceExamQuestionId: practiceExamQuestionId,
      isCorrect: isCorrect,
      markdownText: markdownText,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<PracticeExamAnswerOption>> getAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where(
          (row) =>
              row['practiceExamQuestionId'].toString() ==
              practiceExamQuestionId,
        )
        .map((row) => _mapRow(row))
        .toList();
  }

  @override
  Future<void> removeAnswerOption(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete answer.');
    }
  }

  @override
  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'markdownText': markdownText,
          'isCorrect': isCorrect,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update answer.');
    }
  }

  @override
  Stream<List<PracticeExamAnswerOption>> watchAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where(
            (row) =>
                row['practiceExamQuestionId'].toString() ==
                practiceExamQuestionId,
          )
          .map(_mapRow)
          .toList();
    });
  }
}
