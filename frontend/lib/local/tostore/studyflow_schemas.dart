import 'package:tostore/tostore.dart';

const subjectSchema = TableSchema(
  name: 'subjects',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [FieldSchema(name: 'name', type: DataType.text, nullable: false)],
);

final topicSchema = TableSchema(
  name: 'topics',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'subjectId', type: DataType.text, nullable: false),
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_topics_subject',
      fields: ['subjectId'],
      referencedTable: 'subjects',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final studyFlowSchemas = [subjectSchema, topicSchema];
