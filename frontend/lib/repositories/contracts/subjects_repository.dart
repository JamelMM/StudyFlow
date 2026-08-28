import 'package:frontend/models/subject.dart';

abstract class SubjectsRepository {
  Future<List<Subject>> getSubjects();

  Stream<List<Subject>> watchSubjects();

  Future<Subject> addSubject(String name);

  Future<void> removeSubject(String id);

  Future<void> updateSubject({required String id, required String name});
}
