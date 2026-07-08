import 'package:frontend/models/study_note.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalStudyNotesRepository implements StudyNotesRepository {
  final List<StudyNote> _studyNotes = [...exampleStudyNotes];

  @override
  List<StudyNote> getStudyNotesByTopicId(int topicId) {
    return _studyNotes.where((studyNote) {
      return studyNote.topicId == topicId;
    }).toList();
  }

  @override
  void addStudyNote(StudyNote studynote) {
    _studyNotes.add(studynote);
  }

  @override
  void removeStudyNote(StudyNote studyNote) {
    _studyNotes.remove(studyNote);
  }
}
