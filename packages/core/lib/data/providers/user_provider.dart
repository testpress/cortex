import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/db/app_database.dart';
import 'package:core/data/auth/auth_provider.dart';
import 'package:core/data/db/database_provider.dart';
import 'package:core/data/sources/data_source_provider.dart';
import '../repositories/user_repository.dart';
import '../services/sentry_service.dart';

part 'user_provider.g.dart';

@riverpod
Future<UserRepository> userRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserRepository(db, source);
}

/// Reactive provider that exposes the current user's profile metadata from the database.
@riverpod
Stream<UsersTableData?> user(UserRef ref) async* {
  final userRepository = await ref.watch(userRepositoryProvider.future);
  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;

  if (!isLoggedIn) {
    ref.read(sentryServiceProvider).clearUserContext();
    yield null;
    return;
  }

  yield* userRepository.watchCurrentUser().map((user) {
    if (user != null) {
      ref
          .read(sentryServiceProvider)
          .setUserContext(
            id: user.id.toString(),
            username: user.username,
            email: user.email,
          );
    }
    return user;
  });
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
