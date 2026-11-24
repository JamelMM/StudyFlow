import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/seed_import/application/import_study_seed.dart';
import 'package:frontend/features/seed_import/application/study_seed_parser.dart';
import 'package:frontend/features/seed_import/application/study_seed_validation.dart';
import 'package:frontend/features/quiz/application/providers/answer_options_repository_provider.dart';
import 'package:frontend/features/quiz/application/providers/questions_repository_provider.dart';
import 'package:frontend/features/quiz/application/providers/quizzes_repository_provider.dart';
import 'package:frontend/features/study_content/application/providers/study_notes_repository_provider.dart';
import 'package:frontend/features/study_content/application/providers/subjects_repository_provider.dart';
import 'package:frontend/features/study_content/application/providers/topics_repository_provider.dart';
import 'package:frontend/features/study_content/application/providers/subtopics_repository_provider.dart';
import 'package:frontend/features/exam/application/providers/exam_sections_repository_provider.dart';
import 'package:frontend/features/exam/application/providers/exam_tips_repository_provider.dart';

final studySeedParserProvider = Provider<StudySeedParser>((ref) {
  return const StudySeedParser();
});

final studySeedValidationProvider = Provider<StudySeedValidation>((ref) {
  return const StudySeedValidation();
});

final importStudySeedProvider = Provider<ImportStudySeed>((ref) {
  return ImportStudySeed(
    parser: ref.watch(studySeedParserProvider),
    validation: ref.watch(studySeedValidationProvider),
    subjectsRepository: ref.watch(subjectsRepositoryProvider),
    topicsRepository: ref.watch(topicsRepositoryProvider),
    subtopicsRepository: ref.watch(subtopicsRepositoryProvider),
    studyNotesRepository: ref.watch(studyNotesRepositoryProvider),
    quizzesRepository: ref.watch(quizzesRepositoryProvider),
    questionsRepository: ref.watch(questionsRepositoryProvider),
    answerOptionsRepository: ref.watch(answerOptionsRepositoryProvider),
    examSectionsRepository: ref.watch(examSectionsRepositoryProvider),
    examTipsRepository: ref.watch(examTipsRepositoryProvider),
  );
});
