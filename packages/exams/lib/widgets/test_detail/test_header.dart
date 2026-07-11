import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class TestHeader extends StatelessWidget {
  final ExamDto exam;
  final String timeFormatted;
  final VoidCallback onExit;
  final bool isQuizMode;

  const TestHeader({
    super.key,
    required this.exam,
    required this.timeFormatted,
    required this.onExit,
    this.isQuizMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onExit,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      color: design.colors.textPrimary,
                      size: 20,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.body(
                      l10n.testExit,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (!isQuizMode && exam.duration.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(minWidth: 72),
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.sm,
                    vertical: design.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: design.isDark
                        ? design.colors.surface
                        : design.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(design.radius.xl),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: design.colors.accent3,
                        size: 16,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.caption(
                        timeFormatted,
                        color: design.colors.textPrimary,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: design.spacing.lg),
          AppText.headline(
            '${l10n.filterTest}: ${exam.title}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
