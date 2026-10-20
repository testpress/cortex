import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject({
    ValueChanged<String>? onSend,
    bool enabled = true,
    String? hintText,
    TextEditingController? controller,
    FocusNode? focusNode,
    VoidCallback? onNewChat,
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
        home: Align(
          alignment: Alignment.topCenter,
          child: AiComposer(
            onSend: onSend,
            enabled: enabled,
            hintText: hintText,
            controller: controller,
            focusNode: focusNode,
            onNewChat: onNewChat,
          ),
        ),
      ),
    );
  }

  Color sendButtonColor(WidgetTester tester) {
    final circle = tester.widget<Container>(
      find
          .ancestor(
            of: find.byIcon(LucideIcons.arrowUp),
            matching: find.byType(Container),
          )
          .first,
    );
    return (circle.decoration! as BoxDecoration).color!;
  }

  testWidgets('renders placeholder Message by default', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Message'), findsOneWidget);
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
    expect(find.text('Message'), findsNothing);

    // Tap send button
    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    expect(sentText, equals('Hello AI'));
    // Text cleared after send
    expect(find.text('Message'), findsOneWidget);
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

  testWidgets('renders a 48dp pill with a 32dp send circle in a 48dp target', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(AiComposer)).height,
      moreOrLessEquals(48.0, epsilon: 0.5),
    );

    final sendTarget = find.ancestor(
      of: find.byIcon(LucideIcons.arrowUp),
      matching: find.byType(GestureDetector),
    );
    expect(sendTarget, findsOneWidget);
    expect(tester.getSize(sendTarget), const Size(48.0, 48.0));

    final circle = find
        .ancestor(
          of: find.byIcon(LucideIcons.arrowUp),
          matching: find.byType(Container),
        )
        .first;
    expect(tester.getSize(circle), const Size(32.0, 32.0));
  });

  testWidgets('send circle is faded when empty and solid once text is typed', (
    tester,
  ) async {
    final colors = DesignConfig.defaults().colors;
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(sendButtonColor(tester), colors.textPrimary.withValues(alpha: 0.3));

    await tester.enterText(find.byType(EditableText), 'Hi');
    await tester.pump();
    expect(sendButtonColor(tester), colors.textPrimary);

    // Whitespace alone does not arm the button.
    await tester.enterText(find.byType(EditableText), '   ');
    await tester.pump();
    expect(sendButtonColor(tester), colors.textPrimary.withValues(alpha: 0.3));
  });

  testWidgets('reacts to text set through an external controller', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    String? sentText;
    await tester.pumpWidget(
      buildSubject(
        controller: controller,
        focusNode: focusNode,
        onSend: (text) => sentText = text,
      ),
    );
    await tester.pumpAndSettle();

    controller.text = 'Prefilled prompt';
    await tester.pump();

    expect(find.text('Message'), findsNothing);
    expect(sendButtonColor(tester), DesignConfig.defaults().colors.textPrimary);

    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    expect(sentText, 'Prefilled prompt');
    expect(controller.text, isEmpty);
    expect(focusNode.hasFocus, isFalse);

    // The composer leaves externally owned objects alive when it is removed.
    await tester.pumpWidget(const SizedBox.shrink());
    controller.text = 'still usable';
    expect(controller.text, 'still usable');
  });

  testWidgets('hides the new chat action unless a callback is provided', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.plus), findsNothing);
  });

  testWidgets('shows a new chat action before the input when provided', (
    tester,
  ) async {
    var newChatCount = 0;
    await tester.pumpWidget(buildSubject(onNewChat: () => newChatCount++));
    await tester.pumpAndSettle();

    final newChatTarget = find.ancestor(
      of: find.byIcon(LucideIcons.plus),
      matching: find.byType(GestureDetector),
    );
    expect(newChatTarget, findsOneWidget);
    expect(tester.getSize(newChatTarget), const Size(48.0, 48.0));

    final semantics = tester.widget<Semantics>(
      find.ancestor(of: newChatTarget, matching: find.byType(Semantics)).first,
    );
    expect(semantics.properties.label, 'Start new chat');
    expect(semantics.properties.button, isTrue);

    // The action leads the row, ahead of the text input.
    expect(
      tester.getCenter(find.byIcon(LucideIcons.plus)).dx,
      lessThan(tester.getTopLeft(find.byType(EditableText)).dx),
    );

    await tester.tap(find.byIcon(LucideIcons.plus));
    await tester.pump();
    expect(newChatCount, 1);
  });
}
