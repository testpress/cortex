import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:testpress/screens/student_notes_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child, {List<dynamic> overrides = const []}) {
    return ProviderScope(
      overrides: overrides.cast(),
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
                  child: Overlay(
                    initialEntries: [OverlayEntry(builder: (_) => child)],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('StudentNotesScreen', () {
    testWidgets('renders loading state when studentNotesUrl is loading', (
      tester,
    ) async {
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) => Future.any([])),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(find.byType(AppWebView), findsNothing);
    });

    testWidgets('renders error view when studentNotesUrl fails', (
      tester,
    ) async {
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith(
          (ref) => Future.error(Exception('Failed to load SSO URL')),
        ),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.byType(AppWebView), findsNothing);
    });

    testWidgets('renders AppWebView when studentNotesUrl loads successfully', (
      tester,
    ) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsNothing);

      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, resolvedUrl);
    });

    testWidgets('uses custom studentNotesLabel when provided in settings', (
      tester,
    ) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith(
          (ref) => InstituteSettings.fromJson(const {
            'student_notes_enabled': true,
            'student_notes_label': 'My Study Notes',
          }),
        ),
        studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.text('My Study Notes'), findsOneWidget);
    });
  });

  group('isAllowedStudentNotesInAppNavigation', () {
    const domainHost = 'test.testpress.in';

    test(
      'returns true for student notes application routes on the same host',
      () {
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse(
              'https://test.testpress.in/student-diary/my-notes/?testpress_app=1',
            ),
            domainHost,
          ),
          isTrue,
        );
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse('https://test.testpress.in/student-diary/folders/1/'),
            domainHost,
          ),
          isTrue,
        );
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse('https://test.testpress.in/api/v3/student-notes/notes/'),
            domainHost,
          ),
          isTrue,
        );
      },
    );

    test('returns false for external cloud storage and attachment URLs', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://testpress-data.s3.amazonaws.com/uploads/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://google.com'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for pdf files even on notes route', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://test.testpress.in/student-diary/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for non-student-diary routes on the same host', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://test.testpress.in/courses/1/'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for non-http/https schemes', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('mailto:support@testpress.in'),
          domainHost,
        ),
        isFalse,
      );
    });
  });
}
