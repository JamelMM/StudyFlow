import 'package:frontend/models/subject.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalSubjectsRepository implements SubjectsRepository {
  final List<Subject> _subjects = [...exampleSubjects];

  @override
  Future<List<Subject>> getSubjects() async {
    return _subjects;
  }

  @override
  Future<void> addSubject(Subject subject) async {
    _subjects.add(subject);
  }
}
