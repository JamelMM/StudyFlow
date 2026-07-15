import 'package:frontend/models/study_note.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalStudyNotesRepository implements StudyNotesRepository {
  final List<StudyNote> _studyNotes = [...exampleStudyNotes];

  @override
  Future<List<StudyNote>> getStudyNotesByTopicId(String topicId) async {
    return _studyNotes.where((studyNote) {
      return studyNote.topicId == topicId;
    }).toList();
  }

  @override
  Future<StudyNote> addStudyNote({
    required String topicId,
    required String name,
    required String markdownText,
  }) async {
    final newStudyNote = StudyNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topicId: topicId,
      name: name,
      markdownText: markdownText,
      createdAt: DateTime.now(),
    );

    _studyNotes.add(newStudyNote);

    return newStudyNote;
  }

  @override
  Future<void> removeStudyNote(String id) async {
    _studyNotes.removeWhere((studyNote) {
      return studyNote.id == id;
    });
  }
}
