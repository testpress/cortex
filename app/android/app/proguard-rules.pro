-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**
-dontwarn com.google.android.gms.auth.api.credentials.**
-dontwarn com.payu.**

# Rules added to suppress R8 warnings for optional Zoom SDK dependencies
-dontwarn com.android.billingclient.api.**
-dontwarn com.google.android.play.core.**
-dontwarn com.google.zxing.**
-dontwarn com.microsoft.intune.mam.**
-dontwarn com.scwang.smart.refresh.**
-dontwarn com.symbol.emdk.**
-dontwarn com.zipow.cnthirdparty.**
-dontwarn io.noties.markwon.**
-dontwarn io.noties.prism4j.**
-dontwarn java.awt.**
-dontwarn javax.lang.model.**
-dontwarn javax.swing.**
-dontwarn org.commonmark.**
-dontwarn retrofit2.**
-dontwarn us.zoom.**

# Keep Zoom SDK classes, interfaces, reflection bridges, and plugins
-keep class us.zoom.** { *; }
-keep interface us.zoom.** { *; }
-keep class com.zipow.** { *; }
-keep interface com.zipow.** { *; }
-keep class com.testpress.flutter_zoom_meeting_sdk.** { *; }

# WebRTC components utilized by Zoom SDK
-keep class org.webrtc.** { *; }
-keep interface org.webrtc.** { *; }
-dontwarn org.webrtc.**

# Keep native methods so JNI bindings remain intact
-keepclasseswithmembernames class * {
    native <methods>;
}
