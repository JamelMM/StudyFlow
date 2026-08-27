import 'package:frontend/application/quiz/quiz_play_data.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/repositories/contracts/answer_options_repository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';

class LoadQuizPlayData {
  const LoadQuizPlayData({
    required this.questionsRepository,
    required this.answerOptionsRepository,
  });

  final QuestionsRepository questionsRepository;
  final AnswerOptionsRepository answerOptionsRepository;

  Future<QuizPlayData> call(String quizId) async {
    final questions = await questionsRepository.getQuestionsByQuizId(quizId);

    final answerOptionsByQuestionId = <String, List<AnswerOption>>{};

    for (final question in questions) {
      final answers = await answerOptionsRepository
          .getAnswerOptionsByQuestionId(question.id);

      answerOptionsByQuestionId[question.id] = answers;
    }

    return QuizPlayData(
      questions: questions,
      answerOptionsByQuestionId: answerOptionsByQuestionId,
    );
  }
}
