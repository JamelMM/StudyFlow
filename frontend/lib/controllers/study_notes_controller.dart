import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/study_notes_repository_provider.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';

final studyNotesControllerProvider =
    Provider.family<StudyNotesController, String>((ref, topicId) {
      final studyNotesRepository = ref.watch(studyNotesRepositoryProvider);

      return StudyNotesController(
        studyNotesRepository: studyNotesRepository,
        topicId: topicId,
      );
    });

class StudyNotesController {
  const StudyNotesController({
    required this.studyNotesRepository,
    required this.topicId,
  });

  final StudyNotesRepository studyNotesRepository;
  final String topicId;

  Future<void> addStudyNote({
    required String name,
    required String markdownText,
  }) async {
    await studyNotesRepository.addStudyNote(
      topicId: topicId,
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
      name: name,
      markdownText: markdownText,
    );
  }
}
