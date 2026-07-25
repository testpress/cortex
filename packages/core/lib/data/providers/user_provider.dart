import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/db/app_database.dart';
import 'package:core/data/db/database_provider.dart';
import 'package:core/data/sources/data_source_provider.dart';
import '../repositories/user_repository.dart';

part 'user_provider.g.dart';

@riverpod
Future<UserRepository> userRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserRepository(db, source);
}

/// Reactive provider that exposes the current user's profile metadata from the database.
/// NOTE: Do NOT watch `authProvider` here to check login state. `Auth.logout` triggers
/// the `appResetUseCase` which purges the database, naturally clearing this stream.
/// If this provider watches `authProvider`, it creates a circular dependency during logout
/// (authProvider -> appResetUseCaseProvider -> sentryServiceProvider -> userProvider -> authProvider).
@riverpod
Stream<UsersTableData?> user(UserRef ref) async* {
  final userRepository = await ref.watch(userRepositoryProvider.future);
  yield* userRepository.watchCurrentUser();
}

/// Controller used to trigger profile-related actions like updates.
@riverpod
class UserActionsController extends _$UserActionsController {
  @override
  void build() {}

  /// Persists profile updates to the backend and updates the local cache.
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? photo,
  }) async {
    final userRepository = await ref.read(userRepositoryProvider.future);

    await userRepository.updateProfile({
      'first_name': ?firstName,
      'last_name': ?lastName,
      'phone': ?phone,
      'photo': ?photo,
    });
  }
}
