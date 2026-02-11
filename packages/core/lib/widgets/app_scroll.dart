import 'package:flutter/widgets.dart';
import '../tokens/spacing.dart';

/// Platform-neutral scrollable container.
///
/// Provides consistent scrolling behavior without Material or Cupertino
/// scroll physics differences.
class AppScroll extends StatelessWidget {
  const AppScroll({super.key, required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.all(AppSpacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
