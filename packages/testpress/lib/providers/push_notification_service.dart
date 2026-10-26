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

class PushNotificationChannels {
  PushNotificationChannels._();

  static const postsId = 'posts_channel';
  static const postsName = 'Posts';
  static const postsDescription =
      'Notifications for new articles and announcements';
  static const contentsId = 'contents_channel';
  static const contentsName = 'Learning Content';
  static const contentsDescription =
      'Notifications for exams, tests, and chapters';
}

enum NotificationCategory { posts, contents, live, other }

bool _firebaseMessagingHandlerRegistered = false;

/// Initializes Firebase and registers the background handler before the app
/// starts. This is intentionally public so the application shell can call it
/// before [runApp].
Future<void> initializeFirebaseMessaging() async {
  if (_firebaseMessagingHandlerRegistered) return;

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  _firebaseMessagingHandlerRegistered = true;
}

/// Displays backend data-only FCM messages while the app is backgrounded.
///
/// Firebase invokes this top-level function in a background isolate, so it
/// must not depend on Riverpod, BuildContext, or the app's service instance.
/// Notification preferences are currently held in Riverpod memory only, so
/// they cannot be read from this isolate. Foreground notifications honor those
/// preferences; background notifications follow the operating-system channel
/// settings until the preferences are persisted for background access.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();

    // The backend sends data-only messages. Do not fall back to the
    // notification block here, because Android may already display it.
    final title = notificationTitleFromMessage(
      message,
      includeNotificationFallback: false,
    );
    final body = notificationBodyFromMessage(
      message,
      includeNotificationFallback: false,
    );
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
    await _createNotificationChannels(localNotifications);

    await localNotifications.show(
      notificationIdForMessage(message),
      title,
      body,
      notificationDetailsForChannel(channelId),
      payload: url,
    );
  } catch (error, stackTrace) {
    debugPrint('FCM background notification failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> _createNotificationChannels(
  FlutterLocalNotificationsPlugin localNotifications,
) async {
  final androidPlugin = localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      PushNotificationChannels.postsId,
      PushNotificationChannels.postsName,
      description: PushNotificationChannels.postsDescription,
      importance: Importance.high,
    ),
  );
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      PushNotificationChannels.contentsId,
      PushNotificationChannels.contentsName,
      description: PushNotificationChannels.contentsDescription,
      importance: Importance.high,
    ),
  );
}

String? notificationTitleFromMessage(
  RemoteMessage message, {
  bool includeNotificationFallback = true,
}) {
  return _firstNonBlank([
    message.data['title']?.toString(),
    if (includeNotificationFallback) message.notification?.title,
  ]);
}

String? notificationBodyFromMessage(
  RemoteMessage message, {
  bool includeNotificationFallback = true,
}) {
  return _firstNonBlank([
    message.data['summary']?.toString(),
    message.data['body']?.toString(),
    message.data['description']?.toString(),
    if (includeNotificationFallback) message.notification?.body,
  ]);
}

String? _firstNonBlank(Iterable<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value;
  }
  return null;
}

String? notificationUrlFromMessage(RemoteMessage message) {
  final url =
      message.data['short_url'] ?? message.data['url'] ?? message.data['link'];
  if (url != null && url.trim().isNotEmpty) {
    return url.trim();
  }
  return null;
}

NotificationCategory notificationCategoryForUrl(String? url) {
  final uri = url == null ? null : Uri.tryParse(url);
  final firstSegment = uri != null && uri.pathSegments.isNotEmpty
      ? uri.pathSegments.first
      : null;
  if (firstSegment == 'exams' ||
      firstSegment == 'chapters' ||
      firstSegment == 'courses') {
    return NotificationCategory.contents;
  }
  if (firstSegment == 'live') return NotificationCategory.live;
  if (firstSegment == 'p') return NotificationCategory.posts;
  return NotificationCategory.other;
}

String notificationChannelIdForUrl(String? url) {
  return notificationCategoryForUrl(url) == NotificationCategory.contents
      ? PushNotificationChannels.contentsId
      : PushNotificationChannels.postsId;
}

int notificationIdForMessage(RemoteMessage message) {
  final rawId =
      message.messageId?.hashCode ??
      DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return rawId & 0x7FFFFFFF;
}

NotificationDetails notificationDetailsForChannel(String channelId) {
  final isPosts = channelId == PushNotificationChannels.postsId;
  return NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      isPosts
          ? PushNotificationChannels.postsName
          : PushNotificationChannels.contentsName,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: const DarwinNotificationDetails(),
  );
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

    await initializeFirebaseMessaging();

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

    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _handleDeepLink(launchDetails?.notificationResponse?.payload);
    }

    await _createNotificationChannels(_localNotifications);
  }

  void _showLocalNotification(RemoteMessage message) {
    final title = notificationTitleFromMessage(message);
    final summary = notificationBodyFromMessage(message);
    final url = _extractUrl(message);

    if (title != null && summary != null) {
      final preferences = _ref.read(notificationPreferencesProvider);

      final category = notificationCategoryForUrl(url);
      final channelId = notificationChannelIdForUrl(url);
      final shouldShow = switch (category) {
        NotificationCategory.contents => preferences.testAssessmentAlerts,
        NotificationCategory.posts => preferences.announcementsUpdates,
        NotificationCategory.live => preferences.liveClassReminders,
        NotificationCategory.other => true,
      };

      if (!shouldShow) return;

      _localNotifications.show(
        notificationIdForMessage(message),
        title,
        summary,
        notificationDetailsForChannel(channelId),
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
