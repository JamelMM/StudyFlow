import 'package:frontend/models/subject.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/local/tostore/studyflow_database.dart';

class ToStoreSubjectsRepository implements SubjectsRepository {
  static const _tableName = 'subjects';

  @override
  Future<List<Subject>> getSubjects() async {
    final result = await StudyFlowDatabase.db.query(_tableName);

    return result.data.map((row) {
      return Subject(
        id: row['id'].toString(),
        name: row['name'].toString(),
        createdAt: DateTime.parse(row['createdAt'].toString()),
      );
    }).toList();
  }

  @override
  Stream<List<Subject>> watchSubjects() {
    return StudyFlowDatabase.db.query(_tableName).watch().map((rows) {
      return rows.map((row) {
        return Subject(
          id: row['id'].toString(),
          name: row['name'].toString(),
          createdAt: DateTime.parse(row['createdAt'].toString()),
        );
      }).toList();
    });
  }

  @override
  Future<Subject> addSubject(String name) async {
    final createdAt = DateTime.now();

    final result = await StudyFlowDatabase.db.insert(_tableName, {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    });

    if (!result.isSuccess) {
      throw Exception('Could not create subject.');
    }

    final generatedId = result.successKeys.first.toString();

    return Subject(id: generatedId, name: name, createdAt: createdAt);
  }

  @override
  Future<void> removeSubject(String id) async {
    final result = await StudyFlowDatabase.db
        .delete(_tableName)
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not delete subject.');
    }
  }

  @override
  Future<void> updateSubject({required String id, required String name}) async {
    final updatedAt = DateTime.now();

    final result = await StudyFlowDatabase.db
        .update(_tableName, {
          'name': name,
          'updatedAt': updatedAt.toIso8601String(),
        })
        .where('id', '=', id);

    if (!result.isSuccess) {
      throw Exception('Could not update subject.');
    }
  }
}
