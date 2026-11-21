import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/practice_exam/load_practice_exam_play_data.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

void main() {
  group('LoadPracticeExamPlayData', () {
    test('loads questions and groups their answer options', () async {
      final firstQuestion = _question(id: 'question-1');
      final secondQuestion = _question(id: 'question-2');
      final firstQuestionAnswers = [
        _answer(id: 'answer-1', questionId: firstQuestion.id),
        _answer(id: 'answer-2', questionId: firstQuestion.id),
      ];
      final secondQuestionAnswers = [
        _answer(id: 'answer-3', questionId: secondQuestion.id),
        _answer(id: 'answer-4', questionId: secondQuestion.id),
      ];
      final loader = LoadPracticeExamPlayData(
        questionsRepository: _MemoryQuestionsRepository([
          firstQuestion,
          secondQuestion,
        ]),
        answerOptionsRepository: _MemoryAnswerOptionsRepository({
          firstQuestion.id: firstQuestionAnswers,
          secondQuestion.id: secondQuestionAnswers,
        }),
      );

      final playData = await loader('exam-1');

      expect(
        playData.questions.map((question) => question.id),
        unorderedEquals(['question-1', 'question-2']),
      );
      expect(
        playData.answerOptionsByQuestionId.keys,
        unorderedEquals(['question-1', 'question-2']),
      );
      expect(
        playData.answerOptionsByQuestionId['question-1']?.map(
          (answerOption) => answerOption.id,
        ),
        unorderedEquals(['answer-1', 'answer-2']),
      );
      expect(
        playData.answerOptionsByQuestionId['question-2']?.map(
          (answerOption) => answerOption.id,
        ),
        unorderedEquals(['answer-3', 'answer-4']),
      );
    });

    test('does not mutate repository lists while shuffling', () async {
      final question = _question(id: 'question-1');
      final questions = [question];
      final answerOptions = [
        _answer(id: 'answer-1', questionId: question.id),
        _answer(id: 'answer-2', questionId: question.id),
      ];
      final loader = LoadPracticeExamPlayData(
        questionsRepository: _MemoryQuestionsRepository(questions),
        answerOptionsRepository: _MemoryAnswerOptionsRepository({
          question.id: answerOptions,
        }),
      );

      final playData = await loader('exam-1');

      expect(identical(playData.questions, questions), isFalse);
      expect(
        identical(
          playData.answerOptionsByQuestionId[question.id],
          answerOptions,
        ),
        isFalse,
      );
    });
  });
}

PracticeExamQuestion _question({required String id}) {
  return PracticeExamQuestion(
    id: id,
    practiceExamId: 'exam-1',
    markdownText: 'Question $id',
    createdAt: DateTime(2026),
  );
}

PracticeExamAnswerOption _answer({
  required String id,
  required String questionId,
}) {
  return PracticeExamAnswerOption(
    id: id,
    practiceExamQuestionId: questionId,
    isCorrect: false,
    markdownText: 'Answer $id',
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
