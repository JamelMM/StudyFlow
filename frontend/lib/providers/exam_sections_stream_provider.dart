import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/providers/exam_sections_repository_provider.dart';

final examSectionsStreamProvider = StreamProvider<List<ExamSection>>((ref) {
  final examSectionsRepository = ref.watch(examSectionsRepositoryProvider);

  return examSectionsRepository.watchExamSections();
});
