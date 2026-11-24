import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/data/repositories/tostore_exam_tips_repository.dart';
import 'package:frontend/features/exam/domain/repositories/exam_tips_repository.dart';

final examTipsRepositoryProvider = Provider<ExamTipsRepository>((ref) {
  return ToStoreExamTipsRepository();
});
