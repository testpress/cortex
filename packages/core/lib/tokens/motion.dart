import 'package:flutter/animation.dart';

/// Motion tokens for consistent animation timing and easing.
///
/// These durations and curves create a cohesive motion language.
/// Fast for micro-interactions, normal for most transitions,
/// slow for emphasis or complex animations.
class AppMotion {
  AppMotion._();

  // Durations
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const verySlow = Duration(milliseconds: 600);

  // Curves
  static const easeIn = Curves.easeIn;
  static const easeOut = Curves.easeOut;
  static const easeInOut = Curves.easeInOut;
  static const emphasized = Curves.easeInOutCubic;

  // Platform-neutral spring (not Material's bouncy spring)
  static const spring = Curves.easeOutCubic;
}
