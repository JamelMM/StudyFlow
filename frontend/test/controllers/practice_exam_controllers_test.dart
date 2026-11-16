import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controllers/practice_exam_answer_options_controller.dart';
import 'package:frontend/controllers/practice_exam_questions_controller.dart';
import 'package:frontend/controllers/practice_exams_controller.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';
import 'package:frontend/repositories/contracts/practice_exams_repository.dart';

void main() {
  group('PracticeExamsController', () {
    test('creates an exam in the selected section', () async {
      final repository = _MemoryPracticeExamsRepository();
      final controller = PracticeExamsController(
        practiceExamsRepository: repository,
        examSectionId: 'section-1',
      );

      await controller.addPracticeExam(
        name: 'AP1 Practice',
        passingPercentage: 67,
        durationMinutes: 90,
      );

      final exam = repository.items.single;
      expect(exam.examSectionId, 'section-1');
      expect(exam.name, 'AP1 Practice');
      expect(exam.passingPercentage, 67);
      expect(exam.durationMinutes, 90);
    });

    test('updates and removes an exam', () async {
      final repository = _MemoryPracticeExamsRepository();
      final controller = PracticeExamsController(
        practiceExamsRepository: repository,
        examSectionId: 'section-1',
      );
      final exam = await repository.addPracticeExam(
        examSectionId: 'section-1',
        name: 'Old name',
        passingPercentage: 50,
      );

      await controller.updatePracticeExam(
        id: exam.id,
        name: 'Updated name',
        passingPercentage: 70,
        durationMinutes: 60,
      );

      expect(repository.items.single.name, 'Updated name');
      expect(repository.items.single.passingPercentage, 70);
      expect(repository.items.single.durationMinutes, 60);

      await controller.removePracticeExam(exam.id);

      expect(repository.items, isEmpty);
    });
  });

  group('PracticeExamQuestionsController', () {
    test('creates a question with its explanation', () async {
      final repository = _MemoryPracticeExamQuestionsRepository();
      final controller = PracticeExamQuestionsController(
        practiceExamQuestionsRepository: repository,
        practiceExamId: 'exam-1',
      );

      await controller.addQuestion(
        markdownText: '**Which answer is correct?**',
        explanationMarkdown: 'Because **B** is correct.',
      );

      final question = repository.items.single;
      expect(question.practiceExamId, 'exam-1');
      expect(question.markdownText, '**Which answer is correct?**');
      expect(question.explanationMarkdown, 'Because **B** is correct.');
    });

    test('updates and removes a question', () async {
      final repository = _MemoryPracticeExamQuestionsRepository();
      final controller = PracticeExamQuestionsController(
        practiceExamQuestionsRepository: repository,
        practiceExamId: 'exam-1',
      );
      final question = await repository.addQuestion(
        practiceExamId: 'exam-1',
        markdownText: 'Old question',
      );

      await controller.updateQuestion(
        id: question.id,
        markdownText: 'Updated question',
        explanationMarkdown: 'Updated explanation',
      );

      expect(repository.items.single.markdownText, 'Updated question');
      expect(
        repository.items.single.explanationMarkdown,
        'Updated explanation',
      );

      await controller.removeQuestion(question.id);

      expect(repository.items, isEmpty);
    });
  });

  group('PracticeExamAnswerOptionsController', () {
    late _MemoryPracticeExamAnswerOptionsRepository repository;
    late PracticeExamAnswerOptionsController controller;

    setUp(() {
      repository = _MemoryPracticeExamAnswerOptionsRepository();
      controller = PracticeExamAnswerOptionsController(
        practiceExamAnswerOptionsRepository: repository,
        practiceExamQuestionId: 'question-1',
      );
    });

    test('adds the first correct answer', () async {
      final error = await controller.addAnswerOption(
        markdownText: 'Correct answer',
        isCorrect: true,
      );

      expect(error, isNull);
      expect(repository.items, hasLength(1));
      expect(repository.items.single.practiceExamQuestionId, 'question-1');
      expect(repository.items.single.isCorrect, isTrue);
    });

    test('rejects a second correct answer', () async {
      await repository.addAnswerOption(
        practiceExamQuestionId: 'question-1',
        markdownText: 'First correct answer',
        isCorrect: true,
      );

      final error = await controller.addAnswerOption(
        markdownText: 'Second correct answer',
        isCorrect: true,
      );

      expect(error, 'A question can only have one correct answer.');
      expect(repository.items, hasLength(1));
    });

    test('allows multiple incorrect answers', () async {
      await controller.addAnswerOption(
        markdownText: 'Incorrect A',
        isCorrect: false,
      );
      final error = await controller.addAnswerOption(
        markdownText: 'Incorrect B',
        isCorrect: false,
      );

      expect(error, isNull);
      expect(repository.items, hasLength(2));
    });

    test('rejects marking another answer as correct', () async {
      await repository.addAnswerOption(
        practiceExamQuestionId: 'question-1',
        markdownText: 'Correct answer',
        isCorrect: true,
      );
      final otherAnswer = await repository.addAnswerOption(
        practiceExamQuestionId: 'question-1',
        markdownText: 'Incorrect answer',
        isCorrect: false,
      );

      final error = await controller.updateAnswerOption(
        id: otherAnswer.id,
        markdownText: otherAnswer.markdownText,
        isCorrect: true,
      );

      expect(error, 'A question can only have one correct answer.');
      expect(repository.items.last.isCorrect, isFalse);
    });

    test('allows editing the existing correct answer', () async {
      final answer = await repository.addAnswerOption(
        practiceExamQuestionId: 'question-1',
        markdownText: 'Correct answer',
        isCorrect: true,
      );

      final error = await controller.updateAnswerOption(
        id: answer.id,
        markdownText: 'Edited correct answer',
        isCorrect: true,
      );

      expect(error, isNull);
      expect(repository.items.single.markdownText, 'Edited correct answer');
      expect(repository.items.single.isCorrect, isTrue);
    });

    test('removes an answer', () async {
      final answer = await repository.addAnswerOption(
        practiceExamQuestionId: 'question-1',
        markdownText: 'Answer',
        isCorrect: false,
      );

      await controller.removeAnswerOption(answer.id);

      expect(repository.items, isEmpty);
    });
  });
}

