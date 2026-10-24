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

  group('AppHtmlV2.sanitizeHtml table sanitization', () {
    test(
      'strips legacy height attributes from table elements but keeps them on images',
      () {
        const input =
            '<table height="100"><tr height="20"><td height="10"><img src="test.png" height="50" /></td></tr></table>';
        final output = AppHtmlV2.sanitizeHtml(input);

        expect(output, contains('<table>'));
        expect(output, contains('<tr>'));
        expect(output, contains('<td>'));
        expect(output, contains('<img src="test.png" height="50" />'));
      },
    );

    test(
      'strips restrictive height and line-height styles from table elements while keeping other styles',
      () {
        const input =
            '<td style="text-align: center; height: 10px; line-height: 8px; font-weight: bold;">Cell</td>';
        final output = AppHtmlV2.sanitizeHtml(input);

        expect(
          output,
          equals('<td style="text-align: center; font-weight: bold">Cell</td>'),
        );
      },
    );

    test(
      'removes style attribute entirely if only height properties were present',
      () {
        const input =
            '<tr style="height: 15px; line-height: 10px;"><td>Text</td></tr>';
        final output = AppHtmlV2.sanitizeHtml(input);

        expect(output, equals('<tr><td>Text</td></tr>'));
      },
    );

    test('handles multiline inline styles on table elements', () {
      const input = '''<th style="
        height: 12px;
        line-height: 8px;
        font-weight: bold;
      ">Header</th>''';
      final output = AppHtmlV2.sanitizeHtml(input);

      expect(output, contains('font-weight: bold'));
      expect(output, isNot(contains('height')));
      expect(output, isNot(contains('line-height')));
    });

    test(
      'strips legacy height attributes and inline styles with single quotes',
      () {
        const input =
            "<table height='100'><tr height='20'><td height='10' style='height: 10px; line-height: 8px; font-weight: bold;'>Cell</td></tr></table>";
        final output = AppHtmlV2.sanitizeHtml(input);

        expect(output, contains('<table>'));
        expect(output, contains('<tr>'));
        expect(output, contains("style='"));
        expect(output, contains('font-weight: bold'));
        expect(output, isNot(contains('height')));
        expect(output, isNot(contains('line-height')));
      },
    );

    test('handles multiline single-quoted inline styles on table elements', () {
      const input = """<td style='
        height: 14px;
        line-height: 10px;
        text-align: center;
      '>Multiline Content</td>""";
      final output = AppHtmlV2.sanitizeHtml(input);

      expect(output, contains('text-align: center'));
      expect(output, isNot(contains('height:')));
      expect(output, isNot(contains('line-height:')));
    });
  });

  group('AppHtmlV2 table rendering tests', () {
    testWidgets(
      'renders table with restrictive heights identically to unconstrained table',
      (tester) async {
        const cleanHtml = '''
<p><em>The table below shows the number of students in 5 schools:</em></p>
<table border="1" style="width:100%;">
  <tbody>
    <tr>
      <th>School</th>
      <th>Total</th>
      <th>Boys: Girls</th>
    </tr>
    <tr>
      <td>A</td>
      <td>360</td>
      <td>7 : 5</td>
    </tr>
    <tr>
      <td>B</td>
      <td>345</td>
      <td>15 : 8</td>
    </tr>
  </tbody>
</table>
''';

        const restrictiveHtml = '''
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

        // 1. Measure natural heights from clean unconstrained HTML
        await tester.pumpWidget(
          wrap(
            const SingleChildScrollView(
              child: AppHtmlV2(data: cleanHtml, fontSize: 16.0),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final cleanHeaderHeight = tester.getSize(findRichText('School')).height;
        final cleanCellHeightA = tester.getSize(findRichText('A')).height;
        final cleanCellHeight360 = tester.getSize(findRichText('360')).height;

        // Verify natural height is unconstrained
        expect(cleanHeaderHeight, greaterThanOrEqualTo(18.0));
        expect(cleanCellHeightA, greaterThanOrEqualTo(18.0));
        expect(cleanCellHeight360, greaterThanOrEqualTo(18.0));

        // 2. Measure heights from restrictive HTML
        await tester.pumpWidget(
          wrap(
            const SingleChildScrollView(
              child: AppHtmlV2(data: restrictiveHtml, fontSize: 16.0),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final restrictiveHeaderHeight = tester
            .getSize(findRichText('School'))
            .height;
        final restrictiveCellHeightA = tester.getSize(findRichText('A')).height;
        final restrictiveCellHeight360 = tester
            .getSize(findRichText('360'))
            .height;

        // 3. Compare: restrictive HTML must render with the exact same height as clean HTML
        expect(
          restrictiveHeaderHeight,
          equals(cleanHeaderHeight),
          reason: 'Header text height must match unconstrained table rendering',
        );
        expect(
          restrictiveCellHeightA,
          equals(cleanCellHeightA),
          reason: 'Cell "A" height must match unconstrained table rendering',
        );
        expect(
          restrictiveCellHeight360,
          equals(cleanCellHeight360),
          reason: 'Cell "360" height must match unconstrained table rendering',
        );
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

        final richTextFinder = findRichText('Centered Bold');
        expect(richTextFinder, findsOneWidget);

        final richText = tester.widget<RichText>(richTextFinder);
        expect(richText.textAlign, equals(TextAlign.center));
        expect(richText.text.style?.fontWeight, equals(FontWeight.bold));
      },
    );

    testWidgets(
      'renders table with multiline and single-quoted height styles without clipping',
      (tester) async {
        const html = """
<table border='1' style='width: 100%; height: 30px;'>
  <tbody>
    <tr height='12' style='
      height: 12px;
      line-height: 8px;
    '>
      <td height='10' style='
        height: 10px;
        line-height: 8px;
        text-align: center;
        font-weight: bold;
      '>Single Quoted Multiline</td>
    </tr>
  </tbody>
</table>
""";

        await tester.pumpWidget(
          wrap(
            const SingleChildScrollView(
              child: AppHtmlV2(data: html, fontSize: 16.0),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final richTextFinder = findRichText('Single Quoted Multiline');
        expect(richTextFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(richTextFinder);
        expect(renderBox.size.height, greaterThanOrEqualTo(18.0));

        final richText = tester.widget<RichText>(richTextFinder);
        expect(richText.textAlign, equals(TextAlign.center));
        expect(richText.text.style?.fontWeight, equals(FontWeight.bold));
      },
    );
  });
}
