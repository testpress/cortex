import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';

part 'initialization_provider.g.dart';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@Riverpod(keepAlive: true)
Future<void> appInitialization(AppInitializationRef ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final userProgressRepo = await ref.watch(userProgressRepositoryProvider.future);

  // Ensure 3rd party SDKs (TPStreams, etc) are initialized via core
  await ref.watch(sdkInitializationProvider.future);


  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;
  if (!isLoggedIn) return;

  // Initialize core data in background
  try {
    // Refresh user profile and progress to see what was recently completed
    // This allows the Resume Card to find the most recent lesson in the fully-populated DB.
    final user = await userRepo.refreshProfile();
    await userProgressRepo.refreshProgress(user.id);
  } catch (e) {
    // Initialization errors are handled here or surfaced to the listener
    // We don't rethrow here to allow the app to start even if profile/progress refresh fails.
  }
}
