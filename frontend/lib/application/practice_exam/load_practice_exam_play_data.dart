import 'package:frontend/application/practice_exam/practice_exam_play_data.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';

class LoadPracticeExamPlayData {
  const LoadPracticeExamPlayData({
    required this.questionsRepository,
    required this.answerOptionsRepository,
  });

  final PracticeExamQuestionsRepository questionsRepository;
  final PracticeExamAnswerOptionsRepository answerOptionsRepository;

  Future<PracticeExamPlayData> call(String practiceExamId) async {
    final loadedQuestions = await questionsRepository
        .getQuestionsByPracticeExamId(practiceExamId);
    final questions = [...loadedQuestions]..shuffle();
    final answerOptionsByQuestionId =
        <String, List<PracticeExamAnswerOption>>{};

    for (final question in questions) {
      final loadedAnswerOptions = await answerOptionsRepository
          .getAnswerOptionsByQuestionId(question.id);
      final answerOptions = [...loadedAnswerOptions]..shuffle();

      answerOptionsByQuestionId[question.id] = answerOptions;
    }

    return PracticeExamPlayData(
      questions: questions,
      answerOptionsByQuestionId: answerOptionsByQuestionId,
    );
  }
}
