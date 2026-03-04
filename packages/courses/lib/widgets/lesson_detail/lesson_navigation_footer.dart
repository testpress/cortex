import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Navigation footer for the lesson detail screen.
///
/// Provides "Previous Lesson" and "Next Lesson" navigation buttons.
class LessonNavigationFooter extends StatelessWidget {
  const LessonNavigationFooter({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.hasPrevious = true,
    this.hasNext = true,
  });

  /// Callback to navigate to the previous lesson.
  final VoidCallback? onPrevious;

  /// Callback to navigate to the next lesson.
  final VoidCallback? onNext;

  /// Whether there is a previous lesson to navigate to.
  final bool hasPrevious;

  /// Whether there is a next lesson to navigate to.
  final bool hasNext;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Row(
      children: [
        Expanded(
          child: AppButton.secondary(
            label: l10n.navigationPrevious,
            onPressed: hasPrevious ? onPrevious : null,
            leading: Icon(
              LucideIcons.chevronLeft,
              size: 16,
              color: hasPrevious
                  ? design.colors.primary
                  : design.colors.textTertiary,
            ),
          ),
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: AppButton.primary(
            label: l10n.navigationNext,
            onPressed: hasNext ? onNext : null,
            trailing: Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: design.colors.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
