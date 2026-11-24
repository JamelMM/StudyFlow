import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/providers/topics_repository_provider.dart';
import 'package:frontend/features/study_content/domain/models/topic.dart';

final topicsStreamProvider = StreamProvider.autoDispose
    .family<List<Topic>, String>((ref, subjectId) {
      final topicsRepository = ref.watch(topicsRepositoryProvider);

      return topicsRepository.watchTopicsBySubjectId(subjectId);
    });
