import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:exams/exams.dart';
import 'package:exams/screens/subject_analytics/widgets/overall_reports_view.dart';
import 'package:exams/screens/subject_analytics/widgets/individual_reports_view.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith(
          (ref) async => AppDatabase(NativeDatabase.memory()),
        ),
      ],
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

  testWidgets(
    'SubjectAnalyticsScreen with parentId shows tabs and displays Table Reports by default',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          SubjectAnalyticsScreen(
            parentId: '12',
            subjectName: 'Chemistry',
            onBack: () {},
          ),
        ),
      );

      // Verify Chemistry title is rendered
      expect(find.text('Chemistry'), findsOneWidget);

      // Verify tabs are rendered on sub-subject screens
      expect(find.text('Table Reports'), findsOneWidget);
      expect(find.text('Graph Reports'), findsOneWidget);

      // Verify Table Reports (IndividualReportsView) is rendered by default
      expect(find.byType(IndividualReportsView), findsOneWidget);
      expect(find.byType(OverallReportsView), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'SubjectAnalyticsScreen renders Table Reports on left and Graph Reports on right',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          SubjectAnalyticsScreen(
            parentId: null,
            subjectName: 'Test Analytics',
            onBack: () {},
          ),
        ),
      );

      // Verify title is rendered
      expect(find.text('Test Analytics'), findsOneWidget);

      // Verify tab buttons are rendered
      expect(find.text('Table Reports'), findsOneWidget);
      expect(find.text('Graph Reports'), findsOneWidget);

      // Verify Table Reports is on the left of Graph Reports
      final tableTabPos = tester.getTopLeft(find.text('Table Reports'));
      final graphTabPos = tester.getTopLeft(find.text('Graph Reports'));
      expect(tableTabPos.dx < graphTabPos.dx, isTrue);

      // Verify IndividualReportsView is rendered initially by default
      expect(find.byType(IndividualReportsView), findsOneWidget);
      expect(find.byType(OverallReportsView), findsNothing);

      // Switch to Graph Reports tab
      await tester.tap(find.text('Graph Reports'));
      await tester.pump();

      // Verify OverallReportsView is rendered now
      expect(find.byType(OverallReportsView), findsOneWidget);
      expect(find.byType(IndividualReportsView), findsNothing);

      // Switch back to Table Reports tab
      await tester.tap(find.text('Table Reports'));
      await tester.pump();

      // Verify CORRECT, INCORRECT, UNANSWERED headers are center-aligned
      final correctHeader = tester.widget<AppText>(
        find.ancestor(of: find.text('CORRECT'), matching: find.byType(AppText)),
      );
      final incorrectHeader = tester.widget<AppText>(
        find.ancestor(
          of: find.text('INCORRECT'),
          matching: find.byType(AppText),
        ),
      );
      final unansweredHeader = tester.widget<AppText>(
        find.ancestor(
          of: find.text('UNANSWERED'),
          matching: find.byType(AppText),
        ),
      );

      expect(correctHeader.textAlign, TextAlign.center);
      expect(incorrectHeader.textAlign, TextAlign.center);
      expect(unansweredHeader.textAlign, TextAlign.center);

      // Verify no red badge initially (All is active)
      final errorColor = DesignConfig.defaults().colors.error;
      final filterIconFinder = find.byIcon(LucideIcons.filter);
      final filterContainerFinder = find
          .ancestor(
            of: filterIconFinder,
            matching: find.byWidgetPredicate(
              (w) => w is Container && w.constraints?.maxWidth == 48,
            ),
          )
          .first;
      bool hasBadge() {
        return tester.any(
          find.descendant(
            of: filterContainerFinder,
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Container &&
                  w.decoration is BoxDecoration &&
                  (w.decoration as BoxDecoration).color == errorColor &&
                  w.constraints?.maxWidth == 10,
            ),
          ),
        );
      }

      expect(hasBadge(), isFalse);

      // Tap filter icon to open menu
      await tester.tap(find.byIcon(LucideIcons.filter));
      await tester.pump();

      // Tap "Correct" option in menu
      await tester.tap(find.text('Correct'));
      await tester.pump();

      // Verify red badge is now visible
      expect(hasBadge(), isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
