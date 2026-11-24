import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tostore/tostore.dart';

import 'studyflow_schemas.dart';

class StudyFlowDatabase {
  static const _databaseName = 'studyflow_v2';
  static ToStore? _db;

  static ToStore get db {
    final instance = _db;

    if (instance == null) {
      throw StateError('StudyFlowDatabase has not been initialized.');
    }

    return instance;
  }

  static Future<void> initialize() async {
    final documentDirectory = await getApplicationDocumentsDirectory();

    final dbPath = p.join(documentDirectory.path, _databaseName);

    _db = await ToStore.open(
      dbPath: dbPath,
      dbName: _databaseName,
      schemas: studyFlowSchemas,
    );
  }
}
