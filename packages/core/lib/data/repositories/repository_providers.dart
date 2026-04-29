import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_progress_repository.dart';
import '../db/database_provider.dart';
import '../sources/data_source_provider.dart';

part 'repository_providers.g.dart';

/// Provides the [UserProgressRepository].
@Riverpod(keepAlive: true)
Future<UserProgressRepository> userProgressRepository(UserProgressRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserProgressRepository(db, source);
}
