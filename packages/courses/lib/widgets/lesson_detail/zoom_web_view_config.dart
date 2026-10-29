import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:core/core.dart';

class ZoomPermissionHandler {
  static Future<bool> checkAndRequestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
    ];

    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }
}

class ZoomWebViewConfig {
  static const String desktopUserAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36";

  static Future<void> setupWebViewSettings(
      WebViewController controller, BuildContext context) async {
    final design = Design.of(context);
    await Future.wait([
      controller.setUserAgent(desktopUserAgent),
      controller.setBackgroundColor(design.colors.canvas),
    ]);

    if (await controller.supportsSetScrollBarsEnabled()) {
      await Future.wait([
        controller.setVerticalScrollBarEnabled(false),
        controller.setHorizontalScrollBarEnabled(false),
      ]);
    }
  }

  static String buildZoomWebClientUrl({
    required String? conferenceId,
    required String? password,
    required String? displayName,
    required String? fallbackUrl,
  }) {
    if (conferenceId != null && conferenceId.trim().isNotEmpty) {
      final sanitizedId = conferenceId.replaceAll(RegExp(r'\s+'), '');
      final uri = Uri.parse('https://app.zoom.us/wc/$sanitizedId/join');
      final params = <String, String>{};
      if (password != null && password.isNotEmpty) {
        params['pwd'] = password;
      }
      if (displayName != null && displayName.isNotEmpty) {
        params['uname'] = displayName;
      }
      return uri.replace(queryParameters: params).toString();
    }
    return fallbackUrl ?? '';
  }

  /// Restricts top-level navigation exclusively to legitimate Zoom meeting endpoints.
  /// Prevents external redirection to the Play Store, App Store, or non-meeting pages.
  static bool isPermittedZoomUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Only allow standard web protocols
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return false;
    }

    final host = uri.host.toLowerCase();
    final isZoomHost = host == 'zoom.us' ||
        host.endsWith('.zoom.us') ||
        host == 'zoomgov.com' ||
        host.endsWith('.zoomgov.com');

    if (!isZoomHost) {
      return false;
    }

    // Only allow meeting-related paths. Everything else on zoom.us
    // (privacy policy, terms, legal, marketing, etc.) is blocked.
    final path = uri.path.toLowerCase();
    final isMeetingPath = path.startsWith('/j/') ||
        path.startsWith('/wc/') ||
        path.startsWith('/join') ||
        path.startsWith('/s/');

    return isMeetingPath;
  }

  /// Identifies post-meeting, post-attendee, or leave endpoints that signify
  /// the user has exited or the meeting has ended.
  static bool isZoomExitUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.contains('postattendee') ||
        path.contains('postmeeting') ||
        path.endsWith('/leave') ||
        path.contains('/wc/leave') ||
        path == '/wc' ||
        path == '/wc/' ||
        path == '/wc/home';
  }
}
