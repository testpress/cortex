import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/pdf_actions_fab.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
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
    );
  }

  testWidgets(
      'renders single sparkles FAB and triggers onAskAi when doubt is null',
      (tester) async {
    var askAiCalled = false;

    await tester.pumpWidget(wrap(
      PdfActionsFab(
        isExpanded: false,
        onToggle: () {},
        onAskAi: () => askAiCalled = true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.sparkles), findsOneWidget);
    expect(find.text('Ask AI (PDF)'), findsNothing);

    await tester.tap(find.byType(PdfActionsFab));
    await tester.pumpAndSettle();

    expect(askAiCalled, isTrue);
  });

  testWidgets(
      'toggles menu and displays both actions when onAskDoubt is provided',
      (tester) async {
    var expanded = false;
    var askAiCalled = false;
    var askDoubtCalled = false;

    await tester.pumpWidget(wrap(
      StatefulBuilder(
        builder: (context, setState) {
          return PdfActionsFab(
            isExpanded: expanded,
            onToggle: () => setState(() => expanded = !expanded),
            onAskAi: () => askAiCalled = true,
            onAskDoubt: () => askDoubtCalled = true,
          );
        },
      ),
    ));
    await tester.pumpAndSettle();

    // Initially collapsed
    expect(find.byIcon(LucideIcons.sparkles), findsOneWidget);
    expect(find.text('Ask AI (PDF)'), findsNothing);
    expect(find.text('Ask Doubt'), findsNothing);

    // Tap to expand
    await tester.tap(find.byType(PdfActionsFab));
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.x), findsOneWidget);
    expect(find.text('Ask AI (PDF)'), findsOneWidget);
    expect(find.text('Ask Doubt'), findsOneWidget);

    // Tap Ask AI
    await tester.tap(find.text('Ask AI (PDF)'));
    await tester.pumpAndSettle();
    expect(askAiCalled, isTrue);

    // Tap Ask Doubt
    await tester.tap(find.text('Ask Doubt'));
    await tester.pumpAndSettle();
    expect(askDoubtCalled, isTrue);
  });
}
