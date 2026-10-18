import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Non-opaque page for overlays that draw their own scrim and animate
/// themselves from the route animation, keeping the previous page visible.
CustomTransitionPage<void> overlayTransitionPage(
  BuildContext context,
  LocalKey key,
  Widget child,
) {
  final duration = MotionPreferences.duration(
    context,
    Design.of(context).motion.normal,
  );
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    opaque: false,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}
