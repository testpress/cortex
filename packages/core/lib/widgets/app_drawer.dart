import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../design/design_provider.dart';
import 'app_text.dart';

class AppDrawerItem {
  final IconData icon;
  final String label;
  final VoidCallback action;
  final bool isRed;
  final bool disabled;
  final bool keepMenuOpen;

  const AppDrawerItem({
    required this.icon,
    required this.label,
    required this.action,
    this.isRed = false,
    this.disabled = false,
    this.keepMenuOpen = false,
  });
}

class AppDrawerSection {
  final List<AppDrawerItem> items;
  const AppDrawerSection({required this.items});
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.sections,
    this.title = 'Menu',
    this.fullPage = false,
    this.slideFromRight = false,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final List<AppDrawerSection> sections;
  final String title;
  final bool fullPage;
  final bool slideFromRight;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(widget.slideFromRight ? 1.0 : -1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return PopScope(
      canPop: !widget.isOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.isOpen) {
          widget.onClose();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isDismissed && !widget.isOpen) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              // Backdrop (only if not fullPage)
              if (!widget.fullPage)
                GestureDetector(
                  onTap: widget.onClose,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(color: design.colors.overlay),
                  ),
                ),
              // Drawer Container
              Align(
                alignment: widget.slideFromRight
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: widget.fullPage
                        ? double.infinity
                        : design.layout.drawerWidth,
                    decoration: BoxDecoration(
                      color: design.colors.surface,
                      boxShadow: widget.fullPage
                          ? null
                          : [
                              BoxShadow(
                                color: design.colors.shadow,
                                blurRadius: 16,
                                offset: Offset(
                                  widget.slideFromRight ? -8 : 8,
                                  0,
                                ),
                              ),
                            ],
                      border: widget.fullPage
                          ? null
                          : Border(
                              left: widget.slideFromRight
                                  ? BorderSide(
                                      color: design.colors.border,
                                      width: design.isDark ? 0 : 1,
                                    )
                                  : BorderSide.none,
                              right: !widget.slideFromRight
                                  ? BorderSide(
                                      color: design.colors.border,
                                      width: design.isDark ? 0 : 1,
                                    )
                                  : BorderSide.none,
                            ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(context),
                          // Scrollable content
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: widget.sections.length,
                              separatorBuilder: (context, index) => Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: design.colors.border,
                              ),
                              itemBuilder: (context, index) {
                                return _buildSection(
                                  context,
                                  widget.sections[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final design = Design.of(context);
    final isRight = widget.slideFromRight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (widget.fullPage && !isRight) ...[
            GestureDetector(
              onTap: widget.onClose,
              child: Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: design.colors.textPrimary,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: AppText.title(
              widget.title,
              color: design.colors.textPrimary,
            ),
          ),
          if (widget.fullPage && isRight) ...[
            const SizedBox(width: 16),
            GestureDetector(
              onTap: widget.onClose,
              child: Icon(
                LucideIcons.arrowRight,
                size: 24,
                color: design.colors.textPrimary,
              ),
            ),
          ] else if (!widget.fullPage) ...[
            GestureDetector(
              onTap: widget.onClose,
              child: Icon(
                LucideIcons.x,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, AppDrawerSection section) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: section.items
            .map((item) => _buildItem(context, item))
            .toList(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, AppDrawerItem item) {
    final design = Design.of(context);
    final iconColor = item.disabled
        ? design.colors.textTertiary
        : item.isRed
        ? design.colors.error
        : design.colors.textSecondary;
    final textColor = item.disabled
        ? design.colors.textTertiary
        : item.isRed
        ? design.colors.error
        : design.colors.textPrimary;

    return Semantics(
      button: true,
      label: item.label,
      enabled: !item.disabled,
      child: GestureDetector(
        onTap: item.disabled
            ? null
            : () {
                item.action();
                if (!item.keepMenuOpen) widget.onClose();
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Expanded(child: AppText.body(item.label, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
