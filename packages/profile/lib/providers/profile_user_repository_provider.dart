import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';

final profileUserRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return UserRepository(db);
});
