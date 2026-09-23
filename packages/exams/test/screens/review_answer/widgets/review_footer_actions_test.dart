import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:exams/screens/review_answer/widgets/review_footer_actions.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, _) => Directionality(
        textDirection: TextDirection.ltr,
        child: DesignProvider(config: DesignConfig.light(), child: child),
      ),
    );
  }

  testWidgets(
    'renders both Ask Doubt and Report buttons when both are provided',
    (tester) async {
      bool doubtTapped = false;
      bool reportTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => ReviewFooterActions(
              l10n: L10n.of(context),
              onAskDoubt: () => doubtTapped = true,
              onReport: () => reportTapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ask Doubt'), findsOneWidget);
      expect(find.text('Report'), findsOneWidget);

      await tester.tap(find.text('Ask Doubt'));
      expect(doubtTapped, isTrue);

      await tester.tap(find.text('Report'));
      expect(reportTapped, isTrue);
    },
  );

  testWidgets('renders only Ask Doubt when onReport is null', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        Builder(
          builder: (context) => ReviewFooterActions(
            l10n: L10n.of(context),
            onAskDoubt: () {},
            onReport: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ask Doubt'), findsOneWidget);
    expect(find.text('Report'), findsNothing);
  });

  testWidgets('renders only Report when onAskDoubt is null', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        Builder(
          builder: (context) => ReviewFooterActions(
            l10n: L10n.of(context),
            onAskDoubt: null,
            onReport: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ask Doubt'), findsNothing);
    expect(find.text('Report'), findsOneWidget);
  });

  testWidgets('renders SizedBox.shrink when both callbacks are null', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        Builder(
          builder: (context) => ReviewFooterActions(
            l10n: L10n.of(context),
            onAskDoubt: null,
            onReport: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ask Doubt'), findsNothing);
    expect(find.text('Report'), findsNothing);
    expect(find.byType(ReviewFooterActions), findsOneWidget);
  });
}
