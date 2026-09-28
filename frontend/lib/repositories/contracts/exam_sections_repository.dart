import 'package:frontend/models/exam_section.dart';

abstract class ExamSectionsRepository {
  Future<List<ExamSection>> getExamSections();

  Stream<List<ExamSection>> watchExamSections();

  Future<ExamSection> addExamSection(String name);

  Future<void> removeExamSection(String id);

  Future<void> updateExamSection({required String id, required String name});
}
