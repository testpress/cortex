import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:core/data/data.dart';
import 'package:exams/exams.dart';
import 'package:exams/screens/subject_analytics/widgets/overall_reports_view.dart';
import 'package:exams/screens/subject_analytics/widgets/individual_reports_view.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) async => AppDatabase(NativeDatabase.memory())),
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

  testWidgets('SubjectAnalyticsScreen renders start-aligned title and tab buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        SubjectAnalyticsScreen(
          parentId: null,
          subjectName: 'Test Analytics',
          onBack: () {},
        ),
      ),
    );

    // Verify centered title is rendered
    expect(find.text('Test Analytics'), findsOneWidget);

    // Verify tab buttons are rendered
    expect(find.text('Overall Reports'), findsOneWidget);
    expect(find.text('Individual Reports'), findsOneWidget);

    // Verify OverallReportsView is rendered initially
    expect(find.byType(OverallReportsView), findsOneWidget);
    expect(find.byType(IndividualReportsView), findsNothing);

    // Switch to Individual Reports tab
    await tester.tap(find.text('Individual Reports'));
    await tester.pumpAndSettle();

    // Verify IndividualReportsView is rendered now
    expect(find.byType(OverallReportsView), findsNothing);
    expect(find.byType(IndividualReportsView), findsOneWidget);

    // Verify CORRECT, INCORRECT, UNANSWERED headers are center-aligned
    final correctHeader = tester.widget<AppText>(
      find.ancestor(of: find.text('CORRECT'), matching: find.byType(AppText)),
    );
    final incorrectHeader = tester.widget<AppText>(
      find.ancestor(of: find.text('INCORRECT'), matching: find.byType(AppText)),
    );
    final unansweredHeader = tester.widget<AppText>(
      find.ancestor(of: find.text('UNANSWERED'), matching: find.byType(AppText)),
    );

    expect(correctHeader.textAlign, TextAlign.center);
    expect(incorrectHeader.textAlign, TextAlign.center);
    expect(unansweredHeader.textAlign, TextAlign.center);

    // Verify no red badge initially (All is active)
    final errorColor = DesignConfig.defaults().colors.error;
    final filterIconFinder = find.byIcon(LucideIcons.filter);
    final filterContainerFinder = find.ancestor(
      of: filterIconFinder,
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 36,
      ),
    ).first;
    bool hasBadge() {
      return tester.any(
        find.descendant(
          of: filterContainerFinder,
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).color == errorColor &&
                w.constraints?.maxWidth == 8,
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

    // Clean up the widget tree to dispose of the providers and database,
    // and pump the event loop to run and clear any pending database stream timers.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
