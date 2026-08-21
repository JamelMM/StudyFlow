import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/providers/topics_repository_provider.dart';

final topicsControllerProvider =
    AsyncNotifierProvider.family<TopicsController, List<Topic>, String>(
      TopicsController.new,
    );

class TopicsController extends AsyncNotifier<List<Topic>> {
  TopicsController(this.subjectId);

  final String subjectId;

  @override
  Future<List<Topic>> build() async {
    final topicsRepository = ref.watch(topicsRepositoryProvider);

    return topicsRepository.getTopicsBySubjectId(subjectId);
  }

  Future<void> addTopic({required String name}) async {
    final topicsRepository = ref.read(topicsRepositoryProvider);

    await topicsRepository.addTopic(subjectId: subjectId, name: name);

    ref.invalidateSelf();
  }

  Future<void> removeTopic(String id) async {
    final topicsRepository = ref.read(topicsRepositoryProvider);

    await topicsRepository.removeTopic(id);

    ref.invalidateSelf();
  }

  Future<void> updateTopic({required String id, required String name}) async {
    final topicsRepository = ref.read(topicsRepositoryProvider);

    await topicsRepository.updateTopic(id: id, name: name);

    ref.invalidateSelf();
  }
}
