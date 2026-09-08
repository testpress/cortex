import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/video_processing_view.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
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
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('VideoProcessingView', () {
    testWidgets('renders processing title, subtitle and check status button',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const VideoProcessingView(lessonId: '101'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Video is Being Processed'), findsOneWidget);
      expect(
        find.text(
            'This video is currently being processed. Please check back shortly.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('triggers onRetry callback when pressed', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        wrap(
          VideoProcessingView(
            lessonId: '101',
            onRetry: () {
              retried = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final button = find.text('Retry');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(retried, isTrue);
    });
  });
}
