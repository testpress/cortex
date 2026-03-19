import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/user_api_service.dart';
import '../repositories/user_repository.dart';
import 'profile_user_repository_provider.dart';

final profileUserApiServiceProvider = Provider<UserApiService>((ref) {
  final dio = ref.read(dioProvider);
  return UserApiService(dio);
});

final profileAuthProfileSyncProvider = FutureProvider<AuthProfileSyncContract>((
  ref,
) async {
  final userRepository = await ref.read(profileUserRepositoryProvider.future);
  final userApiService = ref.read(profileUserApiServiceProvider);
  return _ProfileAuthProfileSyncContract(
    repository: userRepository,
    apiService: userApiService,
  );
});

class _ProfileAuthProfileSyncContract implements AuthProfileSyncContract {
  _ProfileAuthProfileSyncContract({
    required UserRepository repository,
    required UserApiService apiService,
  }) : _repository = repository,
       _apiService = apiService;

  final UserRepository _repository;
  final UserApiService _apiService;

  @override
  Future<UserDto?> getCurrentUser() => _repository.getCurrentUser();

  @override
  Future<UserDto> refreshCurrentUser() async {
    final profile = await _apiService.fetchCurrentUser();
    await _repository.saveProfile(profile);
    return profile;
  }
}
