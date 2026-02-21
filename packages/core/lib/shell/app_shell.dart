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
  });

  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      color: backgroundColor ?? design.colors.surface,
      child: Column(
        children: [
          Expanded(
            child: SafeArea(bottom: bottomNavigationBar == null, child: child),
          ),
          ?bottomNavigationBar,
        ],
      ),
    );
  }
}
