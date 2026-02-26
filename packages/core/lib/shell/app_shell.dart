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
    this.drawer,
  });

  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Stack(
      children: [
        Container(
          color: backgroundColor ?? design.colors.surface,
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: bottomNavigationBar == null,
                  child: child,
                ),
              ),
              if (bottomNavigationBar != null) bottomNavigationBar!,
            ],
          ),
        ),
        if (drawer != null) drawer!,
      ],
    );
  }
}
