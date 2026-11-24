import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/providers/practice_exams_repository_provider.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exams_repository.dart';

final practiceExamsControllerProvider =
    Provider.family<PracticeExamsController, String>((ref, examSectionId) {
      final practiceExamsRepository = ref.watch(
        practiceExamsRepositoryProvider,
      );

      return PracticeExamsController(
        practiceExamsRepository: practiceExamsRepository,
        examSectionId: examSectionId,
      );
    });

class PracticeExamsController {
  const PracticeExamsController({
    required this.practiceExamsRepository,
    required this.examSectionId,
  });

  final PracticeExamsRepository practiceExamsRepository;
  final String examSectionId;

  Future<void> addPracticeExam({
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    await practiceExamsRepository.addPracticeExam(
      examSectionId: examSectionId,
      name: name,
      passingPercentage: passingPercentage,
      durationMinutes: durationMinutes,
    );
  }

  Future<void> updatePracticeExam({
    required String id,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    await practiceExamsRepository.updatePracticeExam(
      id: id,
      name: name,
      passingPercentage: passingPercentage,
      durationMinutes: durationMinutes,
    );
  }

  Future<void> removePracticeExam(String id) async {
    await practiceExamsRepository.removePracticeExam(id);
  }
}
