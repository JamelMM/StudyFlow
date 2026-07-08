import 'package:frontend/local/local_topics_repository.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/local/local_subjects_repository.dart';
import 'package:frontend/local/local_study_notes_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SubjectsRepository>(LocalSubjectsRepository());

  getIt.registerSingleton<TopicsRepository>(LocalTopicRepository());

  getIt.registerSingleton<StudyNotesRepository>(LocalStudyNotesRepository());
}
