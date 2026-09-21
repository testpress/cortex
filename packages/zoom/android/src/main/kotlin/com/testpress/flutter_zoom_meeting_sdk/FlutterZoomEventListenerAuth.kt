package com.testpress.flutter_zoom_meeting_sdk

import android.os.Handler
import android.os.Looper
import com.testpress.flutter_zoom_meeting_sdk.FlutterZoomMeetingSdkPlugin.Companion.PLATFORM
import io.flutter.plugin.common.EventChannel
import us.zoom.sdk.ZoomSDKInitializeListener

class FlutterZoomEventListenerAuth(private val eventSinkProvider: () -> EventChannel.EventSink?):
    ZoomSDKInitializeListener {
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onZoomSDKInitializeResult(errorCode: Int, internalErrorCode: Int) {
        eventLog("onZoomSDKInitializeResult", "Init Result: errorCode=$errorCode, internalErrorCode=$internalErrorCode")

        val eventMap = mapOf(
            "platform" to PLATFORM,
            "event" to "onAuthenticationReturn",
            "oriEvent" to "onZoomSDKInitializeResult",
            "params" to mapOf(
                "statusCode" to errorCode,
                "statusLabel" to MapperZoomError.getErrorName(errorCode),
                "internalErrorCode" to internalErrorCode
            )
        )
        mainHandler.post {
            eventSinkProvider()?.success(eventMap)
        }
    }

    override fun onZoomAuthIdentityExpired() {
        eventLog("onZoomAuthIdentityExpired", "Zoom SDK auth identity expired")

        val eventMap = mapOf(
            "platform" to PLATFORM,
            "event" to "onZoomAuthIdentityExpired",
            "oriEvent" to "onZoomAuthIdentityExpired",
            "params" to emptyMap<String, Any>()
        )
        mainHandler.post {
            eventSinkProvider()?.success(eventMap)
        }
    }
}