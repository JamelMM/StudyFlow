import 'package:frontend/models/subject.dart';

abstract class SubjectsRepository {
  Future<List<Subject>> getSubjects();

  Future<void> addSubject(Subject subject);
}
