import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/data/repositories/tostore_topics_repository.dart';
import 'package:frontend/features/study_content/domain/repositories/topics_repository.dart';

final topicsRepositoryProvider = Provider<TopicsRepository>((ref) {
  return ToStoreTopicsRepository();
});
