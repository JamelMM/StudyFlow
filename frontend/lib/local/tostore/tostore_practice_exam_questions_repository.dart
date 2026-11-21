import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

class ToStorePracticeExamQuestionsRepository
    implements PracticeExamQuestionsRepository {
  static const _tableName = 'practice_exam_questions';

  PracticeExamQuestion _mapRow(Map<String, dynamic> row) {
    final updatedAt = row['updatedAt'];

    return PracticeExamQuestion(
      id: row['id'].toString(),
      practiceExamId: row['practiceExamId'].toString(),
      topicId: row['topicId']?.toString(),
      markdownText: row['markdownText'].toString(),
      explanationMarkdown: row['explanationMarkdown']?.toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<List<PracticeExamQuestion>> getQuestionsByPracticeExamId(
    String practiceExamId,
  ) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['practiceExamId'].toString() == practiceExamId)
        .map(_mapRow)
        .toList();
  }

  @override
  Stream<List<PracticeExamQuestion>> watchQuestionsByPracticeExamId(
    String practiceExamId,
  ) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where((row) => row['practiceExamId'].toString() == practiceExamId)
          .map(_mapRow)
          .toList();
    });
  }

  @override
  Future<PracticeExamQuestion> addQuestion({
    required String practiceExamId,
    required String markdownText,
    String? topicId,
    String? explanationMarkdown,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'practiceExamId': practiceExamId,
      'topicId': topicId,
      'markdownText': markdownText,
      'explanationMarkdown': explanationMarkdown,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (result.hasErrors) {
      throw Exception('Could not create practice exam question.');
    }

    return PracticeExamQuestion(
      id: result.firstPrimaryKey.toString(),
      practiceExamId: practiceExamId,
      topicId: topicId,
      markdownText: markdownText,
      explanationMarkdown: explanationMarkdown,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? topicId,
    String? explanationMarkdown,
  }) async {
    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'topicId': topicId,
          'markdownText': markdownText,
          'explanationMarkdown': explanationMarkdown,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update practice exam question.');
    }
  }

  @override
  Future<void> removeQuestion(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete practice exam question.');
    }
  }
}
