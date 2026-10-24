import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/app_html_v2.dart';
import 'package:core/design/design_config.dart';
import 'package:core/design/design_provider.dart';

Finder findRichText(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText() == text,
  );
}

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('AppHtmlV2 table rendering tests', () {
    testWidgets(
      'strips restrictive inline heights and legacy height attributes from table elements',
      (tester) async {
        const html = '''
<p><em>The table below shows the number of students in 5 schools:</em></p>
<table border="1" style="width:100%; height: 30px;">
  <tbody>
    <tr height="12" style="height: 12px; line-height: 8px;">
      <th height="10" style="height: 10px; line-height: 8px;">School</th>
      <th height="10" style="height: 10px; line-height: 8px;">Total</th>
      <th height="10" style="height: 10px; line-height: 8px;">Boys: Girls</th>
    </tr>
    <tr height="12" style="height: 12px; line-height: 8px;">
      <td height="10" style="height: 10px; line-height: 8px;">A</td>
      <td height="10" style="height: 10px; line-height: 8px;">360</td>
      <td height="10" style="height: 10px; line-height: 8px;">7 : 5</td>
    </tr>
    <tr height="12" style="height: 12px; line-height: 8px;">
      <td height="10" style="height: 10px; line-height: 8px;">B</td>
      <td height="10" style="height: 10px; line-height: 8px;">345</td>
      <td height="10" style="height: 10px; line-height: 8px;">15 : 8</td>
    </tr>
  </tbody>
</table>
''';

        await tester.pumpWidget(
          wrap(
            const SingleChildScrollView(
              child: AppHtmlV2(data: html, fontSize: 16.0),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify all cells render in RichText
        expect(findRichText('School'), findsOneWidget);
        expect(findRichText('Total'), findsOneWidget);
        expect(findRichText('Boys: Girls'), findsOneWidget);
        expect(findRichText('A'), findsOneWidget);
        expect(findRichText('360'), findsOneWidget);
        expect(findRichText('7 : 5'), findsOneWidget);
        expect(findRichText('B'), findsOneWidget);
        expect(findRichText('345'), findsOneWidget);
        expect(findRichText('15 : 8'), findsOneWidget);

        // Verify that rendered text boxes are NOT squashed/clipped to the restrictive 10px height
        final textFinders = find.byType(RichText);
        for (final element in textFinders.evaluate()) {
          final widget = element.widget as RichText;
          final plainText = widget.text.toPlainText();
          if (plainText == 'School' || plainText == '360' || plainText == 'A') {
            final renderBox = element.renderObject as RenderBox;
            // With 16px font size, line height should be >= 18px (not constrained to 10px/12px)
            expect(
              renderBox.size.height,
              greaterThanOrEqualTo(18.0),
              reason:
                  'Cell text "$plainText" should not be compressed by restrictive height',
            );
          }
        }
      },
    );

    testWidgets(
      'preserves non-height styles on table elements while stripping height',
      (tester) async {
        const html = '''
<table>
  <tbody>
    <tr>
      <td style="text-align: center; height: 10px; font-weight: bold;">Centered Bold</td>
    </tr>
  </tbody>
</table>
''';

        await tester.pumpWidget(
          wrap(const SingleChildScrollView(child: AppHtmlV2(data: html))),
        );
        await tester.pumpAndSettle();

        expect(findRichText('Centered Bold'), findsOneWidget);
      },
    );
  });
}
