import 'package:frontend/local/tostore/tostore_study_notes_repository.dart';
import 'package:frontend/local/tostore/tostore_topics_repository.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/local/tostore/tostore_subjects_repository.dart';
import 'package:frontend/local/tostore/tostore_quizzes_repository.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SubjectsRepository>(ToStoreSubjectsRepository());

  getIt.registerSingleton<TopicsRepository>(TostoreTopicsRepository());

  getIt.registerSingleton<StudyNotesRepository>(ToStoreStudyNotesRepository());

  getIt.registerSingleton<QuizzesRepository>(ToStoreQuizzesRepository());
}
