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
                isLastQuestion: isLastQuestion,
                onToggleMark: () {},
                onPrevious: () {},
                onNext: () {},
                onCheck: () {},
                isQuizMode: isQuizMode,
                isQuizChecked: isQuizChecked,
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
}
