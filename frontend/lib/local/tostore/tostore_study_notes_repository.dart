import 'package:frontend/local/tostore/studyflow_database.dart';
import 'package:frontend/models/study_note.dart';

import 'package:frontend/repositories/contracts/study_notes_repository.dart';

class ToStoreStudyNotesRepository implements StudyNotesRepository {
  static const _tableName = 'study_notes';

  @override
  Future<StudyNote> addStudyNote({
    required String topicId,
    required String name,
    required String markdownText,
  }) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'topicId': topicId,
      'name': name,
      'markdownText': markdownText,
      'createdAt': createdAt.toIso8601String(),
      'updateAt': null,
    });

    if (!result.isSuccess) {
      throw Exception('Could not create study note.');
    }

    final generatedId = result.successKeys.first.toString();

    return StudyNote(
      id: generatedId,
      topicId: topicId,
      name: name,
      markdownText: markdownText,
      createdAt: createdAt,
    );
  }

  @override
  Future<List<StudyNote>> getStudyNotesByTopicId(String topicId) async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data.where((row) => row['topicId'].toString() == topicId).map(
      (row) {
        final updatedAtValue = row['updatedAt'];

        return StudyNote(
          id: row['id'].toString(),
          topicId: row['topicId'].toString(),
          name: row['name'].toString(),
          markdownText: row['markdownText'].toString(),
          createdAt: DateTime.parse(row['createdAt'].toString()),
          updatedAt: updatedAtValue == null
              ? null
              : DateTime.parse(updatedAtValue.toString()),
        );
      },
    ).toList();
  }

  @override
  Future<void> removeStudyNote(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete study note.');
    }
  }
}
