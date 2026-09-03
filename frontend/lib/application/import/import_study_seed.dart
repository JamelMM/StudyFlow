import 'package:frontend/application/import/study_seed_parser.dart';
import 'package:frontend/application/import/study_seed_validation.dart';
import 'package:frontend/repositories/contracts/answer_options_repository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';

class ImportStudySeed {
  const ImportStudySeed({
    required this.parser,
    required this.validation,
    required this.subjectsRepository,
    required this.topicsRepository,
    required this.studyNotesRepository,
    required this.quizzesRepository,
    required this.questionsRepository,
    required this.answerOptionsRepository,
  });

  final StudySeedParser parser;
  final StudySeedValidation validation;
  final SubjectsRepository subjectsRepository;
  final TopicsRepository topicsRepository;
  final StudyNotesRepository studyNotesRepository;
  final QuizzesRepository quizzesRepository;
  final QuestionsRepository questionsRepository;
  final AnswerOptionsRepository answerOptionsRepository;

  Future<Subject> _findOrCreateSubject(String name) async {
    final subjects = await subjectsRepository.getSubjects();

    final normalizedName = name.trim().toLowerCase();

    for (final subject in subjects) {
      if (subject.name.trim().toLowerCase() == normalizedName) {
        return subject;
      }
    }

    return subjectsRepository.addSubject(name);
  }

  Future<Topic> _findOrCreateTopic({
    required String subjectId,
    required String name,
  }) async {
    final topics = await topicsRepository.getTopicsBySubjectId(subjectId);

    final normalizedName = name.trim().toLowerCase();

    for (final topic in topics) {
      if (topic.name.trim().toLowerCase() == normalizedName) {
        return topic;
      }
    }

    return topicsRepository.addTopic(subjectId: subjectId, name: name);
  }

  Future<void> call(String jsonText) async {
    final seed = parser.parse(jsonText);

    final validationError = validation.validate(seed);

    if (validationError != null) {
      throw FormatException(validationError);
    }

    for (final seedSubject in seed.subjects) {
      final subject = await _findOrCreateSubject(seedSubject.name);

      for (final seedTopic in seedSubject.topics) {
        final topic = await _findOrCreateTopic(
          subjectId: subject.id,
          name: seedTopic.name,
        );

        for (final seedNote in seedTopic.studyNotes) {
          await studyNotesRepository.addStudyNote(
            topicId: topic.id,
            name: seedNote.name,
            markdownText: seedNote.markdownText,
          );
        }

        final seedQuiz = seedTopic.quiz;

        if (seedQuiz == null) {
          continue;
        }

        final quiz = await quizzesRepository.addQuiz(
          topicId: topic.id,
          name: seedQuiz.name,
        );

        for (final seedQuestion in seedQuiz.questions) {
          final question = await questionsRepository.addQuestion(
            quizId: quiz.id,
            markdownText: seedQuestion.markdownText,
          );

          for (final seedAnswerOption in seedQuestion.answerOptions) {
            await answerOptionsRepository.addAnswerOption(
              questionId: question.id,
              markdownText: seedAnswerOption.markdownText,
              isCorrect: seedAnswerOption.isCorrect,
            );
          }
        }
      }
    }
  }
}
