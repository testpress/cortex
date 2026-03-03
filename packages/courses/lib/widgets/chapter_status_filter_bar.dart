import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum representing the possible status filters for a chapter.
enum ChapterStatusFilter { running, upcoming, history }

/// State provider for the active chapter status filter.
final chapterStatusFilterProvider = StateProvider<ChapterStatusFilter>(
  (ref) => ChapterStatusFilter.running,
);

/// A horizontal bar of status filters (Running, Upcoming, History).
class ChapterStatusFilterBar extends ConsumerWidget {
  const ChapterStatusFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final activeFilter = ref.watch(chapterStatusFilterProvider);

    final filters = [
      (filter: ChapterStatusFilter.running, label: l10n.chapterStatusRunning),
      (filter: ChapterStatusFilter.upcoming, label: l10n.chapterStatusUpcoming),
      (filter: ChapterStatusFilter.history, label: l10n.chapterStatusHistory),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        bottom: design.spacing.md,
        top: design.spacing.sm,
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = activeFilter == filter.filter;
          return Padding(
            padding: EdgeInsets.only(right: design.spacing.sm),
            child: _FilterPill(
              label: filter.label,
              isSelected: isSelected,
              onTap: () =>
                  ref.read(chapterStatusFilterProvider.notifier).state =
                      filter.filter,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bgColor = isSelected
        ? design.colors.textPrimary
        : design.colors.surfaceVariant;
    final fgColor = isSelected
        ? design.colors.textInverse
        : design.colors.textPrimary;

    return AppSemantics.button(
      label: 'Filter by $label',
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: design.radius.pill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: design.motion.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: design.radius.pill,
          ),
          child: AppText.label(label, color: fgColor),
        ),
      ),
    );
  }
}
