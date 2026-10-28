import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/app_config.dart';
import '../providers/user_provider.dart';
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
  Future<void>? _initialization;

  Future<void> initialize() async {
    final initialization = _initialization ??= _initialize();
    await initialization;
  }

  Future<void> _initialize() async {
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

        // Filter out expected client conditions (offline, 4xx client errors)
        options.beforeSend = (event, hint) {
          if (shouldIgnoreSentryEvent(event)) {
            return null;
          }
          return event;
        };
      });

      Sentry.configureScope((scope) {
        scope.setTag('domain', AppConfig.apiBaseUrl);
        scope.setTag('app_name', packageInfo.appName);
        scope.setTag('app_version', packageInfo.version);
        scope.setTag('app_build', packageInfo.buildNumber);
        scope.setTag('package_name', packageInfo.packageName);
      });

      // Attach to the global network error handler
      attachNetworkErrorHandler();
    }
  }

  /// Determines if an exception represents an expected client condition
  /// (such as offline connectivity, 4xx HTTP responses, or 302 profile update enforcement)
  /// that should not be reported to Sentry as an issue.
  static bool shouldIgnoreException(dynamic exception) {
    if (exception is ApiException) {
      return exception.type == ApiErrorType.noInternet ||
          exception.statusCode == 302 ||
          exception.type == ApiErrorType.enforceStudentData ||
          exception.isClientError;
    }
    if (exception is DioException) {
      if (exception.type == DioExceptionType.connectionError) {
        return true;
      }
      final statusCode = exception.response?.statusCode;
      if (statusCode != null &&
          ((statusCode >= 400 && statusCode < 500) || statusCode == 302)) {
        return true;
      }
    }
    return false;
  }

  @visibleForTesting
  static bool shouldIgnoreSentryEvent(SentryEvent event) {
    if (event.tags?['bypass_filter'] == 'true') {
      return false;
    }
    return shouldIgnoreException(event.throwable);
  }

  /// Attaches the Sentry network error handler to the global [onNetworkErrorCapture] hook.
  void attachNetworkErrorHandler() {
    onNetworkErrorCapture = (error, stackTrace) {
      if (shouldIgnoreException(error)) {
        return;
      }

      if (error is ApiException) {
        String? responseData;
        if (error.data != null) {
          try {
            responseData = error.data is String
                ? error.data as String
                : jsonEncode(error.data);
          } catch (_) {
            responseData = error.data.toString();
          }
        }

        final contexts = <String, dynamic>{
          'api_details': {
            'error_type': error.type.name,
            'status_code': ?error.statusCode,
            'response_data': ?responseData,
            'underlying_error': ?error.error?.toString(),
          },
        };

        captureException(error, stackTrace: stackTrace, contexts: contexts);
        return;
      }

      captureException(error, stackTrace: stackTrace);
    };
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
    bool bypassFilter = false,
  }) async {
    if (!bypassFilter && shouldIgnoreException(exception)) {
      return;
    }

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (level != null) scope.level = level.toSentryLevel;
        if (bypassFilter) scope.setTag('bypass_filter', 'true');
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
}

@Riverpod(keepAlive: true)
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
