import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Root application shell container.
///
/// Provides SafeArea and consistent background color without
/// Material or Cupertino scaffolding.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, this.backgroundColor});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      color: backgroundColor ?? design.colors.surface,
      child: SafeArea(child: child),
    );
  }
}
