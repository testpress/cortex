import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/app_config.dart';
import '../providers/user_provider.dart';
import '../../network/network_utils.dart';

part 'sentry_service.g.dart';

class SentryService {
  Future<void> initialize() async {
    if (AppConfig.sentryDsn.isNotEmpty) {
      // Get package info to explicitly set the release version
      final packageInfo = await PackageInfo.fromPlatform();

      await SentryFlutter.init((options) {
        options.dsn = AppConfig.sentryDsn;

        // Explicitly set release (app version). Sentry typically does this
        // automatically, but this guarantees it's captured in the exact format.
        options.release =
            '${packageInfo.packageName}@${packageInfo.version}+${packageInfo.buildNumber}';

        // Differentiate between dev and prod environments
        const isDebug = bool.fromEnvironment('dart.vm.product') == false;
        options.environment = isDebug ? 'development' : 'production';
      });

      Sentry.configureScope((scope) {
        scope.setTag('domain', AppConfig.apiBaseUrl);
      });

      // Attach to the global network error handler
      onNetworkErrorCapture = (error, stackTrace) {
        captureException(error, stackTrace: stackTrace);
      };
    }
  }

  /// Adds a breadcrumb to track user actions or system events leading up to an error.
  void addBreadcrumb({
    required String message,
    String? category,
    SentryLevel? level,
    Map<String, dynamic>? data,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level,
        data: data,
      ),
    );
  }

  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    SentryLevel? level,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (level != null) scope.level = level;
        if (tags != null) {
          tags.forEach((key, value) {
            scope.setTag(key, value);
          });
        }
        if (contexts != null) {
          contexts.forEach((key, value) {
            scope.setContexts(key, value);
          });
        }
      },
    );
  }

  Future<void> captureMessage(
    String message, {
    SentryLevel? level,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
  }) async {
    await Sentry.captureMessage(
      message,
      level: level,
      withScope: (scope) {
        if (tags != null) {
          tags.forEach((key, value) {
            scope.setTag(key, value);
          });
        }
        if (contexts != null) {
          contexts.forEach((key, value) {
            scope.setContexts(key, value);
          });
        }
      },
    );
  }
}

@riverpod
SentryService sentryService(SentryServiceRef ref) {
  final service = SentryService();

  // Automatically sync Sentry's user context with the app's current user
  ref.listen(userProvider, (previous, next) {
    final user = next.valueOrNull;
    if (user != null) {
      Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(
            id: user.id.toString(),
            username: user.username,
            email: user.email,
          ),
        );
      });
    } else {
      Sentry.configureScope((scope) {
        scope.setUser(null);
      });
    }
  });

  return service;
}
