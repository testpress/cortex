import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:flutter_zoom_meeting_sdk/enums/status_zoom_error.dart';
import 'package:flutter_zoom_meeting_sdk/flutter_zoom_meeting_sdk.dart';
import 'package:flutter_zoom_meeting_sdk/models/zoom_meeting_sdk_request.dart';

/// Service class to orchestrate Zoom Meeting SDK initialization, authentication, and joining.
class ZoomMeetingService implements MeetingService {
  ZoomMeetingService() : _zoomSdk = FlutterZoomMeetingSdk();

  final FlutterZoomMeetingSdk _zoomSdk;
  StreamSubscription? _authSubscription;

  /// Initializes the SDK, authenticates with [jwtToken], and automatically joins the meeting on success.
  @override
  Future<void> joinMeeting({
    required String jwtToken,
    required String meetingNumber,
    required String password,
    required String displayName,
  }) async {
    try {
      debugPrint('[ZoomMeetingService] Initializing Zoom SDK...');
      await _zoomSdk.initZoom();

      debugPrint('[ZoomMeetingService] Authenticating Zoom SDK...');
      await _zoomSdk.authZoom(jwtToken: jwtToken);

      // Cancel any previous subscription
      await _authSubscription?.cancel();

      _authSubscription = _zoomSdk.onAuthenticationReturn.listen((event) async {
        final status = event.params?.statusEnum;
        debugPrint(
            '[ZoomMeetingService] Authentication callback received with status: $status');

        if (status == StatusZoomError.success) {
          debugPrint(
              '[ZoomMeetingService] Zoom authenticated successfully. Joining meeting: $meetingNumber');
          try {
            await _zoomSdk.joinMeeting(
              ZoomMeetingSdkRequest(
                meetingNumber: meetingNumber,
                password: password,
                displayName: displayName,
              ),
            );
          } catch (e) {
            debugPrint('[ZoomMeetingService] Failed to join meeting: $e');
          }
        } else {
          debugPrint(
              '[ZoomMeetingService] Zoom authentication failed: $status');
        }
      });
    } catch (e) {
      debugPrint('[ZoomMeetingService] Error starting Zoom meeting: $e');
    }
  }

  /// Cleans up subscriptions and uninitializes the Zoom SDK.
  Future<void> dispose() async {
    debugPrint('[ZoomMeetingService] Cleaning up resources...');
    await _authSubscription?.cancel();
    _authSubscription = null;
    try {
      await _zoomSdk.unInitZoom();
    } catch (e) {
      debugPrint(
          '[ZoomMeetingService] Error during Zoom SDK uninitialization: $e');
    }
  }
}
