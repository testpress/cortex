import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/screens/doubt_detail_screen.dart';

void main() {
  final testDoubt = DoubtDto(
    id: '1',
    title: 'Test Doubt Title',
    content: '[{"insert":"What is physics?\\n"}]',
    studentName: 'Student',
    status: DoubtStatus.active,
    createdAt: DateTime(2026, 1, 1),
  );

  final closedDoubt = DoubtDto(
    id: '1',
    title: 'Closed Doubt Title',
    content: '[{"insert":"Resolved question\\n"}]',
    studentName: 'Student',
    status: DoubtStatus.closed,
    createdAt: DateTime(2026, 1, 1),
  );

  final testStudentReply = DoubtReplyDto(
    id: 'r1',
    doubtId: '1',
    content: 'Student follow-up',
    authorName: 'Student',
    isMentor: false,
    createdAt: DateTime(2026, 1, 1, 1),
  );

  final testMentorReply = DoubtReplyDto(
    id: 'r2',
    doubtId: '1',
    content: 'Mentor explanation',
    authorName: 'Mentor',
    isMentor: true,
    createdAt: DateTime(2026, 1, 1, 2),
  );

  Widget buildScreen({
    DoubtDto? doubt,
    List<DoubtReplyDto> replies = const [],
    Stream<List<DoubtReplyDto>>? repliesStream,
  }) {
    final effectiveDoubt = doubt ?? testDoubt;
    return ProviderScope(
      overrides: [
        doubtDetailProvider('1').overrideWith((ref) async => effectiveDoubt),
        doubtRepliesProvider(
          '1',
        ).overrideWith((ref) => repliesStream ?? Stream.value(replies)),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: LocalizationProvider.delegates,
            home: const DoubtDetailScreen(doubtId: '1'),
          ),
        ),
      ),
    );
  }

  group('DoubtDetailScreen.canCloseDoubt unit tests', () {
    test('returns false when replies is null', () {
      expect(DoubtDetailScreen.canCloseDoubt(null), isFalse);
    });

    test('returns false when replies is empty', () {
      expect(DoubtDetailScreen.canCloseDoubt([]), isFalse);
    });

    test('returns false when replies contain no mentor reply', () {
      expect(DoubtDetailScreen.canCloseDoubt([testStudentReply]), isFalse);
    });

    test('returns true when at least one reply is from a mentor', () {
      expect(
        DoubtDetailScreen.canCloseDoubt([testStudentReply, testMentorReply]),
        isTrue,
      );
    });
  });

  group('DoubtDetailScreen close doubt restriction', () {
    testWidgets('hides more menu when there are no replies', (tester) async {
      await tester.pumpWidget(buildScreen(replies: []));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.moreVertical), findsNothing);
    });

    testWidgets('hides more menu when replies exist but none from mentor', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(replies: [testStudentReply]));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.moreVertical), findsNothing);
    });

    testWidgets(
      'shows more menu and allows opening close action when mentor reply exists',
      (tester) async {
        await tester.pumpWidget(
          buildScreen(replies: [testStudentReply, testMentorReply]),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.moreVertical), findsOneWidget);

        final l10n = L10n.of(tester.element(find.byType(DoubtDetailScreen)));

        await tester.tap(find.byIcon(LucideIcons.moreVertical));
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.xCircle), findsOneWidget);
        expect(find.text(l10n.actionCloseDoubt), findsOneWidget);
      },
    );

    testWidgets(
      'hides more menu when doubt is already closed even with mentor replies',
      (tester) async {
        await tester.pumpWidget(
          buildScreen(doubt: closedDoubt, replies: [testMentorReply]),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.moreVertical), findsNothing);
      },
    );

    testWidgets(
      'prevents closing if mentor reply is removed while sheet is already open',
      (tester) async {
        final repliesController =
            StreamController<List<DoubtReplyDto>>.broadcast();
        addTearDown(repliesController.close);

        await tester.pumpWidget(
          buildScreen(repliesStream: repliesController.stream),
        );

        // Initially emit with a mentor reply so the menu is accessible
        repliesController.add([testStudentReply, testMentorReply]);
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.moreVertical), findsOneWidget);

        // Open action sheet
        await tester.tap(find.byIcon(LucideIcons.moreVertical));
        await tester.pumpAndSettle();

        final l10n = L10n.of(tester.element(find.byType(DoubtDetailScreen)));
        expect(find.text(l10n.actionCloseDoubt), findsOneWidget);

        // Stream updates and flips canClose to false while sheet remains open
        repliesController.add([testStudentReply]);
        await tester.pumpAndSettle();

        // Tap Close Doubt
        await tester.tap(find.text(l10n.actionCloseDoubt));
        await tester.pumpAndSettle();

        // Confirmation dialog must NOT be displayed because canClose is now false
        expect(find.text(l10n.dialogCloseDoubtContent), findsNothing);
      },
    );

    testWidgets(
      'retains more menu visibility when stream encounters an error or reload',
      (tester) async {
        final repliesController =
            StreamController<List<DoubtReplyDto>>.broadcast();
        addTearDown(repliesController.close);

        await tester.pumpWidget(
          buildScreen(repliesStream: repliesController.stream),
        );

        // Initially emit with a mentor reply so the menu is visible
        repliesController.add([testStudentReply, testMentorReply]);
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.moreVertical), findsOneWidget);

        // Stream encounters an error during background re-sync
        repliesController.addError(Exception('Network timeout'));
        await tester.pumpAndSettle();

        // The more menu MUST still be visible (no flicker)
        expect(find.byIcon(LucideIcons.moreVertical), findsOneWidget);
      },
    );
  });
}
