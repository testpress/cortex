import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Platform-neutral scrollable container.
///
/// Provides consistent scrolling behavior without Material or Cupertino
/// scroll physics differences.
class AppScroll extends StatelessWidget {
  const AppScroll({super.key, required this.children, this.padding, this.controller});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return SingleChildScrollView(
      controller: controller,
      padding: padding ?? EdgeInsets.all(design.spacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
