import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';

final subjectsControllerProvider = Provider<SubjectsController>((ref) {
  final subjectsRepository = ref.watch(subjectsRepositoryProvider);

  return SubjectsController(subjectsRepository);
});

class SubjectsController {
  const SubjectsController(this.subjectsRepository);

  final SubjectsRepository subjectsRepository;

  Future<void> addSubject(String name) async {
    await subjectsRepository.addSubject(name);
  }

  Future<void> removeSubject(String id) async {
    await subjectsRepository.removeSubject(id);
  }

  Future<void> updateSubject({required String id, required String name}) async {
    await subjectsRepository.updateSubject(id: id, name: name);
  }
}
