import 'package:tostore/tostore.dart';

const subjectSchema = TableSchema(
  name: 'subjects',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [FieldSchema(name: 'name', type: DataType.text, nullable: false)],
);

const studyFlowSchemas = [subjectSchema];
