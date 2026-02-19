import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'design_config.dart';
import 'design_context.dart';

/// Runtime design provider.
///
/// Wraps the application root to inject DesignConfig into the widget tree.
/// All widgets can access design tokens via Design.of(context).
class DesignProvider extends StatefulWidget {
  const DesignProvider({
    super.key,
    required this.config,
    this.darkConfig,
    this.mode = DesignMode.system,
    required this.child,
  });

  /// Primary (Light) design configuration.
  final DesignConfig config;

  /// Optional Dark design configuration.
  /// If null, falls back to [config].
  final DesignConfig? darkConfig;

  /// Theme governance mode.
  final DesignMode mode;

  final Widget child;

  @override
  State<DesignProvider> createState() => _DesignProviderState();
}

class _DesignProviderState extends State<DesignProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (widget.mode == DesignMode.system) {
      setState(() {
        // Trigger rebuild to pick up new PlatformDispatcher brightness
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Hybrid reactivity:
    // 1. Listen to MediaQuery if available (standard Flutter way)
    // 2. Fallback to PlatformDispatcher (for root-level above MaterialApp)
    final platformBrightness =
        MediaQuery.maybePlatformBrightnessOf(context) ??
        PlatformDispatcher.instance.platformBrightness;

    final effectiveConfig = switch (widget.mode) {
      DesignMode.light => widget.config,
      DesignMode.dark => widget.darkConfig ?? widget.config,
      DesignMode.system =>
        platformBrightness == Brightness.dark
            ? (widget.darkConfig ?? widget.config)
            : widget.config,
    };

    return DesignContext(config: effectiveConfig, child: widget.child);
  }
}

/// Convenience accessor for design configuration.
class Design {
  Design._();

  static DesignConfig of(BuildContext context) {
    return DesignContext.of(context);
  }
}
