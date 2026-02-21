import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons, Color;
import 'package:core/core.dart';

enum ClassStatus { upcoming, live, completed }

enum AssignmentStatus { pending, submitted, overdue }

enum TestType { mock, chapter, practice }

class ClassItem {
  final String id;
  final String subject;
  final String time;
  final String faculty;
  final ClassStatus status;
  final String? topic;

  const ClassItem({
    required this.id,
    required this.subject,
    required this.time,
    required this.faculty,
    required this.status,
    this.topic,
  });
}

class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueTime;
  final AssignmentStatus status;
  final double? progress; // 0.0 to 1.0
  final String? description;

  const Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueTime,
    required this.status,
    this.progress,
    this.description,
  });
}

class Test {
  final String id;
  final String title;
  final String time;
  final String duration;
  final TestType? type;
  final bool isImportant;

  const Test({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    this.type,
    this.isImportant = false,
  });
}

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
  final List<Test> tests;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

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
                AppText(
                  "Today's Schedule",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  color: design.colors.textPrimary,
                ),
                AppText.bodySmall(
                  'View all',
                  color: design.colors.primary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (hasNowAndNext) ...[
            _SnapshotSection(
              title: 'NOW & NEXT',
              items: [
                ...liveClasses.map((c) => _ClassCard(item: c)),
                if (nextClass != null) _ClassCard(item: nextClass),
              ],
              design: design,
            ),
          ],

          if (hasDeadlines) ...[
            const SizedBox(height: 24),
            _SnapshotSection(
              title: 'DEADLINES',
              items: deadlineItems
                  .map((a) => _AssignmentCard(item: a))
                  .toList(),
              design: design,
            ),
          ],

          if (hasTests) ...[
            const SizedBox(height: 24),
            _SnapshotSection(
              title: 'UPCOMING TESTS',
              items: tests.map((t) => _TestCard(item: t)).toList(),
              design: design,
            ),
          ],

          if (hasLaterToday) ...[
            const SizedBox(height: 24),
            _SnapshotSection(
              title: 'LATER TODAY',
              items: [
                ...laterClasses.map((c) => _ClassCard(item: c)),
                ...completedClasses.map((c) => _ClassCard(item: c)),
              ],
              design: design,
            ),
          ],

          if (!hasNowAndNext && !hasDeadlines && !hasTests && !hasLaterToday)
            _buildEmptyState(context, design),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DesignConfig design) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: AppCard(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: design.colors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 24,
                  color: design.colors.success,
                ),
              ),
              const SizedBox(height: 12),
              AppText.title('All Caught Up!', color: design.colors.textPrimary),
              AppText.bodySmall(
                'No scheduled activities right now',
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SnapshotSection extends StatelessWidget {
  const _SnapshotSection({
    required this.title,
    required this.items,
    required this.design,
  });

  final String title;
  final List<Widget> items;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppText(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
            color: design.colors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        if (items.length > 1)
          _PeekCarousel(items: items, design: design)
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: items.first,
          ),
      ],
    );
  }
}

class _PeekCarousel extends StatelessWidget {
  const _PeekCarousel({required this.items, required this.design});
  final List<Widget> items;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    // 88% width mimics the PageView viewportFraction
    final itemWidth = MediaQuery.of(context).size.width * 0.88;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(items.length, (index) {
            final isLast = index == items.length - 1;
            return Container(
              // Subtract the padding to maintain exact proportional sizing
              width: itemWidth - design.spacing.md,
              padding: EdgeInsets.only(right: isLast ? 0 : 8.0),
              child: items[index],
            );
          }),
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.item});
  final ClassItem item;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isCompleted = item.status == ClassStatus.completed;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(design.spacing.md),
      child: Opacity(
        opacity: isCompleted ? 0.6 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentIcon(status: item.status),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          item.topic ?? item.subject,
                          color: design.colors.textPrimary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (item.status == ClassStatus.live) ...[
                        const SizedBox(width: 8),
                        _PillBadge(
                          label: 'LIVE',
                          color: const Color(0xFF16A34A),
                        ),
                      ],
                    ],
                  ),
                  if (item.topic != null) ...[
                    const SizedBox(height: 2),
                    AppText(
                      item.subject,
                      color: design.colors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                  ] else
                    const SizedBox(height: 4),
                  AppText(
                    '${item.faculty} · ${item.time}',
                    color: design.colors.textTertiary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isCompleted
                  ? design.colors.textTertiary.withValues(alpha: 0.5)
                  : design.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.item});
  final Assignment item;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isOverdue = item.status == AssignmentStatus.overdue;
    final filledColor = isOverdue
        ? const Color(0xFFDC2626)
        : const Color(0xFFD97706);
    const emptyColor = Color(0xFFCBD5E1);

    return AppCard(
      showShadow: true,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssignmentIcon(status: item.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.title,
                      color: design.colors.textPrimary,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.description != null)
                      AppText(
                        item.description!,
                        color: design.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: design.colors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    '${item.subject} · Due ${item.dueTime}',
                    color: design.colors.textTertiary,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (item.progress != null && item.progress! > 0) ...[
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      ...List.generate(4, (i) {
                        final isFilled = item.progress! >= ((i + 1) / 4);
                        return Container(
                          width: 12,
                          height: 4,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: isFilled ? filledColor : emptyColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                      const SizedBox(width: 4),
                      AppText.caption(
                        '${(item.progress! * 100).toInt()}%',
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.item});
  final Test item;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      showShadow: true,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TestIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        item.title,
                        color: design.colors.textPrimary,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (item.isImportant) ...[
                      const SizedBox(width: 8),
                      _PillBadge(
                        label: 'IMPORTANT',
                        color: design.colors.error,
                      ),
                    ],
                  ],
                ),
                if (item.type != null) ...[
                  const SizedBox(height: 4),
                  AppText.caption(
                    '${item.type!.name.toUpperCase()} TEST',
                    color: design.colors.textSecondary,
                    style: const TextStyle(letterSpacing: 0.5),
                  ),
                ],
                const SizedBox(height: 4),
                AppText.caption(
                  '${item.time} · ${item.duration}',
                  color: design.colors.textTertiary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: design.colors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _ContentIcon extends StatelessWidget {
  const _ContentIcon({required this.status});
  final ClassStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ClassStatus.live => const Icon(
        LucideIcons.video,
        size: 20,
        color: Color(0xFFDC2626),
      ),
      ClassStatus.completed => const Icon(
        LucideIcons.checkCircle2,
        size: 20,
        color: Color(0xFF16A34A),
      ),
      ClassStatus.upcoming => const Icon(
        LucideIcons.clock,
        size: 20,
        color: Color(0xFFEA580C),
      ),
    };
  }
}

class _AssignmentIcon extends StatelessWidget {
  const _AssignmentIcon({required this.status});
  final AssignmentStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AssignmentStatus.overdue => const Icon(
        LucideIcons.alertCircle,
        size: 20,
        color: Color(0xFFDC2626),
      ),
      AssignmentStatus.submitted => const Icon(
        LucideIcons.checkCircle2,
        size: 20,
        color: Color(0xFF16A34A),
      ),
      AssignmentStatus.pending => const Icon(
        LucideIcons.clock,
        size: 20,
        color: Color(0xFFEA580C),
      ),
    };
  }
}

class _TestIcon extends StatelessWidget {
  const _TestIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      LucideIcons.shieldCheck,
      size: 20,
      color: Color(0xFFEA580C),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}
