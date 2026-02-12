import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Motion accessibility preferences.
///
/// Respects MediaQuery.disableAnimations for users with vestibular disorders
/// or motion sensitivity. All animations and transitions MUST check this
/// before applying motion.
///
/// Why this matters:
/// Material widgets automatically respect disableAnimations, but our neutral
/// UI navigation (AppRoute) uses custom PageRouteBuilder which does NOT.
/// This layer ensures we don't exclude users who need reduced motion.
///
/// Now sources from Design context instead of MediaQuery directly, enabling
/// runtime design governance and future AI-adaptive UX.
class MotionPreferences {
  MotionPreferences._();

  /// Returns true if animations should be enabled.
  ///
  /// Reads from Design context which computes this from MediaQuery at
  /// provider initialization.
  ///
  /// Usage:
  /// ```dart
  /// if (MotionPreferences.shouldAnimate(context)) {
  ///   // Apply animation
  /// } else {
  ///   // Skip animation, show final state immediately
  /// }\n  /// ```
  static bool shouldAnimate(BuildContext context) {
    return Design.of(context).motion.shouldAnimate;
  }

  /// Returns appropriate duration based on motion preferences.
  ///
  /// If animations are disabled, returns Duration.zero.
  /// Otherwise returns the provided normal duration.
  ///
  /// Usage:
  /// ```dart
  /// AnimatedContainer(
  ///   duration: MotionPreferences.duration(context, Design.of(context).motion.normal),
  ///   ...
  /// )
  /// ```
  static Duration duration(BuildContext context, Duration normal) {
    return shouldAnimate(context) ? normal : Duration.zero;
  }

  /// Returns appropriate curve based on motion preferences.
  ///
  /// If animations are disabled, returns Curves.linear (instant).
  /// Otherwise returns the provided normal curve.
  ///
  /// Usage:
  /// ```dart
  /// Tween(...).animate(CurvedAnimation(
  ///   curve: MotionPreferences.curve(context, Design.of(context).motion.easeOut),
  ///   ...
  /// ))
  /// ```
  static Curve curve(BuildContext context, Curve normal) {
    return shouldAnimate(context) ? normal : Curves.linear;
  }
}
