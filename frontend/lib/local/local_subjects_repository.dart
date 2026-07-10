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
  Future<Subject> addSubject(String name) async {
    final newSubject = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    _subjects.add(newSubject);

    return newSubject;
  }
}
