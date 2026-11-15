import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/providers/practice_exams_repository_provider.dart';

final practiceExamsStreamProvider = StreamProvider.autoDispose
    .family<List<PracticeExam>, String>((ref, examSectionId) {
      final practiceExamsRepository = ref.watch(
        practiceExamsRepositoryProvider,
      );

      return practiceExamsRepository.watchPracticeExamsBySectionId(
        examSectionId,
      );
    });
