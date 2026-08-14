package com.testpress.flutter_zoom_meeting_sdk

import com.testpress.flutter_zoom_meeting_sdk.FlutterZoomMeetingSdkPlugin.Companion.PLATFORM
import io.flutter.plugin.common.EventChannel
import us.zoom.sdk.ZoomSDKInitializeListener

class FlutterZoomEventListenerAuth(private val eventSinkProvider: () -> EventChannel.EventSink?):
    ZoomSDKInitializeListener {
    override fun onZoomSDKInitializeResult(errorCode: Int, internalErrorCode: Int) {
        eventLog("onZoomSDKInitializeResult", "Init Result: errorCode=$errorCode, internalErrorCode=$internalErrorCode")

        eventSinkProvider()?.success(
            mapOf(
                "platform" to PLATFORM,
                "event" to "onAuthenticationReturn",
                "oriEvent" to "onZoomSDKInitializeResult",
                "params" to mapOf(
                    "statusCode" to errorCode,
                    "statusLabel" to MapperZoomError.getErrorName(errorCode),
                    "internalErrorCode" to internalErrorCode
                )
            )
        )
    }

    override fun onZoomAuthIdentityExpired() {
        eventLog("onZoomAuthIdentityExpired", "Zoom SDK auth identity expired")

        eventSinkProvider()?.success(
            mapOf(
                "platform" to PLATFORM,
                "event" to "onZoomAuthIdentityExpired",
                "oriEvent" to "onZoomAuthIdentityExpired",
                "params" to emptyMap<String, Any>()
            )
        )
    }
}