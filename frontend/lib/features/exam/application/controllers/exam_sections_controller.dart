import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/providers/exam_sections_repository_provider.dart';
import 'package:frontend/features/exam/domain/repositories/exam_sections_repository.dart';

final examSectionsControllerProvider = Provider<ExamSectionsController>((ref) {
  final examSectionsRepository = ref.watch(examSectionsRepositoryProvider);

  return ExamSectionsController(examSectionsRepository);
});

class ExamSectionsController {
  const ExamSectionsController(this.examSectionsRepository);

  final ExamSectionsRepository examSectionsRepository;

  Future<void> addExamSection(String name) async {
    await examSectionsRepository.addExamSection(name);
  }

  Future<void> removeExamSection(String id) async {
    await examSectionsRepository.removeExamSection(id);
  }

  Future<void> updateExamSection({
    required String id,
    required String name,
  }) async {
    await examSectionsRepository.updateExamSection(id: id, name: name);
  }
}
