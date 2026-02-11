import 'package:flutter/widgets.dart';
import 'design_config.dart';

/// Lightweight InheritedWidget for propagating design configuration.
///
/// This is the internal mechanism for passing DesignConfig down the widget
/// tree. Widgets should use Design.of(context) instead of accessing this
/// directly.
///
/// Why InheritedWidget:
/// - Fast: O(1) lookup via dependOnInheritedWidgetOfExactType
/// - Minimal: No dependency injection framework overhead
/// - Standard: Flutter's recommended pattern for context propagation
class DesignContext extends InheritedWidget {
  const DesignContext({super.key, required this.config, required super.child});

  final DesignConfig config;

  @override
  bool updateShouldNotify(DesignContext oldWidget) {
    return config != oldWidget.config;
  }

  /// Internal accessor for DesignConfig.
  ///
  /// Widgets should use Design.of(context) instead of calling this directly.
  static DesignConfig of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DesignContext>();
    assert(
      result != null,
      'No DesignProvider found in context. '
      'Wrap your app root with DesignProvider:\n'
      'DesignProvider(\n'
      '  config: DesignConfig.defaults(),\n'
      '  child: YourApp(),\n'
      ')',
    );
    return result!.config;
  }
}
