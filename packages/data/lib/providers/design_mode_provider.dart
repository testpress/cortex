import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

/// Provider for the global design mode (light, dark, system).
/// Shared across all feature packages (Courses, Profile).
final designModeProvider = StateProvider<DesignMode>(
  (ref) => DesignMode.system,
);
