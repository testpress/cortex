import 'package:flutter/widgets.dart';

/// Centralized semantics helpers for neutral UI.
///
/// Material widgets provide automatic semantics (button roles, header landmarks).
/// Since we avoid Material/Cupertino, we must manually add semantic annotations
/// to ensure screen readers work correctly.
class AppSemantics {
  AppSemantics._();

  /// Wraps a widget with button semantics.
  ///
  /// Use this for interactive elements that behave like buttons.
  /// Screen readers will announce "button" and the label.
  ///
  /// Example:
  /// ```dart
  /// AppSemantics.button(
  ///   label: 'Submit',
  ///   onTap: () => print('tapped'),
  ///   enabled: true,
  ///   child: Container(...),
  /// )
  /// ```
  static Widget button({
    required String label,
    required VoidCallback? onTap,
    required Widget child,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      label: label,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  /// Wraps a widget with header semantics.
  ///
  /// Use this for screen titles and section headers.
  /// Screen readers will announce this as a navigation landmark.
  ///
  /// Example:
  /// ```dart
  /// AppSemantics.header(
  ///   label: 'Course Library',
  ///   child: Text('Course Library'),
  /// )
  /// ```
  static Widget header({required String label, required Widget child}) {
    return Semantics(header: true, label: label, child: child);
  }

  /// Wraps a progress indicator with value semantics.
  ///
  /// Screen readers will announce the progress percentage.
  ///
  /// Example:
  /// ```dart
  /// AppSemantics.progressValue(
  ///   value: 0.65,
  ///   label: 'Course progress',
  ///   child: ProgressBar(...),
  /// )
  /// ```
  static Widget progressValue({
    required double value,
    required String label,
    required Widget child,
  }) {
    return Semantics(
      label: label,
      value: '${(value * 100).toInt()}%',
      child: child,
    );
  }

  /// Wraps related content in a semantic container.
  ///
  /// Use this to group related elements (e.g., card contents).
  /// Screen readers will treat this as a single navigable unit.
  ///
  /// Example:
  /// ```dart
  /// AppSemantics.container(
  ///   label: 'Flutter Basics course',
  ///   child: Column(...),
  /// )
  /// ```
  static Widget container({required String label, required Widget child}) {
    return Semantics(container: true, label: label, child: child);
  }

  /// Wraps a list with scrollable semantics.
  ///
  /// Screen readers will announce "scrollable list" and item count.
  ///
  /// Example:
  /// ```dart
  /// AppSemantics.scrollableList(
  ///   itemCount: 6,
  ///   label: 'Available courses',
  ///   child: ListView(...),
  /// )
  /// ```
  static Widget scrollableList({
    required int itemCount,
    required String label,
    required Widget child,
  }) {
    return Semantics(label: '$label, $itemCount items', child: child);
  }
}
