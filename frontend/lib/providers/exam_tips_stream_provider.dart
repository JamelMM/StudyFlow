import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/providers/exam_tips_repository_provider.dart';

final examTipsStreamProvider = StreamProvider.autoDispose
    .family<List<ExamTip>, String>((ref, examSectionId) {
      final repository = ref.watch(examTipsRepositoryProvider);
      return repository.watchExamTipsBySectionId(examSectionId);
    });
