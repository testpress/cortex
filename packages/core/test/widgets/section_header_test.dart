import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child) {
    return MediaQuery(
      data: const MediaQueryData(padding: EdgeInsets.only(top: 40)),
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    );
  }

  group('SectionHeader', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(wrap(const SectionHeader(title: 'My Title')));
      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('renders leading widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SectionHeader(
            title: 'Test',
            leadingIcon: Text('LeadingWidget'),
          ),
        ),
      );
      expect(find.text('LeadingWidget'), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SectionHeader(
            title: 'Test',
            trailingAction: Text('TrailingWidget'),
          ),
        ),
      );
      expect(find.text('TrailingWidget'), findsOneWidget);
    });

    testWidgets('renders bottomContent widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SectionHeader(
            title: 'Test',
            secondaryContent: Text('BottomWidget'),
          ),
        ),
      );
      expect(find.text('BottomWidget'), findsOneWidget);
    });

    testWidgets('title has header semantics', (tester) async {
      await tester.pumpWidget(
        wrap(const SectionHeader(title: 'Semantics Title')),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.header == true &&
            widget.properties.label == 'Semantics Title',
      );

      expect(semanticsFinder, findsOneWidget);
    });
  });
}
