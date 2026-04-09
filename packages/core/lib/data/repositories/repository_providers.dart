import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'forum_repository.dart';
import '../db/database_provider.dart';
import '../sources/data_source_provider.dart';

part 'repository_providers.g.dart';

/// Provides the [ForumRepository].
@Riverpod(keepAlive: true)
Future<ForumRepository> forumRepository(ForumRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return ForumRepository(db, source);
}
