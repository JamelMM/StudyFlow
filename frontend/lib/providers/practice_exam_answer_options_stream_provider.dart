import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/providers/practice_exam_answer_options_repository_provider.dart';

final practiceExamAnswerOptionsStreamProvider = StreamProvider.autoDispose
    .family<List<PracticeExamAnswerOption>, String>((
      ref,
      practiceExamQuestionId,
    ) {
      final practiceExamAnswerOptionsRepository = ref.watch(
        practiceExamAnswerOptionsRepositoryProvider,
      );

      return practiceExamAnswerOptionsRepository.watchAnswerOptionsByQuestionId(
        practiceExamQuestionId,
      );
    });
