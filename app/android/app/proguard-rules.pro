-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**
-dontwarn com.google.android.gms.auth.api.credentials.**
-dontwarn com.payu.**

# Suppress R8 warnings for optional dependencies
-dontwarn com.android.billingclient.api.**
-dontwarn com.google.android.play.core.**
-dontwarn com.google.zxing.**
-dontwarn com.scwang.smart.refresh.**
-dontwarn com.symbol.emdk.**
-dontwarn io.noties.markwon.**
-dontwarn io.noties.prism4j.**
-dontwarn java.awt.**
-dontwarn javax.lang.model.**
-dontwarn javax.swing.**
-dontwarn org.commonmark.**
-dontwarn retrofit2.**
-dontwarn us.zoom.**

# Zoom: optional Intune / China-login deps
-dontwarn com.microsoft.intune.mam.**
-dontwarn com.zipow.cnthirdparty.**

# Keep Zoom SDK classes, reflection bridges, and plugins
-keep class us.zoom.** { *; }
-keep class com.zipow.** { *; }
-keep class com.testpress.flutter_zoom_meeting_sdk.** { *; }

# WebRTC components utilized by Zoom SDK
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**

# Keep native methods so JNI bindings remain intact
-keepclasseswithmembernames class * {
    native <methods>;
}
