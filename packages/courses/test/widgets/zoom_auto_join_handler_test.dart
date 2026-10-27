import 'package:flutter_test/flutter_test.dart';
import 'package:courses/widgets/lesson_detail/zoom_web_view.dart';

ZoomAutoJoinHandler _buildHandler({
  void Function()? onJoinSuccess,
  void Function()? onJoinTimeout,
  void Function()? onLoadingStart,
  void Function()? onLoadingEnd,
  void Function()? onPermissionPermanentlyDenied,
  Duration fallbackTimeout = const Duration(seconds: 8),
}) {
  return ZoomAutoJoinHandler(
    onJoinSuccess: onJoinSuccess,
    onJoinTimeout: onJoinTimeout,
    onLoadingStart: onLoadingStart,
    onLoadingEnd: onLoadingEnd,
    onPermissionPermanentlyDenied: onPermissionPermanentlyDenied,
    fallbackTimeout: fallbackTimeout,
  );
}

void main() {
  group('ZoomWebViewConfig — URL builder', () {
    test('builds direct web client URL with conferenceId and password', () {
      final url = ZoomWebViewConfig.buildZoomWebClientUrl(
        conferenceId: '123 456 7890',
        password: 'secretPassword',
        displayName: 'John Doe',
        fallbackUrl: 'https://zoom.us/fallback',
      );

      expect(url, startsWith('https://app.zoom.us/wc/1234567890/join?'));
      final uri = Uri.parse(url);
      expect(uri.queryParameters['pwd'], equals('secretPassword'));
      expect(uri.queryParameters['uname'], equals('John Doe'));
    });

    test('falls back to fallbackUrl if conferenceId is null or empty', () {
      final url1 = ZoomWebViewConfig.buildZoomWebClientUrl(
        conferenceId: null,
        password: 'pwd',
        displayName: 'John',
        fallbackUrl: 'https://zoom.us/j/fallback',
      );
      expect(url1, equals('https://zoom.us/j/fallback'));

      final url2 = ZoomWebViewConfig.buildZoomWebClientUrl(
        conferenceId: '   ',
        password: 'pwd',
        displayName: 'John',
        fallbackUrl: 'https://zoom.us/j/fallback',
      );
      expect(url2, equals('https://zoom.us/j/fallback'));
    });
  });

  group('ZoomWebViewConfig — Navigation URL Filtering', () {
    test('permits legitimate Zoom meeting and web client URLs', () {
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://app.zoom.us/wc/1234567890/join?pwd=abc'),
        isTrue,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://us02web.zoom.us/j/1234567890?pwd=abc'),
        isTrue,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://zoom.us/wc/1234567890/join'),
        isTrue,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://zoomgov.com/wc/1234567890/join'),
        isTrue,
      );
    });

    test('blocks Google Play Store and Apple App Store links', () {
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://play.google.com/store/apps/details?id=us.zoom.videomeetings'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'https://apps.apple.com/us/app/zoom-workplace/id546505307'),
        isFalse,
      );
    });

    test('blocks native intent, market, and zoomus schemes', () {
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'market://details?id=us.zoom.videomeetings'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'zoomus://join?action=join&confno=123'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(
            'intent://#Intent;scheme=zoomus;package=us.zoom.videomeetings;end'),
        isFalse,
      );
    });

    test('blocks Zoom marketing and download funnel routes', () {
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl('https://zoom.us/download'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl('https://zoom.us/pricing'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl('https://zoom.us/signup'),
        isFalse,
      );
    });

    test('blocks third-party arbitrary URLs', () {
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl('https://malicious-site.com'),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(''),
        isFalse,
      );
      expect(
        ZoomWebViewConfig.isPermittedZoomUrl(null),
        isFalse,
      );
    });
  });

  group('ZoomAutoJoinHandler — URL gate detection', () {
    const gateUrls = [
      'https://zoom.us/j/1234567890',
      'https://us02web.zoom.us/j/1234567890?pwd=abc',
      'https://app.zoom.us/wc/1234567890/join',
      'https://zoom.us/wc/join/1234567890',
      'https://zoomgov.com/wc/1234567890/join',
    ];

    const nonGateUrls = [
      'https://example.com/join',
      'https://teams.microsoft.com/meet/join',
      'https://zoom.us/privacy',
      'https://evil.com/?zoom.us/j/',
      'https://evil.com/zoom.us/join',
      '',
    ];

    test(
        'isZoomJoinGateUrl rejects third-party URLs with spoofed query or path',
        () {
      final handler = _buildHandler();
      expect(
          handler.isZoomJoinGateUrl('https://evil.com/?zoom.us/j/'), isFalse);
      expect(
          handler.isZoomJoinGateUrl('https://evil.com/zoom.us/join'), isFalse);
      expect(
          handler.isZoomJoinGateUrl('https://zoomgov.com/wc/123/join'), isTrue);
    });

    for (final url in gateUrls) {
      test('onPageStarted triggers loading for gate URL: $url', () {
        bool loadingStarted = false;
        final handler =
            _buildHandler(onLoadingStart: () => loadingStarted = true);
        handler.onPageStarted(url);
        expect(loadingStarted, isTrue);
      });
    }

    test('onPageStarted does NOT trigger loading after join is complete', () {
      bool loadingStarted = false;
      final handler =
          _buildHandler(onLoadingStart: () => loadingStarted = true);
      handler.simulateJsMessage('onButtonClicked');
      loadingStarted = false;
      handler.onPageStarted(gateUrls.first);
      expect(loadingStarted, isFalse);
    });

    for (final url in nonGateUrls) {
      test('onPageFinished calls onLoadingEnd for non-gate URL: "$url"', () {
        bool loadingEnded = false;
        final handler = _buildHandler(onLoadingEnd: () => loadingEnded = true);
        handler.onPageFinished(url);
        expect(loadingEnded, isTrue);
      });
    }
  });

  group('ZoomAutoJoinHandler — JS message handling', () {
    test('onButtonClicked: loader stays up until next page finishes', () {
      bool loadingEnded = false;
      bool joinSucceeded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        onJoinSuccess: () => joinSucceeded = true,
      );

      handler.simulateJsMessage('onButtonClicked');

      expect(loadingEnded, isFalse);
      expect(joinSucceeded, isFalse);

      handler.onPageFinished('https://app.zoom.us/wc/active');

      expect(loadingEnded, isTrue);
      expect(joinSucceeded, isTrue);
    });

    test('onMeetingDetected: drops loader and fires onJoinSuccess immediately',
        () {
      bool loadingEnded = false;
      bool joinSucceeded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        onJoinSuccess: () => joinSucceeded = true,
      );

      handler.simulateJsMessage('onMeetingDetected');

      expect(loadingEnded, isTrue);
      expect(joinSucceeded, isTrue);
    });

    test('onAutoJoinTimeout fires onJoinTimeout', () {
      bool timedOut = false;
      final handler = _buildHandler(onJoinTimeout: () => timedOut = true);
      handler.simulateJsMessage('onAutoJoinTimeout');
      expect(timedOut, isTrue);
    });

    test('onPermissionDenied fires onPermissionPermanentlyDenied', () {
      bool permissionDenied = false;
      final handler = _buildHandler(
        onPermissionPermanentlyDenied: () => permissionDenied = true,
      );
      handler.simulateJsMessage('onPermissionDenied');
      expect(permissionDenied, isTrue);
    });

    test('messages after dispose() are silently ignored', () {
      bool joinSucceeded = false;
      final handler = _buildHandler(onJoinSuccess: () => joinSucceeded = true);
      handler.dispose();
      handler.simulateJsMessage('onMeetingDetected');
      expect(joinSucceeded, isFalse);
    });

    testWidgets(
        'onButtonClicked: triggers fallback timer and drops loader if no page loads',
        (tester) async {
      bool loadingEnded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        fallbackTimeout: const Duration(seconds: 5),
      );

      handler.simulateJsMessage('onButtonClicked');
      expect(loadingEnded, isFalse);

      await tester.pump(const Duration(seconds: 4));
      expect(loadingEnded, isFalse);

      await tester.pump(const Duration(seconds: 2));
      expect(loadingEnded, isTrue);
    });

    testWidgets(
        'onButtonClicked: fallback timer is cancelled if page finishes before timeout',
        (tester) async {
      int loadingEndedCount = 0;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEndedCount++,
        fallbackTimeout: const Duration(seconds: 5),
      );

      handler.simulateJsMessage('onButtonClicked');
      await tester.pump(const Duration(seconds: 2));
      handler.onPageFinished('https://app.zoom.us/wc/active');
      expect(loadingEndedCount, equals(1));

      // Advance past original timeout to verify timer doesn't fire a second time
      await tester.pump(const Duration(seconds: 5));
      expect(loadingEndedCount, equals(1));
    });

    testWidgets('onButtonClicked: fallback timer is cancelled on dispose',
        (tester) async {
      bool loadingEnded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        fallbackTimeout: const Duration(seconds: 5),
      );

      handler.simulateJsMessage('onButtonClicked');
      handler.dispose();

      await tester.pump(const Duration(seconds: 6));
      expect(loadingEnded, isFalse);
    });

    testWidgets(
        'reset(): clears completed auto-join state and allows loading start on retry',
        (tester) async {
      bool loadingStarted = false;
      final handler = _buildHandler(
        onLoadingStart: () => loadingStarted = true,
      );

      // Simulate completion
      handler.simulateJsMessage('onMeetingDetected');
      expect(loadingStarted, isFalse);

      // Verify onPageStarted does not trigger while completed
      handler.onPageStarted('https://zoom.us/j/123456');
      expect(loadingStarted, isFalse);

      // Reset handler (as called onRetry)
      handler.reset();

      // Now onPageStarted should trigger loading start again
      handler.onPageStarted('https://zoom.us/j/123456');
      expect(loadingStarted, isTrue);
    });

    testWidgets('reset(): cancels active fallback timer', (tester) async {
      bool loadingEnded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        fallbackTimeout: const Duration(seconds: 5),
      );

      handler.simulateJsMessage('onButtonClicked');
      handler.reset();

      await tester.pump(const Duration(seconds: 6));
      expect(loadingEnded, isFalse);
    });
  });
}
