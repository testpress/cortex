import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/user_api_service.dart';
import '../repositories/user_repository.dart';

final profileUserRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final apiService = UserApiService(ref.read(dioProvider));
  return UserRepository(db, apiService);
});
