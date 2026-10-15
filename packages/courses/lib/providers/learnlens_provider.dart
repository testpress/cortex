import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'learnlens_provider.g.dart';

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
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
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
