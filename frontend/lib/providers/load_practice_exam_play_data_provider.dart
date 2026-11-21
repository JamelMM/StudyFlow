import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/practice_exam/load_practice_exam_play_data.dart';
import 'package:frontend/application/practice_exam/practice_exam_play_data.dart';
import 'package:frontend/providers/practice_exam_answer_options_repository_provider.dart';
import 'package:frontend/providers/practice_exam_questions_repository_provider.dart';

final loadPracticeExamPlayDataProvider = Provider<LoadPracticeExamPlayData>((
  ref,
) {
  return LoadPracticeExamPlayData(
    questionsRepository: ref.watch(practiceExamQuestionsRepositoryProvider),
    answerOptionsRepository: ref.watch(
      practiceExamAnswerOptionsRepositoryProvider,
    ),
  );
});

final practiceExamPlayDataProvider = FutureProvider.autoDispose
    .family<PracticeExamPlayData, String>((ref, practiceExamId) {
      final loadPracticeExamPlayData = ref.watch(
        loadPracticeExamPlayDataProvider,
      );

      return loadPracticeExamPlayData(practiceExamId);
    });
