import 'package:flutter/material.dart' show RefreshIndicator;
import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.semanticsLabel,
  });

  final Future<void> Function() onRefresh;

  final Widget child;

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: design.colors.primary,
      backgroundColor: design.colors.card,
      semanticsLabel: semanticsLabel ?? 'Refresh',
      child: child,
    );
  }
}
