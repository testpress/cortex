import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Helper to configure device orientation constraints.
///
/// Ensures mobile phones (< 600dp shortest side) are restricted to portrait-only,
/// preventing layout and UX breakage across general screens, while allowing
/// tablets / iPads (>= 600dp shortest side) to rotate freely between portrait
/// and landscape. Also provides hooks for video players to temporarily unlock
/// landscape fullscreen.
class DeviceOrientationHelper {
  DeviceOrientationHelper._();

  /// The breakpoint for differentiating phones from tablets in logical pixels (dp).
  static const double tabletBreakpoint = 600.0;

  /// Returns `true` if the given [size] indicates a tablet device.
  static bool isTablet(Size size) => size.shortestSide >= tabletBreakpoint;

  /// Configures preferred orientations based on the given [size].
  static Future<void> configureOrientations(Size size) async {
    if (isTablet(size)) {
      await allowAllOrientations();
    } else {
      await lockToPortrait();
    }
  }

  /// Locks orientations to portrait-only (phones).
  static Future<void> lockToPortrait() async {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Allows all orientations (tablets).
  static Future<void> allowAllOrientations() async {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allows landscape orientations for video playback fullscreen.
  static Future<void> allowVideoOrientations() async {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Restores default orientations for the current device (portrait for phones,
  /// all for tablets).
  static Future<void> lockToDeviceDefault([Size? size]) async {
    if (size != null) {
      await configureOrientations(size);
      return;
    }
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view != null && view.physicalSize.shortestSide > 0) {
      final logicalSize = view.physicalSize / view.devicePixelRatio;
      await configureOrientations(logicalSize);
    } else {
      await lockToPortrait();
    }
  }

  /// Automatically configures orientations using the platform dispatcher's
  /// primary view dimensions. If dimensions are not yet established, defaults
  /// to portrait-only.
  static Future<void> initialize() async {
    await lockToDeviceDefault();
  }
}
