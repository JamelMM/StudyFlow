import 'package:frontend/repositories/contracts/answer_options_repository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';

class ValidateQuizCanStart {
  const ValidateQuizCanStart({
    required this.questionsRepository,
    required this.answerOptionsRepository,
  });

  final QuestionsRepository questionsRepository;
  final AnswerOptionsRepository answerOptionsRepository;

  Future<String?> call(
    String quizId, {
    Set<String>? selectedSubtopicIds,
  }) async {
    final allQuestions = await questionsRepository.getQuestionsByQuizId(quizId);
    final questions = selectedSubtopicIds == null
        ? allQuestions
        : allQuestions
              .where(
                (question) => selectedSubtopicIds.contains(question.subtopicId),
              )
              .toList();

    if (questions.isEmpty) {
      return selectedSubtopicIds == null
          ? 'Add at least one question before starting the quiz.'
          : 'The selected subtopics do not contain any questions.';
    }

    for (final question in questions) {
      final answers = await answerOptionsRepository
          .getAnswerOptionsByQuestionId(question.id);

      if (answers.isEmpty) {
        return 'Every question needs at least one answer.';
      }

      final correctAnswersCount = answers
          .where((answer) => answer.isCorrect)
          .length;

      if (correctAnswersCount == 0) {
        return 'Every question needs one correct answer.';
      }

      if (correctAnswersCount > 1) {
        return 'Every question can only have one correct answer.';
      }
    }

    return null;
  }
}
