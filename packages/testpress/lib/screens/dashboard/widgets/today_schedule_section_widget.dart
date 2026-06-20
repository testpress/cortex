import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:courses/courses.dart';

class TodayScheduleSectionWidget extends ConsumerWidget {
  const TodayScheduleSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayClasses = ref.watch(todayClassesProvider);
    final pendingAssignments = ref.watch(pendingAssignmentsProvider);
    final upcomingTests = ref.watch(upcomingTestsProvider);

    if (todayClasses.isLoading ||
        pendingAssignments.isLoading ||
        upcomingTests.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    return TodaySnapshot(
      classes: (todayClasses.value ?? [])
          .map(
            (d) => ClassItem(
              id: d.id,
              subject: d.subject,
              time: d.time,
              faculty: d.faculty,
              status: switch (d.status) {
                dto.LiveClassStatus.live => ClassStatus.live,
                dto.LiveClassStatus.upcoming => ClassStatus.upcoming,
                dto.LiveClassStatus.completed => ClassStatus.completed,
              },
              topic: d.topic,
            ),
          )
          .toList(),
      assignments: (pendingAssignments.value ?? [])
          .map(
            (d) => Assignment(
              id: d.id,
              title: d.title,
              subject: d.subject,
              dueTime: d.dueTime,
              status: d.status,
              progress: d.progress / 100,
              description: d.description,
            ),
          )
          .toList(),
      tests: (upcomingTests.value ?? []).toList(),
    );
  }
}
