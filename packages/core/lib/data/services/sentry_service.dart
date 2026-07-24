import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/app_config.dart';
import '../../network/network_utils.dart';

part 'sentry_service.g.dart';

/// Application-agnostic error levels for logging
enum AppErrorLevel { info, warning, error, fatal, debug }

extension AppErrorLevelMapper on AppErrorLevel {
  SentryLevel get toSentryLevel {
    switch (this) {
      case AppErrorLevel.info:
        return SentryLevel.info;
      case AppErrorLevel.warning:
        return SentryLevel.warning;
      case AppErrorLevel.error:
        return SentryLevel.error;
      case AppErrorLevel.fatal:
        return SentryLevel.fatal;
      case AppErrorLevel.debug:
        return SentryLevel.debug;
    }
  }
}

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

  /// Returns a navigation observer to track routing breadcrumbs without exposing Sentry types directly
  static NavigatorObserver createNavigatorObserver() =>
      SentryNavigatorObserver();

  /// Adds a breadcrumb to track user actions or system events leading up to an error.
  void addBreadcrumb({
    required String message,
    String? category,
    AppErrorLevel? level,
    Map<String, dynamic>? data,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level?.toSentryLevel,
        data: data,
      ),
    );
  }

  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    AppErrorLevel? level,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (level != null) scope.level = level.toSentryLevel;
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
    AppErrorLevel? level,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
  }) async {
    await Sentry.captureMessage(
      message,
      level: level?.toSentryLevel,
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

  void setUserContext({required String id, String? username, String? email}) {
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: id, username: username, email: email));
    });
  }

  void clearUserContext() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }
}

@Riverpod(keepAlive: true)
SentryService sentryService(SentryServiceRef ref) {
  final service = SentryService();

  return service;
}
