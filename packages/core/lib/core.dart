/// Cortex Core Package
///
/// Platform-neutral UI primitives and design system for the Cortex SDK.
/// This package provides first-principles components that work identically
/// across all platforms without Material or Cupertino dependencies.
library;

// Design system (runtime)
export 'design/design_config.dart';
export 'design/design_context.dart';
export 'design/design_provider.dart';

// Tokens (legacy tokens removed - use Design.of(context))

// Widgets
export 'widgets/app_text.dart';
export 'widgets/app_button.dart';
export 'widgets/app_card.dart';
export 'widgets/app_header.dart';
export 'widgets/app_scroll.dart';

// Shell
export 'shell/app_shell.dart';

// Navigation
export 'navigation/app_route.dart';

// Accessibility
export 'accessibility/app_semantics.dart';
export 'accessibility/app_focus.dart';
export 'accessibility/accessibility_guard.dart';

// Motion
export 'motion/accessibility_motion.dart';

// Localization
export 'localization/localization_provider.dart';
export 'localization/l10n_helper.dart';
