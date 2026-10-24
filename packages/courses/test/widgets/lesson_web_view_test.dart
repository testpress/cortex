import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/lesson_web_view.dart';

void main() {
  group('LessonWebView.handleNavigationRequest', () {
    test('allows navigation when request.url matches initialUrl', () {
      const initialUrl = 'https://teammatesacademy.testpress.in/embed/123';
      const request = NavigationRequest(
        url: initialUrl,
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        initialUrl: initialUrl,
      );

      expect(decision, NavigationDecision.navigate);
    });

    test(
        'prevents navigation and delegates to launchUrl for external http/https URLs',
        () async {
      Uri? launchedUri;
      LaunchMode? launchedMode;

      const request = NavigationRequest(
        url: 'https://meet.google.com/abc-defg-hij',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        initialUrl: 'https://teammatesacademy.testpress.in/embed/123',
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchedUri = uri;
          launchedMode = mode;
          return true;
        },
      );

      expect(decision, NavigationDecision.prevent);
      expect(launchedUri, Uri.parse('https://meet.google.com/abc-defg-hij'));
      expect(launchedMode, LaunchMode.inAppBrowserView);
    });

    test('prevents navigation for non-http/https schemes without launching',
        () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: 'intent://some-host#Intent;scheme=something;end',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.prevent);
      expect(launchCalled, isFalse);
    });

    test('prevents navigation for malformed URLs without crashing', () {
      const request = NavigationRequest(
        url: '://invalid-url',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
      );

      expect(decision, NavigationDecision.prevent);
    });
  });
}
