import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    this.logoUrl,
    this.isLandscape = false,
    this.titleTextStyle,
    this.backgroundColor,
    this.onMenuPressed,
    this.trailing,
  });

  final String title;

  /// Optional logo URL. When provided, renders the logo image instead of
  /// the text title. Supports both asset paths (starting with 'assets/')
  /// and remote network URLs.
  final String? logoUrl;

  final bool isLandscape;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;
  final VoidCallback? onMenuPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final padding = MediaQuery.paddingOf(context);
    final effectiveBgColor = backgroundColor ?? design.colors.card;

    final topPadding = padding.top + design.spacing.md;
    final bottomPadding = design.spacing.md;

    final hasLogo = logoUrl != null && logoUrl!.isNotEmpty;

    Widget buildTextTitle() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.headline(
            title,
            color: design.colors.textPrimary,
            style: titleTextStyle,
          ),
        ],
      );
    }

    final Widget titleContent = hasLogo
        ? Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              logoUrl!,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => buildTextTitle(),
            ),
          )
        : buildTextTitle();

    return Container(
      padding: EdgeInsets.fromLTRB(
        padding.left > design.spacing.md ? padding.left : design.spacing.md,
        topPadding,
        padding.right > design.spacing.md ? padding.right : design.spacing.md,
        bottomPadding,
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onMenuPressed != null) ...[
            AppFocusable(
              onTap: onMenuPressed,
              borderRadius: BorderRadius.circular(design.radius.full),
              child: Padding(
                padding: EdgeInsets.all(design.spacing.xs),
                child: Icon(
                  LucideIcons.menu,
                  color: design.colors.textPrimary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
          ],
          Expanded(child: titleContent),
          if (trailing != null) ...[
            SizedBox(width: design.spacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
