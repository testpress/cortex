import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/sentry_service.dart';

/// Abstract interface for launching video conference meetings.
abstract class MeetingService {
  /// Initializes and joins a meeting using the provided credentials.
  Future<void> joinMeeting({
    required String jwtToken,
    required String meetingNumber,
    required String password,
    required String displayName,
  });

  /// Configures Sentry logging on the meeting service dynamically.
  set sentryService(SentryService? service);
}

/// Registry to dynamically hold the active [MeetingService] instance.
/// This allows optional packages to self-register at startup.
class MeetingServiceRegistry {
  static MeetingService? _instance;
  static MeetingService? get instance => _instance;

  /// Registers a meeting service implementation.
  static void register(MeetingService service) {
    _instance = service;
  }
}

/// Reactive provider for the active [MeetingService].
/// Resolves dynamically to the registered service from the registry.
final meetingServiceProvider = Provider<MeetingService?>((ref) {
  final service = MeetingServiceRegistry.instance;
  if (service != null) {
    service.sentryService = ref.watch(sentryServiceProvider);
  }
  return service;
});
