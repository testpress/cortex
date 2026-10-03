import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/mcq/video_mcq_palette_sheet.dart';

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
                child: Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (context) => Stack(children: [child]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('renders question grid and handles selection and close', (tester) async {
    var selectedIndex = -1;
    var closed = false;

    await tester.pumpWidget(wrap(
      VideoMcqPaletteSheet(
        totalQuestions: 5,
        currentIndex: 1,
        checkedIndices: const {0, 1},
        onQuestionSelected: (idx) => selectedIndex = idx,
        onClose: () => closed = true,
      ),
    ));
    await tester.pumpAndSettle();

    // Verify title and answered count
    expect(find.text('Hey! Review Your Answers'), findsOneWidget);
    expect(find.text('2 of 5 answered'), findsOneWidget);

    // Verify legend
    expect(find.text('Unanswered'), findsOneWidget);
    expect(find.text('Answered'), findsOneWidget);

    // Verify all 5 question number tiles
    for (var i = 1; i <= 5; i++) {
      expect(find.text('$i'), findsOneWidget);
    }

    // Tap on Question 4 (index 3)
    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    expect(selectedIndex, equals(3));

    // Tap close button
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });
}
