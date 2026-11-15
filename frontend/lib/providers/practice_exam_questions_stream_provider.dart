import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/providers/practice_exam_questions_repository_provider.dart';

final practiceExamQuestionsStreamProvider = StreamProvider.autoDispose
    .family<List<PracticeExamQuestion>, String>((ref, practiceExamId) {
      final practiceExamQuestionsRepository = ref.watch(
        practiceExamQuestionsRepositoryProvider,
      );

      return practiceExamQuestionsRepository.watchQuestionsByPracticeExamId(
        practiceExamId,
      );
    });
