import 'package:flutter/widgets.dart';
import '../accessibility/app_semantics.dart';

/// A tappable icon primitive that bakes in a WCAG-compliant 48dp minimum touch target
/// and proper semantics for screen readers.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.accessibilityLabel,
    this.size,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String accessibilityLabel;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppSemantics.button(
      label: accessibilityLabel,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: Center(
            child: Icon(icon, size: size, color: color),
          ),
        ),
      ),
    );
  }
}
