import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

CustomTransitionPage<void> slideTransitionPage(
  BuildContext context,
  LocalKey key,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: MotionPreferences.duration(
      context,
      Design.of(context).motion.normal,
    ),
    reverseTransitionDuration: MotionPreferences.duration(
      context,
      Design.of(context).motion.normal,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (!MotionPreferences.shouldAnimate(context)) {
        return child;
      }
      final curve = MotionPreferences.curve(
        context,
        Design.of(context).motion.easeInOut,
      );
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
