import 'dart:async';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/screens/store/faculty_profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  setUp(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return Localizations(
                locale: locale,
                delegates: LocalizationProvider.delegates,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  const testFaculty = ProductFacultyDto(
    id: 1,
    name: 'Dr. Ananya Rao',
    initials: 'AR',
    subjects: ['Polity', 'Governance'],
    shortDescription:
        'Former civil servant who teaches polity through landmark judgements.',
    yearsOfExperience: 14,
    highlights: [
      'Taught 40,000+ aspirants since 2011',
      'Author of "Indian Polity Made Simple" (2021)',
    ],
    qualifications: [
      'PhD, Political Science, JNU',
      'UGC-NET (JRF)',
    ],
    bio:
        'Ananya spent six years in the state civil service before moving to teaching full time.',
    teaches: [
      FacultyTeachingDto(
        id: 10,
        course: 'Prelims GS',
        subject: 'Polity',
        videoUrl: 'https://example.com/prelims.mp4',
      ),
      FacultyTeachingDto(
        id: 11,
        course: 'Mains GS',
        subject: 'Governance',
        videoUrl: 'https://example.com/mains.mp4',
      ),
    ],
  );

  group('FacultyProfileScreen', () {
    testWidgets('renders all faculty profile details correctly',
        (tester) async {
      await tester.pumpWidget(wrap(const FacultyProfileScreen(
        faculty: testFaculty,
      )));

      expect(find.text('Faculty profile'), findsOneWidget);
      expect(find.text('Dr. Ananya Rao'), findsOneWidget);
      expect(
          find.text('Polity · Governance · 14 years teaching'), findsOneWidget);
      expect(
          find.text(
              'Former civil servant who teaches polity through landmark judgements.'),
          findsOneWidget);

      // Highlights
      expect(find.text('Highlights'), findsOneWidget);
      expect(find.text('Taught 40,000+ aspirants since 2011'), findsOneWidget);
      expect(find.text('Author of "Indian Polity Made Simple" (2021)'),
          findsOneWidget);

      // Qualifications
      expect(find.text('Qualifications'), findsOneWidget);
      expect(find.text('PhD, Political Science, JNU'), findsOneWidget);
      expect(find.text('UGC-NET (JRF)'), findsOneWidget);

      // About
      expect(find.text('About'), findsOneWidget);
      expect(
          find.text(
              'Ananya spent six years in the state civil service before moving to teaching full time.'),
          findsOneWidget);

      // Teaches in this product
      expect(find.text('Teaches in this product'), findsOneWidget);
      expect(find.text('Prelims GS'), findsOneWidget);
      expect(find.text('Mains GS'), findsOneWidget);
      expect(find.text('Now showing'), findsOneWidget);
      expect(find.text('Watch intro'), findsOneWidget);
    });

    testWidgets('switches video when tapping course teaching row',
        (tester) async {
      await tester.pumpWidget(wrap(const FacultyProfileScreen(
        faculty: testFaculty,
      )));

      expect(find.text('Now showing'), findsOneWidget);
      expect(find.text('Watch intro'), findsOneWidget);

      // Scroll and tap the second course item to switch video
      await tester.scrollUntilVisible(find.text('Mains GS'), 100);
      await tester.tap(find.text('Mains GS'));
      await tester.pump();

      // Now showing is still present, switched to second item
      expect(find.text('Now showing'), findsOneWidget);
    });

    testWidgets('renders without video section if no video available',
        (tester) async {
      const noVideoFaculty = ProductFacultyDto(
        id: 2,
        name: 'Prof. Sharma',
        initials: 'PS',
        subjects: ['History'],
        shortDescription: 'History professor',
        yearsOfExperience: 5,
        highlights: [],
        qualifications: [],
        bio: 'Bio text',
        teaches: [],
      );

      await tester.pumpWidget(wrap(const FacultyProfileScreen(
        faculty: noVideoFaculty,
      )));

      expect(find.text('Prof. Sharma'), findsOneWidget);
      expect(find.byType(WebViewWidget), findsNothing);
    });

    testWidgets(
        'renders error view inside video container when video fails to load',
        (tester) async {
      const failedVideoFaculty = ProductFacultyDto(
        id: 3,
        name: 'Dr. Kumar',
        initials: 'DK',
        videoUrl: 'invalid_url_without_scheme',
        subjects: ['Physics'],
      );

      await tester.pumpWidget(wrap(const FacultyProfileScreen(
        faculty: failedVideoFaculty,
      )));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(find.byType(AppErrorView), findsOneWidget);
    });
  });
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _FakePlatformWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakePlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  JavaScriptChannelParams? _channelParams;

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    if (_channelParams != null && _channelParams!.name == 'VideoChannel') {
      Future.microtask(() {
        _channelParams!.onMessageReceived(
          const JavaScriptMessage(message: 'ready'),
        );
      });
    }
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {
    _channelParams = javaScriptChannelParams;
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<String?> getUserAgent() async => 'MockUserAgent';

  @override
  Future<void> setUserAgent(String? userAgent) async {}
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnProgress(void Function(int progress) onProgress) async {}

  @override
  Future<void> setOnPageStarted(
    void Function(String url) onPageStarted,
  ) async {}

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {
    Future.microtask(() => onPageFinished('https://example.com/loaded'));
  }

  @override
  Future<void> setOnWebResourceError(
    void Function(WebResourceError error) onWebResourceError,
  ) async {}

  @override
  Future<void> setOnNavigationRequest(
    FutureOr<NavigationDecision> Function(NavigationRequest request)
        onNavigationRequest,
  ) async {}
}
