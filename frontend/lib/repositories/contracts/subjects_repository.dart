import 'package:frontend/models/subject.dart';

abstract class SubjectsRepository {
  List<Subject> getSubjects();

  void addSubject(Subject subject);
}
