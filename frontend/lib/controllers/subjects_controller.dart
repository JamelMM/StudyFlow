import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';

final subjectsControllerProvider =
    AsyncNotifierProvider<SubjectsController, List<Subject>>(
      SubjectsController.new,
    );

class SubjectsController extends AsyncNotifier<List<Subject>> {
  @override
  Future<List<Subject>> build() async {
    final subjectsRepository = ref.watch(subjectsRepositoryProvider);

    return subjectsRepository.getSubjects();
  }

  Future<void> addSubject(String name) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.addSubject(name);

    ref.invalidateSelf();
  }

  Future<void> removeSubject(String id) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.removeSubject(id);

    ref.invalidateSelf();
  }

  Future<void> updateSubject({required String id, required String name}) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.updateSubject(id: id, name: name);

    ref.invalidateSelf();
  }
}
