import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:testpress/navigation/app_router.dart';
import 'package:testpress/providers/push_notification_service.dart';

class _FakeAuth extends Auth {
  final bool initialLoggedIn;
  _FakeAuth({this.initialLoggedIn = false});

  @override
  FutureOr<bool> build() => initialLoggedIn;

  void setLoggedIn(bool loggedIn) {
    state = AsyncData(loggedIn);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoRouter fakeRouter;

  setUp(() {
    fakeRouter = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const SizedBox()),
        GoRoute(path: '/login', builder: (_, _) => const SizedBox()),
        GoRoute(path: '/signup', builder: (_, _) => const SizedBox()),
        GoRoute(
          path: '/study',
          builder: (_, _) => const SizedBox(),
          routes: [
            GoRoute(path: 'lesson/:id', builder: (_, _) => const SizedBox()),
          ],
        ),
      ],
    );
  });

  tearDown(() {
    fakeRouter.dispose();
  });

  group('PushNotificationService pending link and lifecycle', () {
    test('queues raw URL when bootstrap is unauthenticated', () {
      final fakeAuth = _FakeAuth(initialLoggedIn: false);
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          goRouterProvider.overrideWithValue(fakeRouter),
          instituteSettingsProvider.overrideWith(
            (ref) => InstituteSettings.fromJson(const {}),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(pushNotificationServiceProvider);
      service.handleDeepLink(
        'https://staging.testpress.in/exams/chapter_content/2054',
      );

      expect(
        service.pendingDeepLink,
        'https://staging.testpress.in/exams/chapter_content/2054',
      );
      expect(service.pendingDeepLinkTimestamp, isNotNull);
    });

    test(
      'dispatches /login and /signup immediately without queueing when unauthenticated',
      () {
        final fakeAuth = _FakeAuth(initialLoggedIn: false);
        final container = ProviderContainer(
          overrides: [
            authProvider.overrideWith(() => fakeAuth),
            goRouterProvider.overrideWithValue(fakeRouter),
            instituteSettingsProvider.overrideWith(
              (ref) => InstituteSettings.fromJson(const {}),
            ),
          ],
        );
        addTearDown(container.dispose);

        final service = container.read(pushNotificationServiceProvider);
        service.handleDeepLink('/login');

        expect(service.pendingDeepLink, isNull);

        service.handleDeepLink('/activate');
        expect(service.pendingDeepLink, isNull);
      },
    );

    test(
      'dispatches and clears pending link when bootstrap transitions to authenticated',
      () async {
        final fakeAuth = _FakeAuth(initialLoggedIn: false);
        final container = ProviderContainer(
          overrides: [
            authProvider.overrideWith(() => fakeAuth),
            goRouterProvider.overrideWithValue(fakeRouter),
            instituteSettingsProvider.overrideWith(
              (ref) => InstituteSettings.fromJson(const {}),
            ),
          ],
        );
        addTearDown(container.dispose);

        final service = container.read(pushNotificationServiceProvider);
        service.handleDeepLink(
          'https://staging.testpress.in/exams/chapter_content/2054',
        );
        expect(service.pendingDeepLink, isNotNull);

        // Transition to authenticated
        fakeAuth.setLoggedIn(true);
        await container.pump();

        // Listener fired, flushing and clearing the pending link
        expect(service.pendingDeepLink, isNull);
      },
    );

    test('discards pending link if TTL has expired (> 30 minutes)', () {
      final fakeAuth = _FakeAuth(initialLoggedIn: false);
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          goRouterProvider.overrideWithValue(fakeRouter),
          instituteSettingsProvider.overrideWith(
            (ref) => InstituteSettings.fromJson(const {}),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(pushNotificationServiceProvider);
      // Simulate link tapped 35 minutes ago
      final staleTimestamp = DateTime.now().subtract(
        const Duration(minutes: 35),
      );
      service.setPendingDeepLink(
        'https://staging.testpress.in/exams/chapter_content/2054',
        staleTimestamp,
      );

      service.flushPendingLink();

      // Pending link should be cleared and NOT dispatched
      expect(service.pendingDeepLink, isNull);
    });

    test('clears pending link on user logout', () async {
      final fakeAuth = _FakeAuth(initialLoggedIn: true);
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          goRouterProvider.overrideWithValue(fakeRouter),
          instituteSettingsProvider.overrideWith(
            (ref) => InstituteSettings.fromJson(const {}),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(pushNotificationServiceProvider);
      service.setPendingDeepLink(
        'https://staging.testpress.in/exams/chapter_content/2054',
        DateTime.now(),
      );
      expect(service.pendingDeepLink, isNotNull);

      // User logs out (auth transitions from true to false)
      fakeAuth.setLoggedIn(false);
      await container.pump();

      expect(service.pendingDeepLink, isNull);
      expect(service.pendingDeepLinkTimestamp, isNull);
    });
  });

  group('backend FCM payload parsing', () {
    test('reads the backend data-only payload fields', () {
      final message = RemoteMessage(
        data: const {
          'title': 'New announcement',
          'summary': 'The next lesson is now available.',
          'short_url': '/p/announcement-1/',
        },
      );

      expect(notificationTitleFromMessage(message), 'New announcement');
      expect(
        notificationBodyFromMessage(message),
        'The next lesson is now available.',
      );
      expect(notificationUrlFromMessage(message), '/p/announcement-1/');
      expect(
        notificationChannelIdForUrl('/p/announcement-1/'),
        'posts_channel',
      );
    });

    test('routes exam and chapter URLs to the learning channel', () {
      expect(notificationChannelIdForUrl('/exams/42/'), 'contents_channel');
      expect(notificationChannelIdForUrl('/chapters/42/'), 'contents_channel');
      expect(notificationChannelIdForUrl('/courses/42/'), 'contents_channel');
    });

    test('falls back to standard notification payload fields', () {
      final message = RemoteMessage(
        notification: const RemoteNotification(
          title: 'Fallback title',
          body: 'Fallback body',
        ),
        data: const {'url': '/live/class-1/'},
      );

      expect(notificationTitleFromMessage(message), 'Fallback title');
      expect(notificationBodyFromMessage(message), 'Fallback body');
      expect(notificationUrlFromMessage(message), '/live/class-1/');
    });
  });
}
