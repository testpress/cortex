import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/providers/notification_preferences_provider.dart';
import '../navigation/app_router.dart';

part 'push_notification_service.g.dart';

class PushNotificationService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  PushNotificationService(this._ref);

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final messaging = FirebaseMessaging.instance;

    // 1. Request Notification Permissions (iOS & Android 13+)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. Initialize Local Notifications (For Foreground Alerts)
    await _initLocalNotifications();

    // 3. Listen to Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 4. Listen to Taps when app is in Background (but running)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDeepLink(message.data['short_url']);
    });

    // 5. Listen to Token Refreshes
    messaging.onTokenRefresh.listen((token) {
      _syncDeviceToken(token);
    });

    // 6. Handle App Launches from Terminated State
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleDeepLink(initialMessage.data['short_url']);
    }

    // 7. Initial Token Sync if user is logged in
    final token = await messaging.getToken();
    if (token != null) {
      // ignore: avoid_print
      print('🚀 [FCM Token] successfully retrieved: $token');
      _syncDeviceToken(token);
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
    final url = message.data['short_url'];

    if (title != null && summary != null) {
      final preferences = _ref.read(notificationPreferencesProvider);

      // Smart Routing: Decide channel by URL pattern matching Android's behavior
      String channelId = 'posts_channel';
      bool shouldShow = true;

      if (url != null) {
        final uri = Uri.tryParse(url);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          final firstSegment = uri.pathSegments.first;
          if (firstSegment == 'exams' || firstSegment == 'chapters') {
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

  void _handleDeepLink(String? url) {
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri != null) {
      final router = _ref.read(goRouterProvider);
      final path = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
      router.push(path);
    }
  }

  Future<void> _syncDeviceToken(String token) async {
    final isLoggedIn = _ref.read(authProvider).asData?.value ?? false;
    if (!isLoggedIn) return;

    try {
      final userRepo = await _ref.read(userRepositoryProvider.future);
      final hardwareId = token.hashCode.toString();
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

  return service;
}
