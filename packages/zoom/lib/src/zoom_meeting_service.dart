import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'sdk/enums/status_zoom_error.dart';
import 'sdk/flutter_zoom_meeting_sdk.dart';
import 'sdk/models/zoom_meeting_sdk_request.dart';

/// Service class to orchestrate Zoom Meeting SDK initialization,
/// authentication, and joining using lazy initialization.
///
/// The SDK is initialized and authenticated only on the first call to
/// [joinMeeting]. Subsequent calls reuse the existing session, joining
/// the meeting instantly without re-initializing.
class ZoomMeetingService implements MeetingService {
  ZoomMeetingService() : _zoomSdk = FlutterZoomMeetingSdk();

  final FlutterZoomMeetingSdk _zoomSdk;
  StreamSubscription? _authSubscription;

  bool _isSdkInitialized = false;
  bool _isSdkAuthenticated = false;

  /// Holds the meeting request that is waiting for auth to complete.
  ZoomMeetingSdkRequest? _pendingMeetingRequest;

  /// Lazily initializes the SDK, authenticates with [jwtToken], and joins
  /// the meeting identified by [meetingNumber] and [password].
  ///
  /// On the first invocation the SDK is initialized and authenticated.
  /// Subsequent invocations reuse the existing session and join instantly.
  @override
  Future<void> joinMeeting({
    required String jwtToken,
    required String meetingNumber,
    required String password,
    required String displayName,
  }) async {
    _authSubscription ??= _zoomSdk.onAuthenticationReturn.listen((event) async {
      final status = event.params?.statusEnum;

      if (status == StatusZoomError.success) {
        _isSdkAuthenticated = true;
        _joinPendingMeeting();
      } else {
        _isSdkAuthenticated = false;
      }
    });

    _pendingMeetingRequest = ZoomMeetingSdkRequest(
      meetingNumber: meetingNumber,
      password: password,
      displayName: displayName,
    );

    try {
      // Step 1: Initialize the native SDK layer (once per app session).
      if (!_isSdkInitialized) {
        await _zoomSdk.initZoom();
        _isSdkInitialized = true;
      }

      // Step 2: Authenticate (once per token). The auth listener will
      // automatically call _joinPendingMeeting on success.
      if (!_isSdkAuthenticated) {
        await _zoomSdk.authZoom(jwtToken: jwtToken);
      } else {
        // Already authenticated — join immediately.
        _joinPendingMeeting();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Joins the meeting stored in [_pendingMeetingRequest].
  Future<void> _joinPendingMeeting() async {
    final request = _pendingMeetingRequest;
    if (request == null) return;

    try {
      await _zoomSdk.joinMeeting(request);
      _pendingMeetingRequest = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Cleans up subscriptions and uninitializes the Zoom SDK.
  Future<void> dispose() async {
    await _authSubscription?.cancel();
    _authSubscription = null;

    if (_isSdkInitialized) {
      try {
        await _zoomSdk.unInitZoom();
      } catch (e) {
        // Safe to ignore or log silently during cleanup
      }
    }

    _isSdkInitialized = false;
    _isSdkAuthenticated = false;
  }
}
