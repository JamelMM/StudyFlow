import 'package:frontend/models/subject.dart';

abstract class SubjectsRepository {
  Future<List<Subject>> getSubjects();

  Future<Subject> addSubject(String name);
}
