import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:courses/courses.dart';

class ContextualHeroSectionWidget extends ConsumerWidget {
  const ContextualHeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final todayClasses = ref.watch(todayClassesProvider);

    return todayClasses.when(
      data: (classes) {
        if (classes.isEmpty) {
          return const SizedBox.shrink();
        }
        final liveOrUpcoming = classes.firstWhere(
          (c) =>
              c.status == dto.LiveClassStatus.live ||
              c.status == dto.LiveClassStatus.upcoming,
          orElse: () => classes.first,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: ContextualHeroCard(
            action: HeroAction(
              type: liveOrUpcoming.status == dto.LiveClassStatus.live
                  ? HeroActionType.joinClass
                  : HeroActionType.prepareTest,
              title: liveOrUpcoming.topic,
              subject: liveOrUpcoming.subject,
              metadata: liveOrUpcoming.faculty,
              timeInfo: liveOrUpcoming.time,
            ),
            onActionClick: () {},
          ),
        );
      },
      loading: () => const SizedBox(height: 120),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
