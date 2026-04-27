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
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.divider)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            design.spacing.screenPadding,
            design.spacing.md,
            design.spacing.screenPadding,
            design.spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back chevron inline with title
              GestureDetector(
                onTap: () => context.pop(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2), // Optical alignment
                  child: Icon(
                    LucideIcons.chevronLeft,
                    color: design.colors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: design.spacing.sm),
              Expanded(
                child: AppText.title(
                  title,
                  color: design.colors.textPrimary,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
