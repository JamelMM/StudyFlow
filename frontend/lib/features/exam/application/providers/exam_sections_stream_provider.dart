import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/models/exam_section.dart';
import 'package:frontend/features/exam/application/providers/exam_sections_repository_provider.dart';

final examSectionsStreamProvider = StreamProvider<List<ExamSection>>((ref) {
  final examSectionsRepository = ref.watch(examSectionsRepositoryProvider);

  return examSectionsRepository.watchExamSections();
});
