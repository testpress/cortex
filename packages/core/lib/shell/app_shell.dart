import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Root application shell container.
///
/// Provides SafeArea and consistent background color without
/// Material or Cupertino scaffolding.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.navigationRail,
    this.drawer,
  });

  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? navigationRail;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bottomNavigationBar = this.bottomNavigationBar;
    final navigationRail = this.navigationRail;
    final drawer = this.drawer;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        return Stack(
          children: [
            Container(
              color: backgroundColor ?? design.colors.surface,
              child: isTablet
                  ? Row(
                      children: [
                        if (navigationRail != null)
                          navigationRail
                        else if (bottomNavigationBar != null)
                          _buildRail(context, bottomNavigationBar),
                        Expanded(
                          child: SafeArea(
                            left:
                                navigationRail == null &&
                                bottomNavigationBar == null,
                            right: false,
                            child: child,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SafeArea(
                            left: false,
                            right: false,
                            bottom: bottomNavigationBar == null,
                            child: child,
                          ),
                        ),
                        ?bottomNavigationBar,
                      ],
                    ),
            ),
            ?drawer,
          ],
        );
      },
    );
  }

  Widget _buildRail(BuildContext context, Widget nav) {
    // If nav is AppTabBar, we could transform it, but for now we expect
    // the user to pass the right widget or we handle it in the shell.
    // However, AppShell is generic. Let's assume for now the user passes
    // a widget that can be used in both or we provide a way to pass both.
    return nav;
  }
}
