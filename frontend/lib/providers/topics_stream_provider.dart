import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/topics_repository_provider.dart';
import 'package:frontend/models/topic.dart';

final topicsStreamProvider = StreamProvider.family<List<Topic>, String>((
  ref,
  subjectId,
) {
  final topicsRepository = ref.watch(topicsRepositoryProvider);

  return topicsRepository.watchTopicsBySubjectId(subjectId);
});
