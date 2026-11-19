import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
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

class _MockUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  bool launchUrlResult = true;
  String? launchedUrl;
  LaunchOptions? launchedOptions;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchedOptions = options;
    return launchUrlResult;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoRouter fakeRouter;
  late _MockUrlLauncherPlatform mockUrlLauncher;

  setUp(() {
    mockUrlLauncher = _MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockUrlLauncher;
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
      'dispatches external URL immediately without queueing when unauthenticated',
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
        service.handleDeepLink('https://forms.google.com/test-form');

        expect(service.pendingDeepLink, isNull);
        expect(
          mockUrlLauncher.launchedUrl,
          'https://forms.google.com/test-form',
        );
        expect(
          mockUrlLauncher.launchedOptions?.mode,
          PreferredLaunchMode.externalApplication,
        );
      },
    );

    test('dispatches pending external URL to browser on flushPendingLink', () {
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
        'https://example.com/external-event',
        DateTime.now(),
      );

      service.flushPendingLink();

      expect(service.pendingDeepLink, isNull);
      expect(mockUrlLauncher.launchedUrl, 'https://example.com/external-event');
    });

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

    test(
      'does not use notification fields for data-only background handling',
      () {
        final message = RemoteMessage(
          notification: const RemoteNotification(
            title: 'OS notification title',
            body: 'OS notification body',
          ),
          data: const {},
        );

        expect(
          notificationTitleFromMessage(
            message,
            includeNotificationFallback: false,
          ),
          isNull,
        );
        expect(
          notificationBodyFromMessage(
            message,
            includeNotificationFallback: false,
          ),
          isNull,
        );
      },
    );

    test('routes live URLs to the live notification category', () {
      expect(
        notificationCategoryForUrl('/live/class-1/'),
        NotificationCategory.live,
      );
    });

    test(
      'routes unknown URLs to posts without classifying them as announcements',
      () {
        expect(
          notificationCategoryForUrl('/dashboard/'),
          NotificationCategory.other,
        );
        expect(notificationChannelIdForUrl('/dashboard/'), 'posts_channel');
      },
    );

    test('returns null for missing or blank URLs', () {
      expect(notificationUrlFromMessage(RemoteMessage(data: const {})), isNull);
      expect(
        notificationUrlFromMessage(
          RemoteMessage(data: const {'short_url': '   '}),
        ),
        isNull,
      );
    });

    test('returns null when title and body fields are missing or blank', () {
      final message = RemoteMessage(data: const {'title': '  ', 'summary': ''});

      expect(notificationTitleFromMessage(message), isNull);
      expect(notificationBodyFromMessage(message), isNull);
      expect(
        notificationTitleFromMessage(RemoteMessage(data: const {})),
        isNull,
      );
      expect(
        notificationBodyFromMessage(RemoteMessage(data: const {})),
        isNull,
      );
    });

    test('keeps notification IDs within the signed 32-bit range', () {
      final withMessageId = RemoteMessage(messageId: 'message-1');
      final withoutMessageId = RemoteMessage();

      expect(
        notificationIdForMessage(withMessageId),
        inInclusiveRange(0, 0x7FFFFFFF),
      );
      expect(
        notificationIdForMessage(withoutMessageId),
        inInclusiveRange(0, 0x7FFFFFFF),
      );
    });

    test('uses the expected details for each notification channel', () {
      final posts = notificationDetailsForChannel(
        PushNotificationChannels.postsId,
      );
      final contents = notificationDetailsForChannel(
        PushNotificationChannels.contentsId,
      );

      expect(posts.android?.channelId, PushNotificationChannels.postsId);
      expect(posts.android?.channelName, PushNotificationChannels.postsName);
      expect(contents.android?.channelId, PushNotificationChannels.contentsId);
      expect(
        contents.android?.channelName,
        PushNotificationChannels.contentsName,
      );
    });

    test('extracts image URLs from various payload keys', () {
      final msg1 = RemoteMessage(
        data: const {'image_url': 'https://example.com/img1.png'},
      );
      final msg2 = RemoteMessage(
        data: const {'image': 'https://example.com/img2.png'},
      );
      final msg3 = RemoteMessage(
        data: const {'picture': 'https://example.com/img3.png'},
      );
      final msg4 = RemoteMessage(
        notification: const RemoteNotification(
          android: AndroidNotification(
            imageUrl: 'https://example.com/img4.png',
          ),
        ),
      );
      final msg5 = RemoteMessage(
        data: const {'push_image': 'https://example.com/img5.png'},
      );
      final msg6 = RemoteMessage(
        data: const {'remote_image_url': 'https://example.com/img6.png'},
      );
      final msgEmpty = RemoteMessage(data: const {'image_url': '   '});

      expect(
        notificationImageUrlFromMessage(msg1),
        'https://example.com/img1.png',
      );
      expect(
        notificationImageUrlFromMessage(msg2),
        'https://example.com/img2.png',
      );
      expect(
        notificationImageUrlFromMessage(msg3),
        'https://example.com/img3.png',
      );
      expect(
        notificationImageUrlFromMessage(msg4),
        'https://example.com/img4.png',
      );
      expect(
        notificationImageUrlFromMessage(msg5),
        'https://example.com/img5.png',
      );
      expect(
        notificationImageUrlFromMessage(msg6),
        'https://example.com/img6.png',
      );
      expect(notificationImageUrlFromMessage(msgEmpty), isNull);
    });

    test(
      'extracts destination_url, dest_url, and redirect_url from payload',
      () {
        final msgDestination = RemoteMessage(
          data: const {'destination_url': 'https://example.com/destination'},
        );
        final msgDest = RemoteMessage(
          data: const {'dest_url': 'https://example.com/dest'},
        );
        final msgRedirect = RemoteMessage(
          data: const {'redirect_url': 'https://example.com/redirect'},
        );
        expect(
          notificationUrlFromMessage(msgDestination),
          'https://example.com/destination',
        );
        expect(notificationUrlFromMessage(msgDest), 'https://example.com/dest');
        expect(
          notificationUrlFromMessage(msgRedirect),
          'https://example.com/redirect',
        );
      },
    );

    test(
      'creates BigPictureStyleInformation when imageFilePath is provided',
      () {
        final detailsWithImage = notificationDetailsForChannel(
          PushNotificationChannels.postsId,
          imageFilePath: '/tmp/test_image.jpg',
          title: 'Image Title',
          body: 'Image Body',
        );

        expect(
          detailsWithImage.android?.styleInformation,
          isA<BigPictureStyleInformation>(),
        );
        final style =
            detailsWithImage.android?.styleInformation
                as BigPictureStyleInformation;
        expect(style.contentTitle, 'Image Title');
        expect(style.summaryText, 'Image Body');
        expect(detailsWithImage.iOS?.attachments?.length, 1);
      },
    );

    test('omits BigPictureStyleInformation when imageFilePath is null', () {
      final details = notificationDetailsForChannel(
        PushNotificationChannels.postsId,
      );

      expect(details.android?.styleInformation, isNull);
      expect(details.iOS?.attachments, isNull);
    });

    test(
      'downloadNotificationImage returns null for invalid or null URLs',
      () async {
        expect(await downloadNotificationImage(null), isNull);
        expect(await downloadNotificationImage('   '), isNull);
        expect(await downloadNotificationImage('ftp://invalid.com'), isNull);
        expect(await downloadNotificationImage('not-a-url'), isNull);
      },
    );
  });
}
