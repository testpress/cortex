import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/pdf_ai_bottom_sheet.dart';

void main() {
  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
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
      ),
    );
  }

  const testPdfLesson = LessonDto(
    id: '101',
    chapterId: 'chap-1',
    title: 'Algebra Notes',
    duration: '10 min',
    isLocked: false,
    type: LessonType.pdf,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 1,
    isDetailFetched: true,
    isAiEnabled: true,
    canEnableLearnlensAi: true,
    learnlensAssetStatus: 'completed',
    learnlensAssetId: 'asset-101',
    contentUrl: 'https://example.com/algebra.pdf',
  );

  testWidgets(
      'PdfAiBottomSheet renders header, drag handle, and document greeting',
      (tester) async {
    var closed = false;

    await tester.pumpWidget(wrap(
      PdfAiBottomSheet(
        lesson: testPdfLesson,
        onClose: () => closed = true,
      ),
    ));
    await tester.pumpAndSettle();

    // Verify title and icons
    expect(find.text('AI Chat'), findsOneWidget);
    expect(find.byIcon(LucideIcons.sparkles), findsAtLeastNWidgets(1));
    expect(find.byIcon(LucideIcons.x), findsOneWidget);

    // Verify PDF document greeting
    expect(
      find.text(
        "Hello! I'm your AI study assistant. Ask me anything about this document!",
      ),
      findsOneWidget,
    );

    // Tap close button
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
  });
}
