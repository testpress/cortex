import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/providers/notification_preferences_provider.dart';
import '../navigation/app_router.dart';
import '../navigation/bootstrap_provider.dart';
import '../navigation/deep_link_handler.dart';

part 'push_notification_service.g.dart';

/// Displays backend data-only FCM messages while the app is backgrounded.
///
/// Firebase invokes this top-level function in a background isolate, so it
/// must not depend on Riverpod, BuildContext, or the app's service instance.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final title = notificationTitleFromMessage(message);
  final body = notificationBodyFromMessage(message);
  if (title == null || body == null) return;

  final url = notificationUrlFromMessage(message);
  final channelId = notificationChannelIdForUrl(url);
  final localNotifications = FlutterLocalNotificationsPlugin();

  await localNotifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  final androidPlugin = localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidPlugin?.createNotificationChannel(
    AndroidNotificationChannel(
      channelId,
      channelId == 'posts_channel' ? 'Posts' : 'Learning Content',
      description: channelId == 'posts_channel'
          ? 'Notifications for new articles and announcements'
          : 'Notifications for exams, tests, and chapters',
      importance: Importance.high,
    ),
  );

  await localNotifications.show(
    message.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId == 'posts_channel' ? 'Posts' : 'Learning Content',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    payload: url,
  );
}

String? notificationTitleFromMessage(RemoteMessage message) {
  return message.data['title']?.toString() ?? message.notification?.title;
}

String? notificationBodyFromMessage(RemoteMessage message) {
  return message.data['summary']?.toString() ??
      message.data['body']?.toString() ??
      message.data['description']?.toString() ??
      message.notification?.body;
}

String? notificationUrlFromMessage(RemoteMessage message) {
  final url =
      message.data['short_url'] ?? message.data['url'] ?? message.data['link'];
  if (url != null && url.trim().isNotEmpty) {
    return url.trim();
  }
  return null;
}

String notificationChannelIdForUrl(String? url) {
  final uri = url == null ? null : Uri.tryParse(url);
  final firstSegment = uri != null && uri.pathSegments.isNotEmpty
      ? uri.pathSegments.first
      : null;
  return firstSegment == 'exams' ||
          firstSegment == 'chapters' ||
          firstSegment == 'courses'
      ? 'contents_channel'
      : 'posts_channel';
}

