import 'package:frontend/core/database/studyflow_database.dart';
import 'package:frontend/features/study_content/domain/models/study_note.dart';
import 'package:frontend/features/study_content/domain/repositories/study_notes_repository.dart';

class ToStoreStudyNotesRepository implements StudyNotesRepository {
  static const _tableName = 'study_notes';

  StudyNote _mapRow(Map<String, dynamic> row) {
    final updatedAt = row['updatedAt'];

    return StudyNote(
      id: row['id'].toString(),
      subtopicId: row['subtopicId'].toString(),
      name: row['name'].toString(),
      markdownText: row['markdownText'].toString(),
      createdAt: DateTime.parse(row['createdAt'].toString()),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt.toString()),
    );
  }

  @override
  Future<StudyNote> addStudyNote({
    required String subtopicId,
    required String name,
    required String markdownText,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'subtopicId': subtopicId,
      'name': name,
      'markdownText': markdownText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': null,
    });

    if (result.hasErrors) {
      throw Exception('Could not create study note.');
    }

    final generatedId = result.firstPrimaryKey.toString();

    return StudyNote(
      id: generatedId,
      subtopicId: subtopicId,
      name: name,
      markdownText: markdownText,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<StudyNote>> getStudyNotesBySubtopicId(String subtopicId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data
        .where((row) => row['subtopicId'].toString() == subtopicId)
        .map(_mapRow)
        .toList();
  }

  @override
  Stream<List<StudyNote>> watchStudyNotesBySubtopicId(String subtopicId) {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows
          .where((row) => row['subtopicId'].toString() == subtopicId)
          .map(_mapRow)
          .toList();
    });
  }

  @override
  Future<void> removeStudyNote(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not delete study note.');
    }
  }

  @override
  Future<void> updateStudyNote({
    required String id,
    required String name,
    required String markdownText,
    required String subtopicId,
  }) async {
    final updatedAt = DateTime.now();

    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'subtopicId': subtopicId,
          'markdownText': markdownText,
          'updatedAt': updatedAt.toIso8601String(),
        })
        .where('id', '=', id);

    if (result.hasErrors) {
      throw Exception('Could not update study note.');
    }
  }
}
