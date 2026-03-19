import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import 'profile_user_repository_provider.dart';

final profileAuthProfileSyncProvider = FutureProvider<AuthProfileSyncContract>((
  ref,
) async {
  final userRepository = await ref.read(profileUserRepositoryProvider.future);
  return _ProfileAuthProfileSyncContract(repository: userRepository);
});

class _ProfileAuthProfileSyncContract implements AuthProfileSyncContract {
  _ProfileAuthProfileSyncContract({required UserRepository repository})
    : _repository = repository;

  final UserRepository _repository;

  @override
  Future<UserDto?> getCurrentUser() => _repository.getCurrentUser();

  @override
  Future<UserDto> refreshCurrentUser() => _repository.refreshCurrentUser();
}
