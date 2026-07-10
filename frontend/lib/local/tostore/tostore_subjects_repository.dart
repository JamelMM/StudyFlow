import 'package:frontend/models/subject.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/local/tostore/studyflow_database.dart';

class ToStoreSubjectsRepository implements SubjectsRepository {
  static const _tableName = 'subjects';

  @override
  Future<List<Subject>> getSubjects() async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data.map((row) {
      return Subject(id: row['id'].toString(), name: row['name'].toString());
    }).toList();
  }

  @override
  Future<Subject> addSubject(String name) async {
    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'name': name,
    });

    if (!result.isSuccess) {
      throw Exception('Could not create subject.');
    }

    final generatedId = result.successKeys.first.toString();

    return Subject(id: generatedId, name: name);
  }
}
