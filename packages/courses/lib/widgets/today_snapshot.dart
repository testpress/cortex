import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/today_schedule.dart';
import 'today_snapshot/class_card.dart';
import 'today_snapshot/assignment_card.dart';
import 'today_snapshot/test_card.dart';
import 'today_snapshot/snapshot_section.dart';
import 'today_snapshot/empty_state.dart';

export '../models/today_schedule.dart';

/// A chronological schedule view for the home dashboard.
class TodaySnapshot extends StatelessWidget {
  const TodaySnapshot({
    super.key,
    required this.classes,
    required this.assignments,
    this.tests = const [],
  });

  final List<ClassItem> classes;
  final List<Assignment> assignments;
  final List<ScheduledTest> tests;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final liveClasses = classes
        .where((c) => c.status == ClassStatus.live)
        .toList();
    final upcomingClasses = classes
        .where((c) => c.status == ClassStatus.upcoming)
        .toList();
    final completedClasses = classes
        .where((c) => c.status == ClassStatus.completed)
        .toList();

    final nextClass = upcomingClasses.isNotEmpty ? upcomingClasses.first : null;
    final laterClasses = upcomingClasses.length > 1
        ? upcomingClasses.skip(1).toList()
        : <ClassItem>[];

    final overdueAssignments = assignments
        .where((a) => a.status == AssignmentStatus.overdue)
        .toList();
    final pendingAssignments = assignments
        .where((a) => a.status == AssignmentStatus.pending)
        .toList();
    final deadlineItems = [...overdueAssignments, ...pendingAssignments];

    final hasNowAndNext = liveClasses.isNotEmpty || nextClass != null;
    final hasLaterToday =
        laterClasses.isNotEmpty || completedClasses.isNotEmpty;
    final hasDeadlines = deadlineItems.isNotEmpty;
    final hasTests = tests.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.title(
                  l10n.todayScheduleTitle,
                  color: design.colors.textPrimary,
                ),
                AppText.labelSmall(
                  l10n.viewAllAction,
                  color: design.colors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (hasNowAndNext) ...[
            SnapshotSection(
              title: l10n.nowAndNextSection,
              items: [
                ...liveClasses.map((c) => ClassCard(item: c)),
                if (nextClass != null) ClassCard(item: nextClass),
              ],
              design: design,
            ),
          ],

          if (hasDeadlines) ...[
            const SizedBox(height: 24),
            SnapshotSection(
              title: l10n.deadlinesSection,
              items: deadlineItems.map((a) => AssignmentCard(item: a)).toList(),
              design: design,
            ),
          ],

          if (hasTests) ...[
            const SizedBox(height: 24),
            SnapshotSection(
              title: l10n.upcomingTestsSection,
              items: tests.map((t) => TestCard(item: t)).toList(),
              design: design,
            ),
          ],

          if (hasLaterToday) ...[
            const SizedBox(height: 24),
            SnapshotSection(
              title: l10n.laterTodaySection,
              items: [
                ...laterClasses.map((c) => ClassCard(item: c)),
                ...completedClasses.map((c) => ClassCard(item: c)),
              ],
              design: design,
            ),
          ],

          if (!hasNowAndNext && !hasDeadlines && !hasTests && !hasLaterToday)
            TodayEmptyState(design: design),
        ],
      ),
    );
  }
}
