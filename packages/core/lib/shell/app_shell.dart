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
        final isTablet = constraints.maxWidth >= design.layout.tabletBreakpoint;

        return Stack(
          children: [
            Container(
              color: backgroundColor ?? design.colors.surface,
              child: isTablet
                  ? Row(
                      children: [
                        ?navigationRail,
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
}
