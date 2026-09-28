import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/repositories/contracts/exam_tips_repository.dart';

class ToStoreExamTipsRepository implements ExamTipsRepository {
  static const _tableName = 'exam_tips';

  ExamTip _mapRow(Map<String, dynamic> row) {
    final updatedAt = row['updatedAt'];

    return ExamTip(
      id: row['id'].toString(),
      examSectionId: row['examSectionId'].toString(),
      name: row['name'].toString(),
      markdownText: row['markdownText'].toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<List<ExamTip>> getExamTipsBySectionId(String examSectionId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['examSectionId'].toString() == examSectionId)
        .map(_mapRow)
        .toList();
  }

  @override
  Stream<List<ExamTip>> watchExamTipsBySectionId(String examSectionId) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where((row) => row['examSectionId'].toString() == examSectionId)
          .map(_mapRow)
          .toList();
    });
  }

  @override
  Future<ExamTip> addExamTip({
    required String examSectionId,
    required String name,
    required String markdownText,
  }) async {
    final createdAt = DateTime.now();
    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'examSectionId': examSectionId,
      'name': name,
      'markdownText': markdownText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (result.hasErrors) {
      throw Exception('Could not create exam tip.');
    }

    return ExamTip(
      id: result.firstPrimaryKey.toString(),
      examSectionId: examSectionId,
      name: name,
      markdownText: markdownText,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> updateExamTip({
    required String id,
    required String name,
    required String markdownText,
  }) async {
    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'markdownText': markdownText,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update exam tip.');
    }
  }

  @override
  Future<void> removeExamTip(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete exam tip.');
    }
  }
}
