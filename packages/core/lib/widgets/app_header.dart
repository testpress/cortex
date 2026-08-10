import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';
import 'app_text.dart';

/// Platform-neutral app header (replaces AppBar/CupertinoNavigationBar).
///
/// Provides consistent header styling without Material or Cupertino
/// platform-specific visuals.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.bottomContent,
    this.contentPadding,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? bottomContent;
  final EdgeInsetsGeometry? contentPadding;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? design.colors.card,
        border: showDivider
            ? Border(bottom: BorderSide(color: design.colors.divider, width: 1))
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              contentPadding ??
              EdgeInsetsDirectional.fromSTEB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.screenPadding,
                design.spacing.md,
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: design.spacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSemantics.header(
                          label: title,
                          child: AppText.title(
                            title,
                            color: design.colors.textPrimary,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: design.spacing.xs),
                          AppText.bodySmall(
                            subtitle!,
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  ...?actions,
                ],
              ),
              if (bottomContent != null) ...[
                SizedBox(height: design.spacing.md),
                bottomContent!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
