import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Platform-neutral card container.
///
/// Provides consistent elevated surface styling without Material's
/// elevation shadows or Cupertino's blur effects.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.showBorder = true,
    this.showShadow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final cardContent = Container(
      padding: padding ?? EdgeInsets.all(design.spacing.cardPadding),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        border: showBorder
            ? Border.all(color: design.colors.border, width: 1)
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: design.colors.border.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: cardContent);
    }

    return cardContent;
  }
}
