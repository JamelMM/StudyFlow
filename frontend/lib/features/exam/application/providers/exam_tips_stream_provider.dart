import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/models/exam_tip.dart';
import 'package:frontend/features/exam/application/providers/exam_tips_repository_provider.dart';

final examTipsStreamProvider = StreamProvider.autoDispose
    .family<List<ExamTip>, String>((ref, examSectionId) {
      final repository = ref.watch(examTipsRepositoryProvider);
      return repository.watchExamTipsBySectionId(examSectionId);
    });
