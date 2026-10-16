import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:exams/widgets/test_detail/pause_confirmation_dialog.dart';

void main() {
  Widget buildWidget({bool disablePause = false}) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, _) => Directionality(
        textDirection: TextDirection.ltr,
        child: DesignProvider(
          config: DesignConfig.light(),
          child: PauseConfirmationDialog(
            onCancel: () {},
            onPause: () {},
            onEnd: () {},
            disablePause: disablePause,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Cancel, Pause, and End buttons have exact equal width and height, and equal gaps',
    (WidgetTester tester) async {
      for (final screenWidth in [360.0, 390.0, 412.0, 540.0]) {
        tester.view.physicalSize = Size(screenWidth * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(buildWidget(disablePause: false));
        await tester.pumpAndSettle();

        final cancelFinder = find.widgetWithText(AppButton, 'Cancel');
        final pauseFinder = find.widgetWithText(AppButton, 'Pause');
        final endFinder = find.widgetWithText(AppButton, 'End');

        expect(cancelFinder, findsOneWidget);
        expect(pauseFinder, findsOneWidget);
        expect(endFinder, findsOneWidget);

        final cancelSize = tester.getSize(cancelFinder);
        final pauseSize = tester.getSize(pauseFinder);
        final endSize = tester.getSize(endFinder);

        final cancelRect = tester.getRect(cancelFinder);
        final pauseRect = tester.getRect(pauseFinder);
        final endRect = tester.getRect(endFinder);

        final gap1 = pauseRect.left - cancelRect.right;
        final gap2 = endRect.left - pauseRect.right;

        debugPrint('--- Screen Width: $screenWidth dp ---');
        debugPrint('Cancel: size=$cancelSize, rect=$cancelRect');
        debugPrint('Pause:  size=$pauseSize, rect=$pauseRect');
        debugPrint('End:    size=$endSize, rect=$endRect');
        debugPrint('Gap 1:  $gap1, Gap 2: $gap2');

        expect(cancelSize.width, closeTo(pauseSize.width, 0.001));
        expect(pauseSize.width, closeTo(endSize.width, 0.001));

        expect(cancelSize.height, equals(48.0));
        expect(pauseSize.height, equals(48.0));
        expect(endSize.height, equals(48.0));

        expect(gap1, closeTo(8.0, 0.001));
        expect(gap2, closeTo(8.0, 0.001));
      }
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    },
  );

  testWidgets(
    'When disablePause is true, Cancel and End buttons have exact equal width and height',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildWidget(disablePause: true));
      await tester.pumpAndSettle();

      final cancelFinder = find.widgetWithText(AppButton, 'Cancel');
      final endFinder = find.widgetWithText(AppButton, 'End');

      expect(cancelFinder, findsOneWidget);
      expect(endFinder, findsOneWidget);

      final cancelSize = tester.getSize(cancelFinder);
      final endSize = tester.getSize(endFinder);

      debugPrint('Measured (disablePause) Cancel Size: $cancelSize');
      debugPrint('Measured (disablePause) End Size: $endSize');

      expect(cancelSize.width, equals(endSize.width));
      expect(cancelSize.height, equals(endSize.height));
    },
  );
}
