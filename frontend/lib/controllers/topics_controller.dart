import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/topics_repository_provider.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';

final topicsControllerProvider = Provider.family<TopicsController, String>((
  ref,
  subjectId,
) {
  final topicsRepository = ref.watch(topicsRepositoryProvider);

  return TopicsController(
    topicsRepository: topicsRepository,
    subjectId: subjectId,
  );
});

class TopicsController {
  const TopicsController({
    required this.topicsRepository,
    required this.subjectId,
  });

  final TopicsRepository topicsRepository;
  final String subjectId;

  Future<void> addTopic({required String name}) async {
    await topicsRepository.addTopic(subjectId: subjectId, name: name);
  }

  Future<void> removeTopic(String id) async {
    await topicsRepository.removeTopic(id);
  }

  Future<void> updateTopic({required String id, required String name}) async {
    await topicsRepository.updateTopic(id: id, name: name);
  }
}
