import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:exams/widgets/test_detail/test_navigation_actions.dart';
import 'package:exams/widgets/test_detail/nav_button.dart';

void main() {
  Widget createWidgetUnderTest({
    required bool isQuizMode,
    required bool isQuizChecked,
    required bool isLastQuestion,
    bool canGoNext = true,
    String? finishLabel,
    VoidCallback? onNext,
    bool hasAnswer = false,
    VoidCallback? onClearResponse,
  }) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            return DesignProvider(
              config: DesignConfig.light(),
              child: TestNavigationActions(
                isMarked: false,
                canGoPrevious: true,
                canGoNext: canGoNext,
                isLastQuestion: isLastQuestion,
                finishLabel: finishLabel,
                onToggleMark: () {},
                onPrevious: () {},
                onNext: onNext ?? () {},
                onCheck: () {},
                isQuizMode: isQuizMode,
                isQuizChecked: isQuizChecked,
                hasAnswer: hasAnswer,
                onClearResponse: onClearResponse,
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets(
    'TestNavigationActions shows Next normally when not in quiz mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: false,
        ),
      );
      await tester.pumpAndSettle();

      final nextButton = find.widgetWithText(NavButton, 'Next');
      expect(nextButton, findsOneWidget);

      final checkButton = find.widgetWithText(NavButton, 'Check');
      expect(checkButton, findsNothing);
    },
  );

  testWidgets(
    'TestNavigationActions shows Check and hides Next before check in quiz mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: true,
          isQuizChecked: false,
          isLastQuestion: false,
        ),
      );
      await tester.pumpAndSettle();

      final checkButton = find.widgetWithText(NavButton, 'Check');
      expect(checkButton, findsOneWidget);

      final nextButton = find.widgetWithText(NavButton, 'Next');
      expect(nextButton, findsNothing);
      final continueButton = find.widgetWithText(NavButton, 'Continue');
      expect(continueButton, findsNothing);
    },
  );

  testWidgets(
    'TestNavigationActions shows Continue and hides Check after check in quiz mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: true,
          isQuizChecked: true,
          isLastQuestion: false,
        ),
      );
      await tester.pumpAndSettle();

      final continueButton = find.widgetWithText(NavButton, 'Continue');
      expect(continueButton, findsOneWidget);

      final checkButton = find.widgetWithText(NavButton, 'Check');
      expect(checkButton, findsNothing);

      // Asserts no "Try Again" is present
      final tryAgainButton = find.widgetWithText(NavButton, 'Try Again');
      expect(tryAgainButton, findsNothing);
    },
  );

  testWidgets(
    'TestNavigationActions disables Next button when canGoNext is false',
    (WidgetTester tester) async {
      bool nextInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: false,
          canGoNext: false,
          onNext: () => nextInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final nextFinder = find.widgetWithText(NavButton, 'Next');
      expect(nextFinder, findsOneWidget);

      await tester.tap(nextFinder);
      await tester.pumpAndSettle();

      expect(nextInvoked, isFalse);
    },
  );

  testWidgets('TestNavigationActions invokes onNext when canGoNext is true', (
    WidgetTester tester,
  ) async {
    bool nextInvoked = false;

    await tester.pumpWidget(
      createWidgetUnderTest(
        isQuizMode: false,
        isQuizChecked: false,
        isLastQuestion: false,
        canGoNext: true,
        onNext: () => nextInvoked = true,
      ),
    );
    await tester.pumpAndSettle();

    final nextFinder = find.widgetWithText(NavButton, 'Next');
    expect(nextFinder, findsOneWidget);

    await tester.tap(nextFinder);
    await tester.pumpAndSettle();

    expect(nextInvoked, isTrue);
  });

  testWidgets(
    'TestNavigationActions disables Finish button on last question when canGoNext is false',
    (WidgetTester tester) async {
      bool finishInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: true,
          canGoNext: false,
          onNext: () => finishInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final finishFinder = find.widgetWithText(NavButton, 'Finish');
      expect(finishFinder, findsOneWidget);

      await tester.tap(finishFinder);
      await tester.pumpAndSettle();

      expect(finishInvoked, isFalse);
    },
  );

  testWidgets(
    'TestNavigationActions invokes onNext on last question (Finish) when canGoNext is true',
    (WidgetTester tester) async {
      bool finishInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: true,
          canGoNext: true,
          onNext: () => finishInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final finishFinder = find.widgetWithText(NavButton, 'Finish');
      expect(finishFinder, findsOneWidget);

      await tester.tap(finishFinder);
      await tester.pumpAndSettle();

      expect(finishInvoked, isTrue);
    },
  );

  testWidgets(
    'TestNavigationActions disables custom finishLabel (Next Section) when canGoNext is false',
    (WidgetTester tester) async {
      bool nextSectionInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: true,
          finishLabel: 'Next Section',
          canGoNext: false,
          onNext: () => nextSectionInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final nextSectionFinder = find.widgetWithText(NavButton, 'Next Section');
      expect(nextSectionFinder, findsOneWidget);

      await tester.tap(nextSectionFinder);
      await tester.pumpAndSettle();

      expect(nextSectionInvoked, isFalse);
    },
  );

  testWidgets(
    'TestNavigationActions invokes onNext for custom finishLabel (Next Section) when canGoNext is true',
    (WidgetTester tester) async {
      bool nextSectionInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: true,
          finishLabel: 'Next Section',
          canGoNext: true,
          onNext: () => nextSectionInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final nextSectionFinder = find.widgetWithText(NavButton, 'Next Section');
      expect(nextSectionFinder, findsOneWidget);

      await tester.tap(nextSectionFinder);
      await tester.pumpAndSettle();

      expect(nextSectionInvoked, isTrue);
    },
  );

  testWidgets(
    'TestNavigationActions shows Clear Response when hasAnswer is true and invokes callback',
    (WidgetTester tester) async {
      bool clearInvoked = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: false,
          hasAnswer: true,
          onClearResponse: () => clearInvoked = true,
        ),
      );
      await tester.pumpAndSettle();

      final clearFinder = find.text('Clear Response');
      expect(clearFinder, findsOneWidget);

      await tester.tap(clearFinder);
      await tester.pumpAndSettle();

      expect(clearInvoked, isTrue);
    },
  );

  testWidgets(
    'TestNavigationActions hides Clear Response when hasAnswer is false',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: false,
          hasAnswer: false,
          onClearResponse: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Clear Response'), findsNothing);
    },
  );

  testWidgets(
    'TestNavigationActions hides Clear Response in quiz mode after check',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: true,
          isQuizChecked: true,
          isLastQuestion: false,
          hasAnswer: true,
          onClearResponse: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Clear Response'), findsNothing);
    },
  );

  testWidgets(
    'Clear Response button has button semantics and matches Mark for Review styling',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          isQuizMode: false,
          isQuizChecked: false,
          isLastQuestion: false,
          hasAnswer: true,
          onClearResponse: () {},
        ),
      );
      await tester.pumpAndSettle();

      final clearFinder = find.text('Clear Response');
      expect(clearFinder, findsOneWidget);

      final clearTextWidget = tester.widget<AppText>(
        find.widgetWithText(AppText, 'Clear Response'),
      );
      expect(clearTextWidget.style?.fontSize, 13);
      expect(clearTextWidget.style?.fontWeight, FontWeight.w600);

      final semanticsFinder = find.ancestor(
        of: clearFinder,
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true,
        ),
      );
      expect(semanticsFinder, findsOneWidget);
    },
  );
}
