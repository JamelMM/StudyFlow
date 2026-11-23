import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';
import 'package:frontend/providers/subtopics_repository_provider.dart';
import 'package:frontend/providers/topics_repository_provider.dart';

class PracticeExamSubtopicOption {
  const PracticeExamSubtopicOption({
    required this.subtopicId,
    required this.label,
  });

  final String subtopicId;
  final String label;
}

final practiceExamSubtopicOptionsProvider =
    FutureProvider.autoDispose<List<PracticeExamSubtopicOption>>((ref) async {
      final subjectsRepository = ref.watch(subjectsRepositoryProvider);
      final topicsRepository = ref.watch(topicsRepositoryProvider);
      final subtopicsRepository = ref.watch(subtopicsRepositoryProvider);
      final subjects = await subjectsRepository.getSubjects();

      final optionsBySubject = await Future.wait(
        subjects.map((subject) async {
          final topics = await topicsRepository.getTopicsBySubjectId(
            subject.id,
          );

          final optionsByTopic = await Future.wait(
            topics.map((topic) async {
              final subtopics = await subtopicsRepository.getSubtopicsByTopicId(
                topic.id,
              );

              return subtopics.map(
                (subtopic) => PracticeExamSubtopicOption(
                  subtopicId: subtopic.id,
                  label: '${subject.name} · ${topic.name} · ${subtopic.name}',
                ),
              );
            }),
          );

          return optionsByTopic.expand((items) => items);
        }),
      );

      final options = optionsBySubject.expand((items) => items).toList();
      options.sort((a, b) => a.label.compareTo(b.label));

      return options;
    });
