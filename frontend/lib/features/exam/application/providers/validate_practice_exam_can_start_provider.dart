import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/use_cases/validate_practice_exam_can_start.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_answer_options_repository_provider.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_questions_repository_provider.dart';

final validatePracticeExamCanStartProvider =
    Provider<ValidatePracticeExamCanStart>((ref) {
      return ValidatePracticeExamCanStart(
        questionsRepository: ref.watch(practiceExamQuestionsRepositoryProvider),
        answerOptionsRepository: ref.watch(
          practiceExamAnswerOptionsRepositoryProvider,
        ),
      );
    });
