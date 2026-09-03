import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/import/import_study_seed.dart';
import 'package:frontend/application/import/study_seed_parser.dart';
import 'package:frontend/application/import/study_seed_validation.dart';
import 'package:frontend/providers/answer_options_repository_provider.dart';
import 'package:frontend/providers/questions_repository_provider.dart';
import 'package:frontend/providers/quizzes_repository_provider.dart';
import 'package:frontend/providers/study_notes_repository_provider.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';
import 'package:frontend/providers/topics_repository_provider.dart';

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
    studyNotesRepository: ref.watch(studyNotesRepositoryProvider),
    quizzesRepository: ref.watch(quizzesRepositoryProvider),
    questionsRepository: ref.watch(questionsRepositoryProvider),
    answerOptionsRepository: ref.watch(answerOptionsRepositoryProvider),
  );
});
