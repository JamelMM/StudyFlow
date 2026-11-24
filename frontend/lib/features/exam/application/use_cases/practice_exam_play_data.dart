import 'package:frontend/features/exam/domain/models/practice_exam_answer_option.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_question.dart';

class PracticeExamPlayData {
  const PracticeExamPlayData({
    required this.questions,
    required this.answerOptionsByQuestionId,
  });

  final List<PracticeExamQuestion> questions;
  final Map<String, List<PracticeExamAnswerOption>> answerOptionsByQuestionId;
}
