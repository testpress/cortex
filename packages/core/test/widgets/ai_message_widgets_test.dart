import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const columnWidth = 400.0;
  const longMessage =
      'Show me similar practice questions about momentum, impulse, and '
      'collisions so I can revise before the test';

  final radius = DesignConfig.defaults().radius;
  final colors = DesignConfig.defaults().colors;

  Widget buildSubject(
    Widget child, {
    TextDirection textDirection = TextDirection.ltr,
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
        home: Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: columnWidth, child: child),
          ),
        ),
      ),
    );
  }

  Finder bubbleOf(Finder content) {
    return find.ancestor(of: content, matching: find.byType(Container)).first;
  }

  BoxDecoration decorationOf(WidgetTester tester, Finder container) {
    return tester.widget<Container>(container).decoration! as BoxDecoration;
  }

  group('AiUserMessageBubble', () {
    testWidgets('caps the bubble at 75% of the column on the end side', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(message: longMessage, timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final column = tester.getRect(find.byType(AiUserMessageBubble));
      final bubble = tester.getRect(bubbleOf(find.text(longMessage)));

      expect(bubble.width, moreOrLessEquals(columnWidth * 0.75, epsilon: 0.5));
      expect(bubble.right, moreOrLessEquals(column.right, epsilon: 0.5));
    });

    testWidgets('hugs short messages instead of filling the width', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(message: 'Hi', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final bubble = tester.getRect(bubbleOf(find.text('Hi')));
      expect(bubble.width, lessThan(columnWidth * 0.5));
    });

    testWidgets('uses the tinted bubble with a tightened top-end corner', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(message: 'Hi', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final decoration = decorationOf(tester, bubbleOf(find.text('Hi')));
      expect(decoration.color, colors.surfaceVariant);
      expect(
        decoration.borderRadius,
        BorderRadiusDirectional.only(
          topStart: Radius.circular(radius.xl),
          topEnd: Radius.circular(radius.md),
          bottomStart: Radius.circular(radius.xl),
          bottomEnd: Radius.circular(radius.xl),
        ),
      );
    });

    testWidgets('places the timestamp below the bubble, flush with its end', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(message: 'Hi', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final bubble = tester.getRect(bubbleOf(find.text('Hi')));
      final timestamp = tester.getRect(find.text('14:36'));

      expect(timestamp.top, greaterThan(bubble.bottom));
      expect(timestamp.right, moreOrLessEquals(bubble.right, epsilon: 0.5));
    });

    testWidgets('mirrors to the start edge in right-to-left layouts', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(message: 'Hi', timestamp: '14:36'),
          textDirection: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();

      final column = tester.getRect(find.byType(AiUserMessageBubble));
      final bubble = tester.getRect(bubbleOf(find.text('Hi')));
      expect(bubble.left, moreOrLessEquals(column.left, epsilon: 0.5));
    });

    testWidgets('replaces the timestamp with a sending label while in flight', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiUserMessageBubble(
            message: 'Hi',
            timestamp: '14:36',
            isSending: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sending...'), findsOneWidget);
      expect(find.text('14:36'), findsNothing);
    });

    testWidgets('shows a retry action instead of the timestamp on failure', (
      tester,
    ) async {
      var retryCount = 0;
      await tester.pumpWidget(
        buildSubject(
          AiUserMessageBubble(
            message: 'Hi',
            timestamp: '14:36',
            hasSendError: true,
            onRetry: () => retryCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('14:36'), findsNothing);
      expect(find.text("Couldn't send message. "), findsOneWidget);
      expect(find.byIcon(LucideIcons.alertCircle), findsOneWidget);

      await tester.tap(find.text('Tap to retry'));
      await tester.pump();
      expect(retryCount, 1);
    });
  });

  group('AiAssistantCard', () {
    testWidgets('caps the card at 75% of the column on the start side', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiAssistantCard(message: longMessage, timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final column = tester.getRect(find.byType(AiAssistantCard));
      final card = tester.getRect(bubbleOf(find.byType(AppMarkdown)));

      expect(card.width, lessThanOrEqualTo(columnWidth * 0.75 + 0.5));
      expect(card.left, moreOrLessEquals(column.left, epsilon: 0.5));
    });

    testWidgets('uses a bordered card with a tightened top-start corner', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiAssistantCard(message: 'Answer', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final decoration = decorationOf(
        tester,
        bubbleOf(find.byType(AppMarkdown)),
      );
      expect(decoration.color, colors.card);
      expect(decoration.border, Border.all(color: colors.border, width: 1.0));
      expect(
        decoration.borderRadius,
        BorderRadiusDirectional.only(
          topStart: Radius.circular(radius.md),
          topEnd: Radius.circular(radius.xl),
          bottomStart: Radius.circular(radius.xl),
          bottomEnd: Radius.circular(radius.xl),
        ),
      );
    });

    testWidgets('renders the answer at the body text size', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          const AiAssistantCard(message: 'Answer', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final markdown = tester.widget<AppMarkdown>(find.byType(AppMarkdown));
      expect(
        markdown.textStyle?.fontSize,
        DesignConfig.defaults().typography.body.fontSize,
      );
    });

    testWidgets('offers copy as the only action on a completed answer', (
      tester,
    ) async {
      var copyCount = 0;
      await tester.pumpWidget(
        buildSubject(
          AiAssistantCard(
            message: 'Answer',
            timestamp: '14:36',
            onCopy: () => copyCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final actions = find.descendant(
        of: find.byType(AiAssistantCard),
        matching: find.byType(AppIconButton),
      );
      expect(actions, findsOneWidget);
      expect(find.byIcon(LucideIcons.copy), findsOneWidget);
      expect(find.byIcon(LucideIcons.thumbsUp), findsNothing);
      expect(find.byIcon(LucideIcons.thumbsDown), findsNothing);
      expect(find.byIcon(LucideIcons.volume2), findsNothing);
      expect(find.byIcon(LucideIcons.share2), findsNothing);
      expect(find.byIcon(LucideIcons.ellipsis), findsNothing);

      final actionSize = tester.getSize(actions);
      expect(actionSize.width, greaterThanOrEqualTo(48.0));
      expect(actionSize.height, greaterThanOrEqualTo(48.0));

      await tester.tap(find.byIcon(LucideIcons.copy));
      await tester.pump();
      expect(copyCount, 1);
    });

    testWidgets('stacks the timestamp under the copy action', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          const AiAssistantCard(message: 'Answer', timestamp: '14:36'),
        ),
      );
      await tester.pumpAndSettle();

      final card = tester.getRect(bubbleOf(find.byType(AppMarkdown)));
      final copy = tester.getRect(find.byIcon(LucideIcons.copy));
      final timestamp = tester.getRect(find.text('14:36'));

      expect(copy.top, greaterThan(card.bottom));
      expect(timestamp.top, greaterThanOrEqualTo(copy.bottom));
      expect(timestamp.left, greaterThanOrEqualTo(card.left));
      expect(timestamp.left, lessThan(copy.left));
    });

    testWidgets('hides copy and timestamp while the answer is streaming', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const AiAssistantCard(
            message: 'Partial answer',
            timestamp: '14:36',
            isGenerating: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppMarkdown), findsOneWidget);
      expect(find.text('Generating response...'), findsOneWidget);
      expect(find.byIcon(LucideIcons.copy), findsNothing);
      expect(find.text('14:36'), findsNothing);
    });

    testWidgets('shows the failure inside the card with retry below it', (
      tester,
    ) async {
      var retryCount = 0;
      await tester.pumpWidget(
        buildSubject(
          AiAssistantCard(
            message: '',
            timestamp: '14:36',
            hasGenerationError: true,
            onRetry: () => retryCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      const errorText = "Couldn't generate a response. Please try again.";
      final card = tester.getRect(bubbleOf(find.text('AI Assistant')));
      final error = tester.getRect(find.text(errorText));
      final retry = tester.getRect(find.text('Try again'));

      expect(card.contains(error.topLeft), isTrue);
      expect(card.contains(error.bottomRight), isTrue);
      expect(find.byIcon(LucideIcons.alertCircle), findsOneWidget);
      expect(retry.top, greaterThan(card.bottom));
      expect(find.byType(AppMarkdown), findsNothing);
      expect(find.byIcon(LucideIcons.copy), findsNothing);
      expect(find.text('14:36'), findsNothing);

      await tester.tap(find.text('Try again'));
      await tester.pump();
      expect(retryCount, 1);
    });
  });
}
