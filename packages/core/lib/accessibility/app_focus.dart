import 'package:flutter/widgets.dart';

/// Focus management helpers for neutral UI.
///
/// Provides reusable focus utilities for keyboard navigation
/// and tablet/desktop readiness.
class AppFocus {
  AppFocus._();

  /// Requests focus on a specific node.
  ///
  /// Use this to set initial focus when navigating to a new screen.
  static void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// Unfocuses the current focus node.
  ///
  /// Use this to dismiss keyboard or clear focus state.
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Returns true if the given node has focus.
  static bool hasFocus(FocusNode node) {
    return node.hasFocus;
  }

  /// Creates a focus node with optional debug label.
  ///
  /// Debug labels help identify focus issues during development.
  static FocusNode createNode({String? debugLabel}) {
    return FocusNode(debugLabel: debugLabel);
  }
}
