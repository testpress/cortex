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
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.screenPadding,
        design.spacing.xl,
        design.spacing.screenPadding,
        design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          bottom: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSemantics.header(
                  label: title,
                  child: AppText.headline(
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
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
