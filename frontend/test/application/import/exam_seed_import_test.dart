import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/import/import_study_seed.dart';
import 'package:frontend/application/import/study_seed_parser.dart';
import 'package:frontend/application/import/study_seed_validation.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/repositories/contracts/answer_options_repository.dart';
import 'package:frontend/repositories/contracts/exam_sections_repository.dart';
import 'package:frontend/repositories/contracts/exam_tips_repository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';

void main() {
  test('imports an exam-only seed with Markdown tips', () async {
    final examSectionsRepository = _MemoryExamSectionsRepository();
    final examTipsRepository = _MemoryExamTipsRepository();
    final unusedRepositories = _UnusedStudyRepositories();
    final importer = ImportStudySeed(
      parser: const StudySeedParser(),
      validation: const StudySeedValidation(),
      subjectsRepository: unusedRepositories,
      topicsRepository: unusedRepositories,
      studyNotesRepository: unusedRepositories,
      quizzesRepository: unusedRepositories,
      questionsRepository: unusedRepositories,
      answerOptionsRepository: unusedRepositories,
      examSectionsRepository: examSectionsRepository,
      examTipsRepository: examTipsRepository,
    );

    await importer.call('''
      {
        "version": 1,
        "examSections": [
          {
            "name": "AP2",
            "tips": [
              {
                "name": "Time management",
                "markdownText": "## Before starting\\n\\nPlan your time."
              },
              {
                "name": "Final check",
                "markdownText": "Check every answer."
              }
            ]
          }
        ]
      }
    ''');

    expect(examSectionsRepository.items, hasLength(1));
    expect(examSectionsRepository.items.single.name, 'AP2');
    expect(examTipsRepository.items, hasLength(2));
    expect(
      examTipsRepository.items.first.markdownText,
      '## Before starting\n\nPlan your time.',
    );
  });

  test('keeps the previous subjects-only seed format valid', () {
    const parser = StudySeedParser();
    const validation = StudySeedValidation();
    final seed = parser.parse('''
      {
        "version": 1,
        "subjects": [
          {
            "name": "WISO",
            "topics": [
              {
                "name": "Arbeitsrecht",
                "studyNotes": [],
                "quiz": null
              }
            ]
          }
        ]
      }
    ''');

    expect(seed.examSections, isEmpty);
    expect(validation.validate(seed), isNull);
  });
}

class _MemoryExamSectionsRepository implements ExamSectionsRepository {
  final List<ExamSection> items = [];

  @override
  Future<ExamSection> addExamSection(String name) async {
    final item = ExamSection(
      id: 'section-${items.length + 1}',
      name: name,
      createdAt: DateTime(2026),
    );
    items.add(item);
    return item;
  }

  @override
  Future<List<ExamSection>> getExamSections() async => List.of(items);

  @override
  Future<void> removeExamSection(String id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updateExamSection({
    required String id,
    required String name,
  }) async {}

  @override
  Stream<List<ExamSection>> watchExamSections() => Stream.value(items);
}

class _MemoryExamTipsRepository implements ExamTipsRepository {
  final List<ExamTip> items = [];

  @override
  Future<ExamTip> addExamTip({
    required String examSectionId,
    required String name,
    required String markdownText,
  }) async {
    final item = ExamTip(
      id: 'tip-${items.length + 1}',
      examSectionId: examSectionId,
      name: name,
      markdownText: markdownText,
      createdAt: DateTime(2026),
    );
    items.add(item);
    return item;
  }

  @override
  Future<List<ExamTip>> getExamTipsBySectionId(String examSectionId) async {
    return items
        .where((item) => item.examSectionId == examSectionId)
        .toList();
  }

  @override
  Future<void> removeExamTip(String id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updateExamTip({
    required String id,
    required String name,
    required String markdownText,
  }) async {}

  @override
  Stream<List<ExamTip>> watchExamTipsBySectionId(String examSectionId) {
    return Stream.value(
      items.where((item) => item.examSectionId == examSectionId).toList(),
    );
  }
}

class _UnusedStudyRepositories
    implements
        SubjectsRepository,
        TopicsRepository,
        StudyNotesRepository,
        QuizzesRepository,
        QuestionsRepository,
        AnswerOptionsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('Study repositories are not used by this test.');
  }
}
