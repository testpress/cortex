import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import 'app_tab_bar.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    super.key,
    required this.items,
    required this.activeItemId,
    required this.onTabChange,
    this.header,
    this.footer,
  });

  final List<AppTabItem> items;
  final String activeItemId;
  final ValueChanged<String> onTabChange;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final header = this.header;
    final footer = this.footer;

    return Container(
      width: design.layout.railWidth,
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          right: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            ?header,
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: items.map((item) {
                          final isActive = item.id == activeItemId;
                          final fgColor = isActive
                              ? design.colors.textPrimary
                              : design.colors.textSecondary;

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onTabChange(item.id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isActive
                                        ? (item.activeIcon ?? item.icon)
                                        : item.icon,
                                    size: 24,
                                    color: fgColor,
                                  ),
                                  const SizedBox(height: 4),
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
                },
              ),
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}
