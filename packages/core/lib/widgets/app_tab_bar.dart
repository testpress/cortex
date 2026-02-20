import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppTabItem {
  const AppTabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  final String id;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
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
      height: 64, // Same as h-16 in React
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(top: BorderSide(color: design.colors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final isActive = item.id == activeItemId;
            // The React token mappings: textInverse maps to text-slate-800 mostly
            // but let's just use textPrimary for standard matching text slate-800
            // and textSecondary for muted state text slate-500
            final fgColor = isActive
                ? design.colors.textPrimary
                : design.colors.textSecondary;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTabChange(item.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? (item.activeIcon ?? item.icon) : item.icon,
                      size: 20, // Match w-5 h-5 in React
                      color: fgColor,
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.label,
                      style: design.typography.caption.copyWith(
                        color: fgColor,
                        fontWeight: isActive
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