class PushNotificationService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;
  static const Duration _pendingLinkTtl = Duration(minutes: 30);

  PushNotificationService(this._ref);

  /// Clears any pending deep link (e.g. on user logout).
  void clearPendingLink() {
    _pendingDeepLink = null;
    _pendingDeepLinkTimestamp = null;
  }

  @visibleForTesting
  String? get pendingDeepLink => _pendingDeepLink;

  @visibleForTesting
  DateTime? get pendingDeepLinkTimestamp => _pendingDeepLinkTimestamp;

  @visibleForTesting
  void handleDeepLink(String? url) => _handleDeepLink(url);

  @visibleForTesting
  void setPendingDeepLink(String? url, DateTime? timestamp) {
    _pendingDeepLink = url;
    _pendingDeepLinkTimestamp = timestamp;
  }

  /// Flushes and dispatches any valid pending deep link that was queued
  /// while waiting for authentication and settings initialization.
  void flushPendingLink() {
    if (_pendingDeepLink != null) {
      final path = _pendingDeepLink!;
      final timestamp = _pendingDeepLinkTimestamp;
      clearPendingLink();
      if (timestamp != null &&
          DateTime.now().difference(timestamp) <= _pendingLinkTtl) {
        _dispatchRoute(path);
      }
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Request Notification Permissions (iOS & Android 13+)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 3. Initialize Local Notifications (For Foreground Alerts)
    await _initLocalNotifications();

    // 4. Listen to Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 5. Listen to Taps when app is in Background (but running)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDeepLink(_extractUrl(message));
    });

    // 6. Listen to Token Refreshes
    messaging.onTokenRefresh.listen((token) {
      _syncDeviceToken(token);
    });

    // 7. Handle App Launches from Terminated State
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleDeepLink(_extractUrl(initialMessage));
    }

    // 8. Initial Token Sync if user is logged in
    final token = await messaging.getToken();
    if (token != null) {
      _syncDeviceToken(token);
    }

    // 9. Flush pending deep link if bootstrap reached authenticated during initialization
    if (_ref.read(bootstrapProvider) == BootstrapState.authenticated) {
      flushPendingLink();
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleDeepLink(response.payload!);
        }
      },
    );

    // Set up Notification Channels (Android 8.0+)
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'posts_channel',
        'Posts',
        description: 'Notifications for new articles and announcements',
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'contents_channel',
        'Learning Content',
        description: 'Notifications for exams, tests, and chapters',
        importance: Importance.high,
      ),
    );
  }

  void _showLocalNotification(RemoteMessage message) {
    final title = message.data['title'] ?? message.notification?.title;
    final summary = message.data['summary'] ?? message.notification?.body;
    final url = _extractUrl(message);

    if (title != null && summary != null) {
      final preferences = _ref.read(notificationPreferencesProvider);

      // Smart Routing: Decide channel by URL pattern matching Android's behavior
      String channelId = 'posts_channel';
      bool shouldShow = true;

      if (url != null) {
        final uri = Uri.tryParse(url);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          final firstSegment = uri.pathSegments.first;
          if (firstSegment == 'exams' ||
              firstSegment == 'chapters' ||
              firstSegment == 'courses') {
            channelId = 'contents_channel';
            shouldShow = preferences.testAssessmentAlerts;
          } else if (firstSegment == 'p') {
            channelId = 'posts_channel';
            shouldShow = preferences.announcementsUpdates;
          } else if (firstSegment == 'live') {
            shouldShow = preferences.liveClassReminders;
          }
        }
      }

      if (!shouldShow) return;

      _localNotifications.show(
        message.hashCode,
        title,
        summary,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelId == 'posts_channel' ? 'Posts' : 'Learning Content',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: url,
      );
    }
  }

  String? _extractUrl(RemoteMessage message) {
    final url =
        message.data['short_url'] ??
        message.data['url'] ??
        message.data['link'];
    if (url != null && url.trim().isNotEmpty) {
      return url.trim();
    }
    return null;
  }

  void _handleDeepLink(String? url) {
    if (url == null || url.trim().isEmpty) return;

    final bootstrapState = _ref.read(bootstrapProvider);

    if (bootstrapState == BootstrapState.authenticated) {
      _dispatchRoute(url);
    } else {
      // Check if it is a public auth destination that can bypass authentication
      final candidateRoute = DeepLinkHandler.resolve(url);
      if (candidateRoute == '/login' || candidateRoute == '/signup') {
        _dispatchRoute(url);
      } else {
        // Store raw link to resolve at dispatch time once authenticated & settings loaded
        _pendingDeepLink = url;
        _pendingDeepLinkTimestamp = DateTime.now();
      }
    }
  }

  void _dispatchRoute(String rawUrl) {
    var targetPath = DeepLinkHandler.resolve(rawUrl);

    // Validate against loaded settings and feature flags at dispatch time
    final settings = _ref.read(instituteSettingsProvider);
    targetPath = DeepLinkHandler.filterRouteByAvailability(
      targetPath,
      settings: settings,
    );

    final router = _ref.read(goRouterProvider);
    final isTabRoute = NavTab.values.any((tab) => tab.id == targetPath);
    if (isTabRoute) {
      router.go(targetPath);
    } else {
      router.push(targetPath);
    }
  }

  Future<void> _syncDeviceToken(String token) async {
    final isLoggedIn = _ref.read(authProvider).asData?.value ?? false;
    if (!isLoggedIn) return;

    try {
      final userRepo = await _ref.read(userRepositoryProvider.future);
      String hardwareId = token.hashCode.toString();
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          hardwareId = androidInfo.id;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          hardwareId = iosInfo.identifierForVendor ?? token.hashCode.toString();
        }
      } catch (_) {
        // Fallback
      }
      await userRepo.registerDeviceToken(token, hardwareId);
    } catch (_) {
      // Fail silently, retry on next boot or token refresh
    }
  }
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(
  PushNotificationServiceRef ref,
) {
  final service = PushNotificationService(ref);

  // Sync token whenever the user logs in
  ref.listen(userProvider, (previous, next) async {
    final user = next.valueOrNull;
    if (user != null) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        service._syncDeviceToken(token);
      }
    }
  });

  // Replay pending deep link once bootstrap transitions to authenticated
  ref.listen<BootstrapState>(bootstrapProvider, (_, next) {
    if (next == BootstrapState.authenticated) {
      service.flushPendingLink();
    }
  });

  // Clear any pending deep link when an active user logs out
  ref.listen(authProvider, (previous, next) {
    final wasLoggedIn = previous?.valueOrNull ?? false;
    final isLoggedIn = next.valueOrNull ?? false;
    if (wasLoggedIn && !isLoggedIn) {
      service.clearPendingLink();
    }
  });

  return service;
}
