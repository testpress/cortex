import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject({
    ValueChanged<String>? onSend,
    bool enabled = true,
    String? hintText,
  }) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: AiComposer(onSend: onSend, enabled: enabled, hintText: hintText),
      ),
    );
  }

  testWidgets('renders placeholder Ask AI support by default', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Ask AI support'), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowUp), findsOneWidget);
  });

  testWidgets('renders custom placeholder when provided', (tester) async {
    await tester.pumpWidget(buildSubject(hintText: 'Custom hint'));
    await tester.pumpAndSettle();

    expect(find.text('Custom hint'), findsOneWidget);
  });

  testWidgets('typing text updates controller and send button state', (
    tester,
  ) async {
    String? sentText;
    await tester.pumpWidget(buildSubject(onSend: (text) => sentText = text));
    await tester.pumpAndSettle();

    final editable = find.byType(EditableText);
    expect(editable, findsOneWidget);

    await tester.enterText(editable, 'Hello AI');
    await tester.pump();

    // Placeholder disappears
    expect(find.text('Ask AI support'), findsNothing);

    // Tap send button
    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    expect(sentText, equals('Hello AI'));
    // Text cleared after send
    expect(find.text('Ask AI support'), findsOneWidget);
  });

  testWidgets('send button does not submit when empty or disabled', (
    tester,
  ) async {
    String? sentText;
    await tester.pumpWidget(
      buildSubject(onSend: (text) => sentText = text, enabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    expect(sentText, isNull);
  });
}
