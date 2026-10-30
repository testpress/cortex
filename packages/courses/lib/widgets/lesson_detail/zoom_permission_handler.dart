import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

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
