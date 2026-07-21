import 'package:flutter/widgets.dart';
import '../accessibility/app_semantics.dart';
import '../design/design_provider.dart';
import '../motion/accessibility_motion.dart';

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

  static const double _tabletMarginDivisor = 8.0;
  static const double _phoneMarginDivisor = 20.0;

  final List<AppTabItem> items;
  final String activeItemId;
  final ValueChanged<String> onTabChange;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth >= design.layout.tabletBreakpoint
        ? screenWidth / _tabletMarginDivisor
        : screenWidth / _phoneMarginDivisor;

    return Container(
      margin: EdgeInsets.fromLTRB(
        horizontalMargin,
        0,
        horizontalMargin,
        design.spacing.md,
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
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: design.radius.pill,
                boxShadow: [
                  BoxShadow(
                    color: design.colors.textPrimary.withValues(alpha: 0.20),
                    blurRadius: 48,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: design.colors.textPrimary.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.zero,
              height: 64,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = items.isNotEmpty
                      ? constraints.maxWidth / items.length
                      : 0.0;
                  final activeIndex = items.indexWhere(
                    (item) => item.id == activeItemId,
                  );

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: MotionPreferences.duration(
                          context,
                          design.motion.normal,
                        ),
                        curve: MotionPreferences.curve(
                          context,
                          design.motion.easeOut,
                        ),
                        left: activeIndex >= 0 ? activeIndex * tabWidth : 0,
                        width: tabWidth,
                        top: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          duration: MotionPreferences.duration(
                            context,
                            design.motion.normal,
                          ),
                          opacity: activeIndex >= 0 ? 1.0 : 0.0,
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(design.spacing.xs),
                              decoration: BoxDecoration(
                                color: design.colors.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: design.radius.pill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: items.map((item) {
                          final isActive = item.id == activeItemId;
                          return Expanded(
                            key: ValueKey(item.id),
                            child: _TabItemWidget(
                              key: ValueKey('${item.id}_tab'),
                              item: item,
                              isActive: isActive,
                              onTap: () => onTabChange(item.id),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItemWidget extends StatelessWidget {
  const _TabItemWidget({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AppTabItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final primaryColor = design.colors.primary;

    final duration = MotionPreferences.duration(context, design.motion.normal);
    final curve = MotionPreferences.curve(context, design.motion.easeOut);

    return AppSemantics.button(
      label: item.label,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  begin: design.colors.textSecondary,
                  end: isActive ? primaryColor : design.colors.textSecondary,
                ),
                duration: duration,
                curve: curve,
                builder: (context, color, child) {
                  final currentColor = color ?? design.colors.textSecondary;
                  if (item.iconBuilder != null) {
                    return item.iconBuilder!(
                      context,
                      isActive,
                      currentColor,
                      20,
                    );
                  }
                  return Icon(
                    isActive ? (item.activeIcon ?? item.icon) : item.icon,
                    size: 20,
                    color: currentColor,
                  );
                },
              ),
              SizedBox(height: design.spacing.xs),
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: curve,
                style: design.typography.caption.copyWith(
                  color: isActive ? primaryColor : design.colors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
