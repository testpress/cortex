import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Reusable header for all Forum screens.
///
/// Enforces white background and standardized alignment of leading/title.
class ForumHeader extends StatelessWidget {
  const ForumHeader({
    super.key,
    required this.title,
    this.actions,
    this.showDivider = true,
  });

  final String title;
  final List<Widget>? actions;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: showDivider
            ? Border(bottom: BorderSide(color: design.colors.divider))
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            design.spacing.md,
            design.spacing.md,
            design.spacing.screenPadding,
            design.spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back arrow inline with title
              AppSemantics.button(
                label: l10n.forumBackSemantic,
                onTap: () => context.pop(),
                child: AppFocusable(
                  padding: const EdgeInsets.all(13),
                  onTap: () => context.pop(),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: design.colors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: design.spacing.sm),
              Expanded(
                child: AppText.title(title, color: design.colors.textPrimary),
              ),
              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}
