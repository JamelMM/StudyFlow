import 'package:frontend/models/subject.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/data/example_data.dart';

class LocalSubjectsRepository implements SubjectsRepository {
  final List<Subject> _subjects = [...exampleSubjects];

  @override
  List<Subject> getSubjects() {
    return _subjects;
  }

  @override
  void addSubject(Subject subject) {
    _subjects.add(subject);
  }
}
