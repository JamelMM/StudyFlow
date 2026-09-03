import 'dart:convert';

import 'package:frontend/application/import/study_seed.dart';

class StudySeedParser {
  const StudySeedParser();

  StudySeed parse(String jsonText) {
    final decodedJson = jsonDecode(jsonText);

    if (decodedJson is! Map<String, dynamic>) {
      throw const FormatException('Seed JSON must be an object.');
    }

    return _parseStudySeed(decodedJson);
  }

  StudySeed _parseStudySeed(Map<String, dynamic> json) {
    return StudySeed(
      version: json['version'] as int,
      subjects: _parseSubjects(json['subjects']),
    );
  }

  List<SeedSubject> _parseSubjects(Object? value) {
    if (value is! List) {
      throw const FormatException('subjects must be a list.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each subject must be an object.');
      }

      return SeedSubject(
        name: item['name'] as String,
        topics: _parseTopics(item['topics']),
      );
    }).toList();
  }

  List<SeedTopic> _parseTopics(Object? value) {
    if (value is! List) {
      throw const FormatException('topics must be a list.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each topic must be an object.');
      }

      return SeedTopic(
        name: item['name'] as String,
        studyNotes: _parseStudyNotes(item['studyNotes']),
        quiz: _parseQuiz(item['quiz']),
      );
    }).toList();
  }

  List<SeedStudyNote> _parseStudyNotes(Object? value) {
    if (value == null) {
      return [];
    }

    if (value is! List) {
      throw const FormatException('studyNotes must be a list.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each study note must be an object.');
      }

      return SeedStudyNote(
        name: item['name'] as String,
        markdownText: item['markdownText'] as String,
      );
    }).toList();
  }

  SeedQuiz? _parseQuiz(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is! Map<String, dynamic>) {
      throw const FormatException('quiz must be an object.');
    }

    return SeedQuiz(
      name: value['name'] as String,
      questions: _parseQuestions(value['questions']),
    );
  }

  List<SeedQuestion> _parseQuestions(Object? value) {
    if (value is! List) {
      throw const FormatException('questions must be a list.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each question must be an object.');
      }

      return SeedQuestion(
        markdownText: item['markdownText'] as String,
        answerOptions: _parseAnswerOptions(item['answerOptions']),
      );
    }).toList();
  }

  List<SeedAnswerOption> _parseAnswerOptions(Object? value) {
    if (value is! List) {
      throw const FormatException('answerOptions must be a list.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Each answer option must be an object.');
      }

      return SeedAnswerOption(
        markdownText: item['markdownText'] as String,
        isCorrect: item['isCorrect'] as bool,
      );
    }).toList();
  }
}
