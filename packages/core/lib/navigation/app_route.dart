import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../motion/accessibility_motion.dart';

/// Platform-neutral page route with consistent transitions.
///
/// Replaces Material's MaterialPageRoute and Cupertino's
/// CupertinoPageRoute with identical cross-platform behavior.
class AppRoute<T> extends PageRouteBuilder<T> {
  AppRoute({required Widget page, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final design = Design.of(context);

          // Respect motion accessibility preferences
          final curve = MotionPreferences.curve(context, design.motion.easeOut);

          // Slide transition from right to left
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(
          milliseconds: 250,
        ), // AppMotion.normal default
        reverseTransitionDuration: const Duration(milliseconds: 250),
      );
}
