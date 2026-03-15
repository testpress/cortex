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
    this.bottomSheet,
  });

  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? navigationRail;
  final Widget? drawer;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bottomNavigationBar = this.bottomNavigationBar;
    final navigationRail = this.navigationRail;
    final drawer = this.drawer;
    final bottomSheet = this.bottomSheet;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        return Stack(
          children: [
            Container(
              color: backgroundColor ?? design.colors.surface,
              child: isLandscape
                  ? Row(
                      children: [
                        if (navigationRail != null) navigationRail,
                        Expanded(
                          child: SafeArea(
                            left: navigationRail == null,
                            top: false,
                            bottom: false,
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
                        if (bottomNavigationBar != null) bottomNavigationBar,
                      ],
                    ),
            ),
            if (drawer != null) drawer,
            if (bottomSheet != null) bottomSheet,
          ],
        );
      },
    );
  }
}
