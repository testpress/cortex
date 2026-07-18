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
            PhysicalModel(
              color: backgroundColor ?? design.colors.surface,
              child: isLandscape
                  ? Row(
                      children: [
                        ?navigationRail,
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
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: SafeArea(
                            left: false,
                            right: false,
                            top: false,
                            bottom: bottomNavigationBar == null,
                            child: bottomNavigationBar != null
                                ? MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      padding: MediaQuery.of(context).padding
                                          .copyWith(
                                            bottom: 64 + design.spacing.md,
                                          ),
                                    ),
                                    child: child,
                                  )
                                : child,
                          ),
                        ),
                        if (bottomNavigationBar != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: bottomNavigationBar,
                          ),
                      ],
                    ),
            ),
            ?drawer,
            ?bottomSheet,
          ],
        );
      },
    );
  }
}
