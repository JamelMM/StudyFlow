import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_exam_tips_repository.dart';
import 'package:frontend/repositories/contracts/exam_tips_repository.dart';

final examTipsRepositoryProvider = Provider<ExamTipsRepository>((ref) {
  return ToStoreExamTipsRepository();
});
