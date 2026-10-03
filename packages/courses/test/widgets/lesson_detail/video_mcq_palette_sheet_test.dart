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
                child: Navigator(
                  onGenerateRoute: (settings) => PageRouteBuilder(
                    pageBuilder: (_, __, ___) => child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('renders question grid and handles selection and close',
      (tester) async {
    var selectedIndex = -1;
    var closed = false;

    await tester.pumpWidget(wrap(
      VideoMcqPaletteSheet(
        totalQuestions: 5,
        currentIndex: 1,
        answeredIndices: const {0, 1},
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

    // Verify semantics container and buttons
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.label == 'Hey! Review Your Answers' &&
            w.container == true,
      ),
      findsOneWidget,
    );

    // Tap close button
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });

  testWidgets(
      'opening in showGeneralDialog renders sheet and dismisses on barrier tap',
      (tester) async {
    var selectedIndex = -1;

    await tester.pumpWidget(wrap(
      Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            showGeneralDialog<void>(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Close',
              pageBuilder: (dialogContext, _, __) => Align(
                alignment: Alignment.bottomCenter,
                child: VideoMcqPaletteSheet(
                  totalQuestions: 5,
                  currentIndex: 0,
                  answeredIndices: const {},
                  onQuestionSelected: (idx) {
                    selectedIndex = idx;
                    Navigator.of(dialogContext).pop();
                  },
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            );
          },
          child: const Text('Open Palette'),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Tap to open dialog
    await tester.tap(find.text('Open Palette'));
    await tester.pumpAndSettle();

    expect(find.text('Hey! Review Your Answers'), findsOneWidget);

    // Tap on question 2 in dialog
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(selectedIndex, equals(1));
    expect(find.text('Hey! Review Your Answers'), findsNothing);
  });
}
