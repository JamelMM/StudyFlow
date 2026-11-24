import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/providers/subtopics_repository_provider.dart';
import 'package:frontend/features/study_content/domain/repositories/subtopics_repository.dart';

final subtopicsControllerProvider =
    Provider.family<SubtopicsController, String>((ref, topicId) {
      final subtopicsRepository = ref.watch(subtopicsRepositoryProvider);

      return SubtopicsController(
        subtopicsRepository: subtopicsRepository,
        topicId: topicId,
      );
    });

class SubtopicsController {
  const SubtopicsController({
    required this.subtopicsRepository,
    required this.topicId,
  });

  final SubtopicsRepository subtopicsRepository;
  final String topicId;

  Future<void> addSubtopic({required String name}) async {
    await subtopicsRepository.addSubtopic(topicId: topicId, name: name);
  }

  Future<void> removeSubtopic(String id) async {
    await subtopicsRepository.removeSubtopic(id);
  }

  Future<void> updateSubtopic({
    required String id,
    required String name,
  }) async {
    await subtopicsRepository.updateSubtopic(id: id, name: name);
  }
}
