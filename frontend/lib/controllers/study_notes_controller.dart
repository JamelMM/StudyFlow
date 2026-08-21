import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/study_notes_repository_provider.dart';
import 'package:frontend/models/study_note.dart';

final studyNotesControllerProvider =
    AsyncNotifierProvider.family<StudyNotesController, List<StudyNote>, String>(
      StudyNotesController.new,
    );

class StudyNotesController extends AsyncNotifier<List<StudyNote>> {
  StudyNotesController(this.topicId);

  final String topicId;

  @override
  Future<List<StudyNote>> build() async {
    final studyNotesRepository = ref.watch(studyNotesRepositoryProvider);

    return studyNotesRepository.getStudyNotesByTopicId(topicId);
  }

  Future<void> addStudyNote({
    required String name,
    required String markdownText,
  }) async {
    final studyNotesRepository = ref.read(studyNotesRepositoryProvider);

    await studyNotesRepository.addStudyNote(
      topicId: topicId,
      name: name,
      markdownText: markdownText,
    );

    ref.invalidateSelf();
  }

  Future<void> removeStudyNote(String id) async {
    final studyNotesRepository = ref.read(studyNotesRepositoryProvider);

    await studyNotesRepository.removeStudyNote(id);

    ref.invalidateSelf();
  }

  Future<void> updateStudyNote({
    required String id,
    required String name,
    required String markdownText,
  }) async {
    final studyNotesRepository = ref.read(studyNotesRepositoryProvider);

    await studyNotesRepository.updateStudyNote(
      id: id,
      name: name,
      markdownText: markdownText,
    );
    ref.invalidateSelf();
  }
}
