class StudySeed {
  const StudySeed({required this.version, required this.subjects});

  final int version;
  final List<SeedSubject> subjects;
}

class SeedSubject {
  const SeedSubject({required this.name, required this.topics});

  final String name;
  final List<SeedTopic> topics;
}

class SeedTopic {
  const SeedTopic({required this.name, required this.studyNotes, this.quiz});

  final String name;
  final List<SeedStudyNote> studyNotes;
  final SeedQuiz? quiz;
}

class SeedStudyNote {
  const SeedStudyNote({required this.name, required this.markdownText});

  final String name;
  final String markdownText;
}

class SeedQuiz {
  const SeedQuiz({required this.name, required this.questions});

  final String name;
  final List<SeedQuestion> questions;
}

class SeedQuestion {
  const SeedQuestion({required this.markdownText, required this.answerOptions});

  final String markdownText;
  final List<SeedAnswerOption> answerOptions;
}

class SeedAnswerOption {
  const SeedAnswerOption({required this.markdownText, required this.isCorrect});

  final String markdownText;
  final bool isCorrect;
}
