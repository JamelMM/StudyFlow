import 'package:frontend/models/answer_option.dart';
import 'package:frontend/models/question.dart';

class QuizPlayData {
  const QuizPlayData({
    required this.questions,
    required this.answerOptionsByQuestionId,
  });

  final List<Question> questions;
  final Map<String, List<AnswerOption>> answerOptionsByQuestionId;
}
