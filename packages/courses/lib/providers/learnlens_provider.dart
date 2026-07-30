import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../network/learnlens_network_client.dart';
import '../repositories/learnlens_repository.dart';

part 'learnlens_provider.g.dart';

/// Provider for the singleton [LearnLensNetworkClient] instance.
@riverpod
LearnLensNetworkClient learnLensNetworkClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return LearnLensNetworkClient(
    dio,
    () async {
      final userIdAsync = ref.read(userIdProvider);
      return userIdAsync.valueOrNull ?? await ref.read(userIdProvider.future);
    },
  );
}

/// Provider for the singleton [LearnLensRepository] instance.
@riverpod
LearnLensRepository learnLensRepository(Ref ref) {
  final networkClient = ref.watch(learnLensNetworkClientProvider);
  final dataSource = ref.watch(dataSourceProvider);
  return LearnLensRepository(networkClient, dataSource);
}

@riverpod
class LearnlensSession extends _$LearnlensSession {
  @override
  FutureOr<Map<String, dynamic>?> build(int contentId) async {
    final repository = ref.read(learnLensRepositoryProvider);
    try {
      final response = await repository.createSession(contentId);
      return response;
    } catch (e, stack) {
      debugPrint(
          'Error creating LearnLens session for contentId $contentId: $e\n$stack');
      return null;
    }
  }

  /// Refreshes the session token manually, useful on 401 error from LearnLens.
  Future<void> refreshSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(learnLensRepositoryProvider);
      return await repository.createSession(contentId);
    });
  }
}
