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

final studyNoteSchema = TableSchema(
  name: 'study_notes',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'topicId', type: DataType.text, nullable: false),
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_study_notes_topic',
      fields: ['topicId'],
      referencedTable: 'topics',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final quizSchema = TableSchema(
  name: 'quizzes',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'topicId', type: DataType.text, nullable: false),
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_quizzes_topic',
      fields: ['topicId'],
      referencedTable: 'topics',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final questionSchema = TableSchema(
  name: 'questions',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'quizId', type: DataType.text, nullable: false),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_question_quiz',
      fields: ['quizId'],
      referencedTable: 'quizzes',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final answerOptionSchema = TableSchema(
  name: 'answer_options',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'questionId', type: DataType.text, nullable: false),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'isCorrect', type: DataType.boolean, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_answer_options_question',
      fields: ['questionId'],
      referencedTable: 'questions',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final studyFlowSchemas = [
  subjectSchema,
  topicSchema,
  studyNoteSchema,
  quizSchema,
  questionSchema,
  answerOptionSchema,
];
