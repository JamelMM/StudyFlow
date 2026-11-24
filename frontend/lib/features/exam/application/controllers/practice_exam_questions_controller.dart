import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_questions_repository_provider.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_questions_repository.dart';

final practiceExamQuestionsControllerProvider =
    Provider.family<PracticeExamQuestionsController, String>((
      ref,
      practiceExamId,
    ) {
      final practiceExamQuestionsRepository = ref.watch(
        practiceExamQuestionsRepositoryProvider,
      );

      return PracticeExamQuestionsController(
        practiceExamQuestionsRepository: practiceExamQuestionsRepository,
        practiceExamId: practiceExamId,
      );
    });

class PracticeExamQuestionsController {
  const PracticeExamQuestionsController({
    required this.practiceExamQuestionsRepository,
    required this.practiceExamId,
  });

  final PracticeExamQuestionsRepository practiceExamQuestionsRepository;
  final String practiceExamId;

  Future<void> addQuestion({
    required String markdownText,
    String? subtopicId,
    String? explanationMarkdown,
  }) async {
    await practiceExamQuestionsRepository.addQuestion(
      practiceExamId: practiceExamId,
      markdownText: markdownText,
      subtopicId: subtopicId,
      explanationMarkdown: explanationMarkdown,
    );
  }

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? subtopicId,
    String? explanationMarkdown,
  }) async {
    await practiceExamQuestionsRepository.updateQuestion(
      id: id,
      markdownText: markdownText,
      subtopicId: subtopicId,
      explanationMarkdown: explanationMarkdown,
    );
  }

  Future<void> removeQuestion(String id) async {
    await practiceExamQuestionsRepository.removeQuestion(id);
  }
}
