import 'package:frontend/features/exam/application/use_cases/practice_exam_play_data.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_answer_option.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_answer_options_repository.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_questions_repository.dart';

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
