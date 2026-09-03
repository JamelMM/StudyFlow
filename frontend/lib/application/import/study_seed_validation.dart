import 'package:frontend/application/import/study_seed.dart';

class StudySeedValidation {
  const StudySeedValidation();

  String? validate(StudySeed seed) {
    if (seed.version != 1) {
      return 'Unsupported seed version.';
    }

    if (seed.subjects.isEmpty) {
      return 'The seed must contain at least one subject.';
    }

    for (final subject in seed.subjects) {
      final subjectError = _validateSubject(subject);

      if (subjectError != null) {
        return subjectError;
      }
    }

    return null;
  }

  String? _validateSubject(SeedSubject subject) {
    if (subject.name.trim().isEmpty) {
      return 'Subject name cannot be empty.';
    }

    if (subject.topics.isEmpty) {
      return 'Subject "${subject.name}" must contain at least one topic.';
    }

    for (final topic in subject.topics) {
      final topicError = _validateTopic(topic, subject.name);

      if (topicError != null) {
        return topicError;
      }
    }

    return null;
  }

  String? _validateTopic(SeedTopic topic, String subjectName) {
    if (topic.name.trim().isEmpty) {
      return 'Topic name cannot be empty in subject "$subjectName".';
    }

    for (final note in topic.studyNotes) {
      final noteError = _validateStudyNote(note, topic.name);

      if (noteError != null) {
        return noteError;
      }
    }

    final quiz = topic.quiz;

    if (quiz != null) {
      return _validateQuiz(quiz, topic.name);
    }

    return null;
  }

  String? _validateStudyNote(SeedStudyNote note, String topicName) {
    if (note.name.trim().isEmpty) {
      return 'Study note name cannot be empty in topic "$topicName".';
    }

    if (note.markdownText.trim().isEmpty) {
      return 'Study note "${note.name}" cannot have empty markdown text.';
    }

    return null;
  }

  String? _validateQuiz(SeedQuiz quiz, String topicName) {
    if (quiz.name.trim().isEmpty) {
      return 'Quiz name cannot be empty in topic "$topicName".';
    }

    if (quiz.questions.isEmpty) {
      return 'Quiz "${quiz.name}" must contain at least one question.';
    }

    for (final question in quiz.questions) {
      final questionError = _validateQuestion(question, quiz.name);

      if (questionError != null) {
        return questionError;
      }
    }

    return null;
  }

  String? _validateQuestion(SeedQuestion question, String quizName) {
    if (question.markdownText.trim().isEmpty) {
      return 'Question text cannot be empty in quiz "$quizName".';
    }

    if (question.answerOptions.isEmpty) {
      return 'Every question in quiz "$quizName" needs at least one answer.';
    }

    final correctAnswersCount = question.answerOptions
        .where((answerOption) => answerOption.isCorrect)
        .length;

    if (correctAnswersCount == 0) {
      return 'Every question in quiz "$quizName" needs one correct answer.';
    }

    if (correctAnswersCount > 1) {
      return 'Every question in quiz "$quizName" can only have one correct answer.';
    }

    for (final answerOption in question.answerOptions) {
      if (answerOption.markdownText.trim().isEmpty) {
        return 'Answer text cannot be empty in quiz "$quizName".';
      }
    }

    return null;
  }
}
