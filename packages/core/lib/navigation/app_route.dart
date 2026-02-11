import 'package:flutter/widgets.dart';
import '../tokens/motion.dart';
import '../motion/accessibility_motion.dart';

/// Platform-neutral page route with consistent transitions.
///
/// Replaces Material's MaterialPageRoute and Cupertino's
/// CupertinoPageRoute with identical cross-platform behavior.
class AppRoute<T> extends PageRouteBuilder<T> {
  AppRoute({required Widget page, RouteSettings? settings})
    : super(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Respect motion accessibility preferences
          final curve = MotionPreferences.curve(context, AppMotion.easeOut);

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
        transitionDuration: AppMotion.normal,
        reverseTransitionDuration: AppMotion.normal,
      );
}
