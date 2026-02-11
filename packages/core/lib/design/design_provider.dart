import 'package:flutter/widgets.dart';
import 'design_config.dart';
import 'design_context.dart';

/// Runtime design provider.
///
/// Wraps the application root to inject DesignConfig into the widget tree.
/// All widgets can access design tokens via Design.of(context).
///
/// Usage:
/// ```dart
/// void main() {
///   runApp(
///     DesignProvider(
///       config: DesignConfig.defaults(),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// Why this exists:
/// Provides a single source of truth for design decisions that can be
/// customized at runtime. Future-proof for white-label branding and
/// AI-adaptive UX without breaking SDK contracts.
class DesignProvider extends StatelessWidget {
  const DesignProvider({super.key, required this.config, required this.child});

  final DesignConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DesignContext(config: config, child: child);
  }
}

/// Convenience accessor for design configuration.
///
/// Usage:
/// ```dart
/// final design = Design.of(context);
/// Container(
///   color: design.colors.primary,
///   padding: EdgeInsets.all(design.spacing.md),
///   child: Text('Hello', style: design.typography.body),
/// )
/// ```
class Design {
  Design._();

  /// Access the current DesignConfig from context.
  ///
  /// Throws assertion error if no DesignProvider is found in the widget tree.
  /// Always wrap your app root with DesignProvider.
  static DesignConfig of(BuildContext context) {
    return DesignContext.of(context);
  }
}
