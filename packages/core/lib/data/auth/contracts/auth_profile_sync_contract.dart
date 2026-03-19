import 'package:core/data/data.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthProfileSyncContract {
  Future<UserDto?> getCurrentUser();
  Future<UserDto> refreshCurrentUser();
}

final authProfileSyncContractProvider = FutureProvider<AuthProfileSyncContract>((
  ref,
) async {
  final db = await ref.read(appDatabaseProvider.future);
  final apiService = ref.read(authApiServiceProvider);
  return _CoreAuthProfileSyncContract(db: db, apiService: apiService);
});

class _CoreAuthProfileSyncContract implements AuthProfileSyncContract {
  _CoreAuthProfileSyncContract({
    required AppDatabase db,
    required AuthApiService apiService,
  }) : _db = db,
       _apiService = apiService;

  final AppDatabase _db;
  final AuthApiService _apiService;

  @override
  Future<UserDto?> getCurrentUser() async {
    final cached = await _db.getAnyUser();
    if (cached == null) return null;
    return UserDto(
      id: cached.id,
      name: cached.name,
      email: cached.email,
      phone: cached.phone,
      avatar: cached.avatar,
      isPro: cached.isPro,
      joinedDate: cached.joinedDate,
    );
  }

  @override
  Future<UserDto> refreshCurrentUser() async {
    final profile = await _apiService.fetchProfile();
    await _db.upsertUser(
      UsersTableCompanion.insert(
        id: profile.id,
        name: profile.name,
        email: Value(profile.email),
        phone: Value(profile.phone),
        avatar: Value(profile.avatar),
        isPro: Value(profile.isPro),
        joinedDate: Value(profile.joinedDate),
      ),
    );
    return profile;
  }
}