class _MemoryPracticeExamsRepository implements PracticeExamsRepository {
  final List<PracticeExam> items = [];

  @override
  Future<PracticeExam> addPracticeExam({
    required String examSectionId,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    final exam = PracticeExam(
      id: 'exam-${items.length + 1}',
      examSectionId: examSectionId,
      name: name,
      passingPercentage: passingPercentage,
      durationMinutes: durationMinutes,
      createdAt: DateTime(2026),
    );
    items.add(exam);
    return exam;
  }

  @override
  Future<List<PracticeExam>> getPracticeExamsBySectionId(
    String examSectionId,
  ) async {
    return items.where((item) => item.examSectionId == examSectionId).toList();
  }

  @override
  Future<void> removePracticeExam(String id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updatePracticeExam({
    required String id,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  }) async {
    final index = items.indexWhere((item) => item.id == id);
    final current = items[index];
    items[index] = PracticeExam(
      id: current.id,
      examSectionId: current.examSectionId,
      name: name,
      passingPercentage: passingPercentage,
      durationMinutes: durationMinutes,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );
  }

  @override
  Stream<List<PracticeExam>> watchPracticeExamsBySectionId(
    String examSectionId,
  ) {
    return Stream.value(
      items.where((item) => item.examSectionId == examSectionId).toList(),
    );
  }
}

class _MemoryPracticeExamQuestionsRepository
    implements PracticeExamQuestionsRepository {
  final List<PracticeExamQuestion> items = [];

  @override
  Future<PracticeExamQuestion> addQuestion({
    required String practiceExamId,
    required String markdownText,
    String? explanationMarkdown,
  }) async {
    final question = PracticeExamQuestion(
      id: 'question-${items.length + 1}',
      practiceExamId: practiceExamId,
      markdownText: markdownText,
      explanationMarkdown: explanationMarkdown,
      createdAt: DateTime(2026),
    );
    items.add(question);
    return question;
  }

  @override
  Future<List<PracticeExamQuestion>> getQuestionsByPracticeExamId(
    String practiceExamId,
  ) async {
    return items.where((item) => item.practiceExamId == practiceExamId).toList();
  }

  @override
  Future<void> removeQuestion(String id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? explanationMarkdown,
  }) async {
    final index = items.indexWhere((item) => item.id == id);
    final current = items[index];
    items[index] = PracticeExamQuestion(
      id: current.id,
      practiceExamId: current.practiceExamId,
      markdownText: markdownText,
      explanationMarkdown: explanationMarkdown,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );
  }

  @override
  Stream<List<PracticeExamQuestion>> watchQuestionsByPracticeExamId(
    String practiceExamId,
  ) {
    return Stream.value(
      items.where((item) => item.practiceExamId == practiceExamId).toList(),
    );
  }
}

class _MemoryPracticeExamAnswerOptionsRepository
    implements PracticeExamAnswerOptionsRepository {
  final List<PracticeExamAnswerOption> items = [];

  @override
  Future<PracticeExamAnswerOption> addAnswerOption({
    required String practiceExamQuestionId,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final answer = PracticeExamAnswerOption(
      id: 'answer-${items.length + 1}',
      practiceExamQuestionId: practiceExamQuestionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
      createdAt: DateTime(2026),
    );
    items.add(answer);
    return answer;
  }

  @override
  Future<List<PracticeExamAnswerOption>> getAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) async {
    return items
        .where(
          (item) =>
              item.practiceExamQuestionId == practiceExamQuestionId,
        )
        .toList();
  }

  @override
  Future<void> removeAnswerOption(String id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final index = items.indexWhere((item) => item.id == id);
    final current = items[index];
    items[index] = PracticeExamAnswerOption(
      id: current.id,
      practiceExamQuestionId: current.practiceExamQuestionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 1, 2),
    );
  }

  @override
  Stream<List<PracticeExamAnswerOption>> watchAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) {
    return Stream.value(
      items
          .where(
            (item) =>
                item.practiceExamQuestionId == practiceExamQuestionId,
          )
          .toList(),
    );
  }
}
