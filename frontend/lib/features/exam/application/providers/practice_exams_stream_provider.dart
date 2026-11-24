import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/models/practice_exam.dart';
import 'package:frontend/features/exam/application/providers/practice_exams_repository_provider.dart';

final practiceExamsStreamProvider = StreamProvider.autoDispose
    .family<List<PracticeExam>, String>((ref, examSectionId) {
      final practiceExamsRepository = ref.watch(
        practiceExamsRepositoryProvider,
      );

      return practiceExamsRepository.watchPracticeExamsBySectionId(
        examSectionId,
      );
    });
