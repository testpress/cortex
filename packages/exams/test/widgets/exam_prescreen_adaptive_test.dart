import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:exams/widgets/exam_prescreen_mark_card.dart';
import 'package:exams/widgets/exam_prescreen_action_button.dart';

void main() {
  Widget buildAppWith(Widget child, {double width = 320}) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, _) => Directionality(
        textDirection: TextDirection.ltr,
        child: DesignProvider(
          config: DesignConfig.light(),
          child: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'ExamPrescreenMarkCard renders without overflow in narrow 130px container',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildAppWith(
          Builder(
            builder: (context) => ExamPrescreenMarkCard(
              design: Design.of(context),
              icon: LucideIcons.checkCircle2,
              color: const Color(0xFF00AA00),
              label: 'Correct Answer',
              value: '+1 Marks',
            ),
          ),
          width: 130,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Correct Answer'), findsOneWidget);
      expect(find.text('+1 Marks'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ExamPrescreenActionButton stacks vertically on compact viewport (< 360)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildAppWith(
          const ExamPrescreenActionButton(
            isButtonEnabled: true,
            isResuming: false,
            isRetaking: true,
          ),
          width: 320,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
      expect(find.text('Retake'), findsOneWidget);
      expect(find.text('Retake Incorrect'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ExamPrescreenActionButton displays side-by-side Row on standard viewport (>= 360)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildAppWith(
          const ExamPrescreenActionButton(
            isButtonEnabled: true,
            isResuming: false,
            isRetaking: true,
          ),
          width: 400,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      expect(find.text('Retake'), findsOneWidget);
      expect(find.text('Retake Incorrect'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
