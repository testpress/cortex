
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/user_repository.dart';
import '../repositories/forum_repository.dart';
import 'database_provider.dart';
import 'data_source_provider.dart';

part 'repository_providers.g.dart';



/// Provides the [UserRepository].
@Riverpod(keepAlive: true)
Future<UserRepository> userRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserRepository(db, source);
}

/// Provides the [ForumRepository].
@Riverpod(keepAlive: true)
Future<ForumRepository> forumRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return ForumRepository(db, source);
}




