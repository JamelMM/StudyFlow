import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/practice_exam/validate_practice_exam_can_start.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

void main() {
  group('ValidatePracticeExamCanStart', () {
    test('rejects an exam without questions', () async {
      final validator = _createValidator();

      final error = await validator('exam-1');

      expect(
        error,
        'Add at least one question before starting the practice exam.',
      );
    });

    test('rejects a question with fewer than four answer options', () async {
      final question = _question();
      final validator = _createValidator(
        questions: [question],
        answerOptionsByQuestionId: {
          question.id: [
            _answer(id: 'answer-1', isCorrect: true),
            _answer(id: 'answer-2'),
            _answer(id: 'answer-3'),
          ],
        },
      );

      final error = await validator('exam-1');

      expect(error, 'Every question needs at least 4 answer options.');
    });

    test('rejects a question without a correct answer', () async {
      final question = _question();
      final validator = _createValidator(
        questions: [question],
        answerOptionsByQuestionId: {
          question.id: [
            _answer(id: 'answer-1'),
            _answer(id: 'answer-2'),
            _answer(id: 'answer-3'),
            _answer(id: 'answer-4'),
          ],
        },
      );

      final error = await validator('exam-1');

      expect(error, 'Every question needs exactly one correct answer.');
    });

    test('rejects a question with multiple correct answers', () async {
      final question = _question();
      final validator = _createValidator(
        questions: [question],
        answerOptionsByQuestionId: {
          question.id: [
            _answer(id: 'answer-1', isCorrect: true),
            _answer(id: 'answer-2', isCorrect: true),
            _answer(id: 'answer-3'),
            _answer(id: 'answer-4'),
          ],
        },
      );

      final error = await validator('exam-1');

      expect(error, 'Every question needs exactly one correct answer.');
    });

    test('accepts every question with four options and one correct', () async {
      final firstQuestion = _question();
      final secondQuestion = _question(id: 'question-2');
      final validator = _createValidator(
        questions: [firstQuestion, secondQuestion],
        answerOptionsByQuestionId: {
          firstQuestion.id: [
            _answer(id: 'answer-1', isCorrect: true),
            _answer(id: 'answer-2'),
            _answer(id: 'answer-3'),
            _answer(id: 'answer-4'),
          ],
          secondQuestion.id: [
            _answer(id: 'answer-5', questionId: secondQuestion.id),
            _answer(
              id: 'answer-6',
              questionId: secondQuestion.id,
              isCorrect: true,
            ),
            _answer(id: 'answer-7', questionId: secondQuestion.id),
            _answer(id: 'answer-8', questionId: secondQuestion.id),
            _answer(id: 'answer-9', questionId: secondQuestion.id),
          ],
        },
      );

      final error = await validator('exam-1');

      expect(error, isNull);
    });
  });
}

ValidatePracticeExamCanStart _createValidator({
  List<PracticeExamQuestion> questions = const [],
  Map<String, List<PracticeExamAnswerOption>> answerOptionsByQuestionId =
      const {},
}) {
  return ValidatePracticeExamCanStart(
    questionsRepository: _MemoryQuestionsRepository(questions),
    answerOptionsRepository: _MemoryAnswerOptionsRepository(
      answerOptionsByQuestionId,
    ),
  );
}

PracticeExamQuestion _question({String id = 'question-1'}) {
  return PracticeExamQuestion(
    id: id,
    practiceExamId: 'exam-1',
    markdownText: 'Question',
    createdAt: DateTime(2026),
  );
}

PracticeExamAnswerOption _answer({
  required String id,
  String questionId = 'question-1',
  bool isCorrect = false,
}) {
  return PracticeExamAnswerOption(
    id: id,
    practiceExamQuestionId: questionId,
    isCorrect: isCorrect,
    markdownText: 'Answer',
    createdAt: DateTime(2026),
  );
}

class _MemoryQuestionsRepository implements PracticeExamQuestionsRepository {
  const _MemoryQuestionsRepository(this.questions);

  final List<PracticeExamQuestion> questions;

  @override
  Future<List<PracticeExamQuestion>> getQuestionsByPracticeExamId(
    String practiceExamId,
  ) async {
    return questions
        .where((question) => question.practiceExamId == practiceExamId)
        .toList();
  }

  @override
  Future<PracticeExamQuestion> addQuestion({
    required String practiceExamId,
    required String markdownText,
    String? topicId,
    String? explanationMarkdown,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeQuestion(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? topicId,
    String? explanationMarkdown,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<PracticeExamQuestion>> watchQuestionsByPracticeExamId(
    String practiceExamId,
  ) {
    throw UnimplementedError();
  }
}

class _MemoryAnswerOptionsRepository
    implements PracticeExamAnswerOptionsRepository {
  const _MemoryAnswerOptionsRepository(this.answerOptionsByQuestionId);

  final Map<String, List<PracticeExamAnswerOption>> answerOptionsByQuestionId;

  @override
  Future<List<PracticeExamAnswerOption>> getAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) async {
    return answerOptionsByQuestionId[practiceExamQuestionId] ?? const [];
  }

  @override
  Future<PracticeExamAnswerOption> addAnswerOption({
    required String practiceExamQuestionId,
    required String markdownText,
    required bool isCorrect,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAnswerOption(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<PracticeExamAnswerOption>> watchAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  ) {
    throw UnimplementedError();
  }
}
