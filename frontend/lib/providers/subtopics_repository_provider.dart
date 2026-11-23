import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_subtopics_repository.dart';
import 'package:frontend/repositories/contracts/subtopics_repository.dart';

final subtopicsRepositoryProvider = Provider<SubtopicsRepository>(
  (ref) => ToStoreSubtopicsRepository(),
);
