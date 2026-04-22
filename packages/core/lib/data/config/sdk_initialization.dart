import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import '../auth/auth_provider.dart';
import 'app_config.dart';

part 'sdk_initialization.g.dart';

/// Provider that handles the initialization of 3rd party SDKs (like TPStreams).
/// This is centralized in core so all domain packages benefit.
@riverpod
Future<void> sdkInitialization(SdkInitializationRef ref) async {
  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;

  // Initialize Testpress SDK for player
  final uri = Uri.parse(AppConfig.apiBaseUrl);
  final subdomain = uri.host.split('.').first;

  String? authToken;
  if (isLoggedIn) {
    authToken = await ref.read(authLocalDataSourceProvider).getToken();
  }

  TestpressSDK.initialize(
    subdomain: subdomain,
    authToken: authToken,
  );
}
