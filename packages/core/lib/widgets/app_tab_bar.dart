import 'package:flutter/widgets.dart';
import '../accessibility/app_semantics.dart';
import '../design/design_provider.dart';

class AppTabItem {
  const AppTabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
    this.iconBuilder,
  });

  final String id;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final Widget Function(
    BuildContext context,
    bool isActive,
    Color color,
    double size,
  )?
  iconBuilder;
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.items,
    required this.activeItemId,
    required this.onTabChange,
  });

  final List<AppTabItem> items;
  final String activeItemId;
  final ValueChanged<String> onTabChange;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        design.spacing.md,
        0,
        design.spacing.md,
        design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.pill,
        boxShadow: [
          BoxShadow(
            color: design.colors.textPrimary.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: design.colors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: design.layout.tabletBreakpoint,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
              height: 64, // Same as h-16 in React
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  final isActive = item.id == activeItemId;
                  // The React token mappings: textInverse maps to text-slate-800 mostly
                  // but let's just use textPrimary for standard matching text slate-800
                  // and textSecondary for muted state text slate-500
                  final fgColor = isActive
                      ? design.colors.textPrimary
                      : design.colors.textSecondary;

                  return SizedBox(
                    width: 72,
                    child: AppSemantics.button(
                      label: item.label,
                      onTap: () => onTabChange(item.id),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabChange(item.id),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item.iconBuilder != null
                                ? item.iconBuilder!(
                                    context,
                                    isActive,
                                    fgColor,
                                    20,
                                  )
                                : Icon(
                                    isActive
                                        ? (item.activeIcon ?? item.icon)
                                        : item.icon,
                                    size: 20, // Match w-5 h-5 in React
                                    color: fgColor,
                                  ),
                            SizedBox(height: design.spacing.xs),
                            Text(
                              item.label,
                              style: design.typography.caption.copyWith(
                                color: fgColor,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
