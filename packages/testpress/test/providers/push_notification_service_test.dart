import 'dart:async';
import 'dart:io';
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

    test('extracts image URLs from supported payload keys', () {
      final msg1 = RemoteMessage(
        data: const {'image_url': 'https://example.com/img1.png'},
      );
      final msg2 = RemoteMessage(
        data: const {'image': 'https://example.com/img2.png'},
      );
      final msg3 = RemoteMessage(
        notification: const RemoteNotification(
          android: AndroidNotification(
            imageUrl: 'https://example.com/img3.png',
          ),
        ),
      );
      final msg4 = RemoteMessage(
        notification: const RemoteNotification(
          apple: AppleNotification(imageUrl: 'https://example.com/img4.png'),
        ),
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
      expect(notificationImageUrlFromMessage(msgEmpty), isNull);
    });

    test(
      'extracts URL with destination_url taking precedence over short_url, and falling back to short_url when blank',
      () {
        final msgBoth = RemoteMessage(
          data: const {
            'destination_url': 'https://example.com/destination',
            'short_url': '/dashboard',
          },
        );
        final msgFallback = RemoteMessage(
          data: const {'destination_url': '', 'short_url': '/dashboard'},
        );
        final msgRedirect = RemoteMessage(
          data: const {'redirect_url': 'https://example.com/redirect'},
        );

        expect(
          notificationUrlFromMessage(msgBoth),
          'https://example.com/destination',
        );
        expect(notificationUrlFromMessage(msgFallback), '/dashboard');
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
        expect(
          detailsWithImage.android?.largeIcon,
          isA<FilePathAndroidBitmap>(),
        );
        final style =
            detailsWithImage.android?.styleInformation
                as BigPictureStyleInformation;
        expect(style.contentTitle, 'Image Title');
        expect(style.summaryText, 'Image Body');
        expect(style.hideExpandedLargeIcon, isTrue);
        expect(detailsWithImage.iOS?.attachments?.length, 1);
      },
    );

    test('omits BigPictureStyleInformation when imageFilePath is null', () {
      final details = notificationDetailsForChannel(
        PushNotificationChannels.postsId,
      );

      expect(details.android?.styleInformation, isNull);
      expect(details.android?.largeIcon, isNull);
      expect(details.iOS?.attachments, isNull);
    });

    test(
      'downloadNotificationImage returns null for invalid or null URLs',
      () async {
        expect(await downloadNotificationImage(null), isNull);
        expect(await downloadNotificationImage('   '), isNull);
        expect(await downloadNotificationImage('ftp://invalid.com'), isNull);
        expect(
          await downloadNotificationImage('http://example.com/cleartext.jpg'),
          isNull,
        );
        expect(await downloadNotificationImage('not-a-url'), isNull);
      },
    );

    test(
      'downloadNotificationImage rejects images exceeding maxBytes via Content-Length',
      () async {
        final client = _FakeHttpClient(
          _FakeHttpClientRequest(
            _FakeHttpClientResponse(
              contentLength: 3 * 1024 * 1024,
              chunks: [List.filled(100, 1)],
            ),
          ),
        );

        final result = await downloadNotificationImage(
          'https://example.com/oversized.jpg',
          client: client,
        );
        expect(result, isNull);
      },
    );

    test(
      'downloadNotificationImage aborts stream early when streamed bytes exceed maxBytes',
      () async {
        final client = _FakeHttpClient(
          _FakeHttpClientRequest(
            _FakeHttpClientResponse(
              contentLength: -1,
              chunks: [
                List.filled(1024 * 1024, 1),
                List.filled(1024 * 1024, 1),
                List.filled(1024, 1),
              ],
            ),
          ),
        );

        final result = await downloadNotificationImage(
          'https://example.com/streamed_too_large.jpg',
          client: client,
        );
        expect(result, isNull);
      },
    );

    test(
      'downloadNotificationImage successfully downloads images within maxBytes',
      () async {
        final client = _FakeHttpClient(
          _FakeHttpClientRequest(
            _FakeHttpClientResponse(
              contentLength: 100,
              chunks: [List.filled(100, 1)],
            ),
          ),
        );

        final result = await downloadNotificationImage(
          'https://example.com/valid.jpg',
          client: client,
        );
        expect(result, isNotNull);
        expect(result, endsWith('.jpg'));
      },
    );

    test(
      'downloadNotificationImage returns null when overall timeout expires',
      () async {
        final client = _FakeHttpClient(
          _FakeHttpClientRequest(
            _FakeHttpClientResponse(
              contentLength: 100,
              chunks: [List.filled(100, 1)],
            ),
            delay: const Duration(milliseconds: 100),
          ),
        );

        final result = await downloadNotificationImage(
          'https://example.com/slow.jpg',
          timeout: const Duration(milliseconds: 10),
          client: client,
        );
        expect(result, isNull);
      },
    );

    test(
      'downloadNotificationImage returns null on redirect (3xx) response',
      () async {
        final client = _FakeHttpClient(
          _FakeHttpClientRequest(
            _FakeHttpClientResponse(statusCode: HttpStatus.movedPermanently),
          ),
        );

        final result = await downloadNotificationImage(
          'https://example.com/redirect.jpg',
          client: client,
        );
        expect(result, isNull);
      },
    );

    test(
      'prunes old notification images when count reaches threshold',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('notif_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        for (var i = 0; i < 6; i++) {
          final file = File('${tempDir.path}/notif_img_${i + 1}.jpg');
          file.writeAsStringSync('data $i');
          file.setLastModifiedSync(
            DateTime.now().subtract(Duration(minutes: 10 - i)),
          );
        }

        expect(
          tempDir.listSync().where((e) => e.path.contains('notif_img_')).length,
          6,
        );

        await pruneOldNotificationImagesForTesting(tempDir, maxFiles: 5);

        final remaining = tempDir
            .listSync()
            .where((e) => e.path.contains('notif_img_'))
            .toList();
        expect(remaining.length, 4);
        expect(File('${tempDir.path}/notif_img_1.jpg').existsSync(), isFalse);
        expect(File('${tempDir.path}/notif_img_2.jpg').existsSync(), isFalse);
        expect(File('${tempDir.path}/notif_img_6.jpg').existsSync(), isTrue);
      },
    );
  });
}

class _FakeHttpClient extends Fake implements HttpClient {
  final _FakeHttpClientRequest request;
  _FakeHttpClient(this.request);

  // Absorb connectionTimeout assignment from downloadNotificationImage.
  @override
  set connectionTimeout(Duration? timeout) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => request;

  @override
  void close({bool force = false}) {}
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  final _FakeHttpClientResponse response;
  final Duration? delay;
  _FakeHttpClientRequest(this.response, {this.delay});

  @override
  set followRedirects(bool follow) {}

  @override
  Future<HttpClientResponse> close() async {
    if (delay != null) {
      await Future<void>.delayed(delay!);
    }
    return response;
  }
}

class _FakeHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  @override
  final int statusCode;
  @override
  final int contentLength;
  final Stream<List<int>> _stream;

  _FakeHttpClientResponse({
    this.statusCode = HttpStatus.ok,
    this.contentLength = -1,
    List<List<int>> chunks = const [],
  }) : _stream = Stream<List<int>>.fromIterable(chunks);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
