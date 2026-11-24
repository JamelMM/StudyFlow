import 'package:frontend/features/study_content/domain/models/subtopic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/providers/subtopics_repository_provider.dart';

final subtopicsStreamProvider = StreamProvider.autoDispose
    .family<List<Subtopic>, String>((ref, topicId) {
      final subtopicsRepository = ref.watch(subtopicsRepositoryProvider);

      return subtopicsRepository.watchSubtopicsByTopicId(topicId);
    });
