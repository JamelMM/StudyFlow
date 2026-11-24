import 'package:frontend/features/seed_import/application/study_seed.dart';

class StudySeedValidation {
  const StudySeedValidation();

  String? validate(StudySeed seed) {
    if (seed.version != 1) {
      return 'Unsupported seed version.';
    }

    if (seed.subjects.isEmpty && seed.examSections.isEmpty) {
      return 'The seed must contain subjects or exam sections.';
    }

    for (final subject in seed.subjects) {
      final subjectError = _validateSubject(subject);

      if (subjectError != null) {
        return subjectError;
      }
    }

    for (final examSection in seed.examSections) {
      final examSectionError = _validateExamSection(examSection);

      if (examSectionError != null) {
        return examSectionError;
      }
    }

    return null;
  }

  String? _validateExamSection(SeedExamSection examSection) {
    if (examSection.name.trim().isEmpty) {
      return 'Exam section name cannot be empty.';
    }

    for (final tip in examSection.tips) {
      if (tip.name.trim().isEmpty) {
        return 'Tip name cannot be empty in exam section "${examSection.name}".';
      }

      if (tip.markdownText.trim().isEmpty) {
        return 'Tip "${tip.name}" cannot have empty markdown text.';
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

    if (topic.subtopics.isEmpty) {
      return 'Topic "${topic.name}" must contain at least one subtopic.';
    }

    final subtopicNames = <String>{};

    for (final subtopic in topic.subtopics) {
      if (subtopic.name.trim().isEmpty) {
        return 'Subtopic name cannot be empty in topic "${topic.name}".';
      }

      final normalizedName = subtopic.name.trim().toLowerCase();

      if (!subtopicNames.add(normalizedName)) {
        return 'Subtopic "${subtopic.name}" is duplicated in topic "${topic.name}".';
      }

      for (final note in subtopic.studyNotes) {
        final noteError = _validateStudyNote(note, subtopic.name);

        if (noteError != null) {
          return noteError;
        }
      }
    }

    final quiz = topic.quiz;

    if (quiz != null) {
      return _validateQuiz(quiz, topic);
    }

    return null;
  }

  String? _validateStudyNote(SeedStudyNote note, String subtopicName) {
    if (note.name.trim().isEmpty) {
      return 'Study note name cannot be empty in subtopic "$subtopicName".';
    }

    if (note.markdownText.trim().isEmpty) {
      return 'Study note "${note.name}" cannot have empty markdown text.';
    }

    return null;
  }

  String? _validateQuiz(SeedQuiz quiz, SeedTopic topic) {
    if (quiz.name.trim().isEmpty) {
      return 'Quiz name cannot be empty in topic "${topic.name}".';
    }

    if (quiz.questions.isEmpty) {
      return 'Quiz "${quiz.name}" must contain at least one question.';
    }

    for (final question in quiz.questions) {
      final subtopicError = _validateQuestionSubtopic(question, topic);

      if (subtopicError != null) {
        return subtopicError;
      }

      final questionError = _validateQuestion(question, quiz.name);

      if (questionError != null) {
        return questionError;
      }
    }

    return null;
  }

  String? _validateQuestionSubtopic(SeedQuestion question, SeedTopic topic) {
    final subtopicName = question.subtopicName?.trim();

    if (subtopicName == null || subtopicName.isEmpty) {
      if (topic.subtopics.length == 1) {
        return null;
      }

      return 'Every question in topic "${topic.name}" must specify a subtopic.';
    }

    final exists = topic.subtopics.any(
      (subtopic) =>
          subtopic.name.trim().toLowerCase() == subtopicName.toLowerCase(),
    );

    if (!exists) {
      return 'Question references unknown subtopic "$subtopicName" in topic "${topic.name}".';
    }

    return null;
  }

  String? _validateQuestion(SeedQuestion question, String quizName) {
    if (question.markdownText.trim().isEmpty) {
      return 'Question text cannot be empty in quiz "$quizName".';
    }

    final explanationMarkdown = question.explanationMarkdown;

    if (explanationMarkdown != null && explanationMarkdown.trim().isEmpty) {
      return 'Question explanation cannot be empty in quiz "$quizName".';
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
