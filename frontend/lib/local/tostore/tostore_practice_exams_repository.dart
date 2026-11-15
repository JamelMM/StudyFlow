import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/repositories/contracts/practice_exams_repository.dart';

class ToStorePracticeExamsRepository implements PracticeExamsRepository {
  static const _tableName = 'practice_exams';

  PracticeExam _mapRow(Map<String, dynamic> row) {
    final durationMinutes = row['durationMinutes'];
    final updatedAt = row['updatedAt'];

    return PracticeExam(
      id: row['id'].toString(),
      examSectionId: row['examSectionId'].toString(),
      name: row['name'].toString(),
      passingPercentage: int.parse(row['passingPercentage'].toString()),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      durationMinutes: durationMinutes == null
          ? null
          : int.parse(durationMinutes.toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<List<PracticeExam>> getPracticeExamsBySectionId(
    String examSectionId,
  ) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['examSectionId'].toString() == examSectionId)
        .map(_mapRow)
        .toList();
  }

  @override
  Stream<List<PracticeExam>> watchPracticeExamsBySectionId(
    String examSectionId,
  ) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where((row) => row['examSectionId'].toString() == examSectionId)
          .map(_mapRow)
          .toList();
    });
  }

  @override
  Future<PracticeExam> addPracticeExam({
    required String examSectionId,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'examSectionId': examSectionId,
      'name': name,
      'passingPercentage': passingPercentage,
      'durationMinutes': durationMinutes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (result.hasErrors) {
      throw Exception('Could not create practice exam.');
    }

    return PracticeExam(
      id: result.firstPrimaryKey.toString(),
      examSectionId: examSectionId,
      name: name,
      passingPercentage: passingPercentage,
      durationMinutes: durationMinutes,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> updatePracticeExam({
    required String id,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'passingPercentage': passingPercentage,
          'durationMinutes': durationMinutes,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update practice exam.');
    }
  }

  @override
  Future<void> removePracticeExam(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete practice exam.');
    }
  }
}
