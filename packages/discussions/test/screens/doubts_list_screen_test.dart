import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/screens/doubts_list_screen.dart';

void main() {
  tearDown(() {
    AppConfig.enableAiDoubtOverride = null;
  });

  Widget buildScreen({
    DoubtQueryType? initialFilter,
    void Function(WidgetRef)? onRef,
  }) {
    return ProviderScope(
      overrides: [
        doubtsListProvider.overrideWith(
          (ref) => Stream.value(const <DoubtDto>[]),
        ),
        doubtsSyncProvider.overrideWith(() => _FakeDoubtsSync()),
        doubtTopicsSyncProvider.overrideWith((ref) async {}),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: LocalizationProvider.delegates,
            home: Column(
              children: [
                Expanded(child: DoubtsListScreen(initialFilter: initialFilter)),
                if (onRef != null)
                  Consumer(
                    builder: (context, ref, _) {
                      onRef(ref);
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  group('DoubtsListScreen filter chips bar', () {
    testWidgets('shows filter chips bar when enableAiDoubt is true', (
      tester,
    ) async {
      AppConfig.enableAiDoubtOverride = true;

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('AI'), findsOneWidget);
      expect(find.text('Mentor'), findsOneWidget);
    });

    testWidgets(
      'completely hides filter chips bar when enableAiDoubt is false',
      (tester) async {
        AppConfig.enableAiDoubtOverride = false;

        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // All filter chips should be omitted
        expect(find.text('All'), findsNothing);
        expect(find.text('AI'), findsNothing);
        expect(find.text('Mentor'), findsNothing);
      },
    );

    testWidgets(
      'resets doubtTypeFilterProvider to null when enableAiDoubt is false even if initialFilter was provided',
      (tester) async {
        AppConfig.enableAiDoubtOverride = false;
        DoubtQueryType? observedFilter = DoubtQueryType.ai;

        await tester.pumpWidget(
          buildScreen(
            initialFilter: DoubtQueryType.ai,
            onRef: (ref) {
              observedFilter = ref.watch(doubtTypeFilterProvider);
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(observedFilter, isNull);
      },
    );

    testWidgets('preserves initialFilter when enableAiDoubt is true', (
      tester,
    ) async {
      AppConfig.enableAiDoubtOverride = true;
      DoubtQueryType? observedFilter;

      await tester.pumpWidget(
        buildScreen(
          initialFilter: DoubtQueryType.ai,
          onRef: (ref) {
            observedFilter = ref.watch(doubtTypeFilterProvider);
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(observedFilter, DoubtQueryType.ai);
    });
  });
}

class _FakeDoubtsSync extends DoubtsSync {
  @override
  Future<({bool hasMore, bool isLoadingMore})> build() async {
    return (hasMore: false, isLoadingMore: false);
  }
}
