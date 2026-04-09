import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/db/app_database.dart';
import 'package:core/data/auth/auth_provider.dart';
import 'profile_providers.dart';

part 'user_provider.g.dart';

/// Reactive provider that exposes the current user's profile metadata from the database.
/// Automatically triggers a background refresh from the network whenever it's watched.
@riverpod
Stream<UsersTableData?> user(UserRef ref) async* {
  final userRepository = await ref.watch(userRepositoryProvider.future);
  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;

  if (!isLoggedIn) {
    yield null;
    return;
  }

  // Refresh the profile in the background - the stream will update once it's saved.
  userRepository.refreshProfile().ignore();

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
