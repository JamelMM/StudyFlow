import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/repositories/contracts/exam_sections_repository.dart';

class ToStoreExamSectionsRepository implements ExamSectionsRepository {
  static const _tableName = 'exam_sections';

  ExamSection _mapRow(Map<String, dynamic> row) {
    return ExamSection(
      id: row['id'].toString(),
      name: row['name'].toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
    );
  }

  @override
  Future<List<ExamSection>> getExamSections() async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data.map(_mapRow).toList();
  }

  @override
  Stream<List<ExamSection>> watchExamSections() {
    return StudyFlowDatabase.db
        .query(_tableName)
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Future<ExamSection> addExamSection(String name) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    });

    if (result.hasErrors) {
      throw Exception('Could not create exam section.');
    }

    return ExamSection(
      id: result.firstPrimaryKey.toString(),
      name: name,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> removeExamSection(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete exam section.');
    }
  }

  @override
  Future<void> updateExamSection({
    required String id,
    required String name,
  }) async {
    final result = await StudyFlowDatabase.db
        .update(_tableName, {'name': name})
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update exam section.');
    }
  }
}
