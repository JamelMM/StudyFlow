import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/providers/study_notes_repository_provider.dart';
import 'package:frontend/features/study_content/domain/repositories/study_notes_repository.dart';

final studyNotesControllerProvider =
    Provider.family<StudyNotesController, String>((ref, subtopicId) {
      final studyNotesRepository = ref.watch(studyNotesRepositoryProvider);

      return StudyNotesController(
        studyNotesRepository: studyNotesRepository,
        subtopicId: subtopicId,
      );
    });

class StudyNotesController {
  const StudyNotesController({
    required this.studyNotesRepository,
    required this.subtopicId,
  });

  final StudyNotesRepository studyNotesRepository;
  final String subtopicId;

  Future<void> addStudyNote({
    required String name,
    required String markdownText,
  }) async {
    await studyNotesRepository.addStudyNote(
      subtopicId: subtopicId,
      name: name,
      markdownText: markdownText,
    );
  }

  Future<void> removeStudyNote(String id) async {
    await studyNotesRepository.removeStudyNote(id);
  }

  Future<void> updateStudyNote({
    required String id,
    required String name,
    required String markdownText,
  }) async {
    await studyNotesRepository.updateStudyNote(
      id: id,
      subtopicId: subtopicId,
      name: name,
      markdownText: markdownText,
    );
  }
}
