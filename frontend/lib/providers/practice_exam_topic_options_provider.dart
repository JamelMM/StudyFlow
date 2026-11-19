import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';
import 'package:frontend/providers/topics_repository_provider.dart';

class PracticeExamTopicOption {
  const PracticeExamTopicOption({
    required this.topicId,
    required this.label,
  });

  final String topicId;
  final String label;
}

final practiceExamTopicOptionsProvider =
    FutureProvider.autoDispose<List<PracticeExamTopicOption>>((ref) async {
      final subjectsRepository = ref.watch(subjectsRepositoryProvider);
      final topicsRepository = ref.watch(topicsRepositoryProvider);
      final subjects = await subjectsRepository.getSubjects();

      final optionsBySubject = await Future.wait(
        subjects.map((subject) async {
          final topics = await topicsRepository.getTopicsBySubjectId(subject.id);

          return topics.map(
            (topic) => PracticeExamTopicOption(
              topicId: topic.id,
              label: '${subject.name} · ${topic.name}',
            ),
          );
        }),
      );

      final options = optionsBySubject.expand((items) => items).toList();
      options.sort((a, b) => a.label.compareTo(b.label));

      return options;
    });
