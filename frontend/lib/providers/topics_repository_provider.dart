import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_topics_repository.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';

final topicsRepositoryProvider = Provider<TopicsRepository>((ref) {
  return ToStoreTopicsRepository();
});
