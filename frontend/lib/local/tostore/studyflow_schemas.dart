import 'package:tostore/tostore.dart';

const subjectSchema = TableSchema(
  name: 'subjects',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
  ],
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
    FieldSchema(
      name: 'explanationMarkdown',
      type: DataType.text,
      nullable: true,
    ),
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

const examSectionSchema = TableSchema(
  name: 'exam_sections',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
  ],
);

final examTipSchema = TableSchema(
  name: 'exam_tips',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'examSectionId', type: DataType.text, nullable: false),
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_exam_tips_section',
      fields: ['examSectionId'],
      referencedTable: 'exam_sections',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final practiceExamSchema = TableSchema(
  name: 'practice_exams',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'examSectionId', type: DataType.text, nullable: false),
    FieldSchema(name: 'name', type: DataType.text, nullable: false),
    FieldSchema(
      name: 'passingPercentage',
      type: DataType.integer,
      nullable: false,
    ),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(
      name: 'durationMinutes',
      type: DataType.integer,
      nullable: true,
    ),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_practice_exams_exam_section',
      fields: ['examSectionId'],
      referencedTable: 'exam_sections',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final practiceExamQuestionSchema = TableSchema(
  name: 'practice_exam_questions',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(name: 'practiceExamId', type: DataType.text, nullable: false),
    FieldSchema(name: 'topicId', type: DataType.text, nullable: true),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
    FieldSchema(
      name: 'explanationMarkdown',
      type: DataType.text,
      nullable: true,
    ),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_practice_exam_questions_exam',
      fields: ['practiceExamId'],
      referencedTable: 'practice_exams',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.cascade,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
    ForeignKeySchema(
      name: 'fk_practice_exam_questions_topic',
      fields: ['topicId'],
      referencedTable: 'topics',
      referencedFields: ['id'],
      onDelete: ForeignKeyCascadeAction.setNull,
      onUpdate: ForeignKeyCascadeAction.cascade,
    ),
  ],
);

final practiceExamAnswerOptionSchema = TableSchema(
  name: 'practice_exam_answer_options',
  primaryKeyConfig: PrimaryKeyConfig(
    name: 'id',
    type: PrimaryKeyType.timestampBased,
  ),
  fields: [
    FieldSchema(
      name: 'practiceExamQuestionId',
      type: DataType.text,
      nullable: false,
    ),
    FieldSchema(name: 'markdownText', type: DataType.text, nullable: false),
    FieldSchema(name: 'createdAt', type: DataType.text, nullable: false),
    FieldSchema(name: 'updatedAt', type: DataType.text, nullable: true),
    FieldSchema(name: 'isCorrect', type: DataType.boolean, nullable: false),
  ],
  foreignKeys: [
    ForeignKeySchema(
      name: 'fk_practice_exam_answer_options_question',
      fields: ['practiceExamQuestionId'],
      referencedTable: 'practice_exam_questions',
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
  examSectionSchema,
  examTipSchema,
  practiceExamSchema,
  practiceExamQuestionSchema,
  practiceExamAnswerOptionSchema,
];
