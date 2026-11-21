import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

const minimumPracticeExamAnswerOptions = 4;

class ValidatePracticeExamCanStart {
  const ValidatePracticeExamCanStart({
    required this.questionsRepository,
    required this.answerOptionsRepository,
  });

  final PracticeExamQuestionsRepository questionsRepository;
  final PracticeExamAnswerOptionsRepository answerOptionsRepository;

  Future<String?> call(String practiceExamId) async {
    final questions = await questionsRepository.getQuestionsByPracticeExamId(
      practiceExamId,
    );

    if (questions.isEmpty) {
      return 'Add at least one question before starting the practice exam.';
    }

    for (final question in questions) {
      final answerOptions = await answerOptionsRepository
          .getAnswerOptionsByQuestionId(question.id);

      if (answerOptions.length < minimumPracticeExamAnswerOptions) {
        return 'Every question needs at least '
            '$minimumPracticeExamAnswerOptions answer options.';
      }

      final correctAnswersCount = answerOptions
          .where((answerOption) => answerOption.isCorrect)
          .length;

      if (correctAnswersCount != 1) {
        return 'Every question needs exactly one correct answer.';
      }
    }

    return null;
  }
}
