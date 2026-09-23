import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/screens/review_answer/review_answer_detail_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {}
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

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  final testQuestion = QuestionDto(
    id: '101',
    text: '<p>What is Flutter?</p>',
    type: 'singleSelect',
    options: const [
      QuestionOptionDto(id: 'opt1', text: 'SDK', isCorrect: true),
      QuestionOptionDto(id: 'opt2', text: 'Language', isCorrect: false),
    ],
    answerUrl: 'https://example.com/answer/101',
  );

  Widget buildReviewScreen({required InstituteSettings settings}) {
    return ProviderScope(
      overrides: [
        instituteSettingsProvider.overrideWith((ref) => settings),
        bookmarksForLessonProvider(101).overrideWith((ref) => Stream.value([])),
      ],
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: DesignProvider(
            config: DesignConfig.light(),
            child: ReviewAnswerDetailScreen(
              assessmentTitle: 'Sample Exam Review',
              questions: [testQuestion],
              attemptStates: const {},
              onBack: () {},
              skipFetch: true,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'hides Bookmark icon and Ask Doubt button when disabled in settings',
    (tester) async {
      tester.view.physicalSize = const Size(600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final settings = InstituteSettings.fromJson({
        'bookmarks_enabled': false,
        'is_helpdesk_enabled': false,
      });

      await tester.pumpWidget(buildReviewScreen(settings: settings));
      await tester.pumpAndSettle();

      // Bookmark icon should NOT be displayed
      expect(find.byIcon(LucideIcons.bookmark), findsNothing);
      expect(find.byIcon(LucideIcons.bookmarkOff), findsNothing);

      // Ask Doubt button should NOT be displayed
      expect(find.text('Ask Doubt'), findsNothing);

      // Report button should still be displayed
      expect(find.text('Report'), findsOneWidget);
    },
  );

  testWidgets(
    'shows Bookmark icon and Ask Doubt button when enabled in settings',
    (tester) async {
      tester.view.physicalSize = const Size(600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final settings = InstituteSettings.fromJson({
        'bookmarks_enabled': true,
        'is_helpdesk_enabled': true,
      });

      await tester.pumpWidget(buildReviewScreen(settings: settings));
      await tester.pumpAndSettle();

      // Bookmark icon SHOULD be displayed
      expect(find.byIcon(LucideIcons.bookmark), findsOneWidget);

      // Ask Doubt and Report buttons SHOULD both be displayed
      expect(find.text('Ask Doubt'), findsOneWidget);
      expect(find.text('Report'), findsOneWidget);
    },
  );
}
