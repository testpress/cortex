import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'forum_repository.dart';
import 'user_progress_repository.dart';
import '../db/database_provider.dart';
import '../sources/data_source_provider.dart';

/// Provides the [UserProgressRepository].
final userProgressRepositoryProvider = FutureProvider<UserProgressRepository>((
  ref,
) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserProgressRepository(db, source);
});

/// Provides the [ForumRepository].
final forumRepositoryProvider = FutureProvider<ForumRepository>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return ForumRepository(db, source);
});
