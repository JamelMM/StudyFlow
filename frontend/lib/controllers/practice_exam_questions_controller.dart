import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/practice_exam_questions_repository_provider.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

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
    String? topicId,
    String? explanationMarkdown,
  }) async {
    await practiceExamQuestionsRepository.addQuestion(
      practiceExamId: practiceExamId,
      markdownText: markdownText,
      topicId: topicId,
      explanationMarkdown: explanationMarkdown,
    );
  }

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? topicId,
    String? explanationMarkdown,
  }) async {
    await practiceExamQuestionsRepository.updateQuestion(
      id: id,
      markdownText: markdownText,
      topicId: topicId,
      explanationMarkdown: explanationMarkdown,
    );
  }

  Future<void> removeQuestion(String id) async {
    await practiceExamQuestionsRepository.removeQuestion(id);
  }
}
