## Context

Zoom Android SDK relies heavily on native JNI libraries and Java reflection. During release builds, Android Gradle Plugin invokes R8 / ProGuard for code shrinking and obfuscation.

Previously, `app/android/app/proguard-rules.pro` suppressed build warnings using `-dontwarn us.zoom.**`, but lacked `-keep` rules for Zoom classes and JNI methods. As a result, R8:
1. Stripped zero-argument reflection constructors on bridge classes (`us.zoom.bridge.core.*`), causing `InstantiationException` (Sentry `CORTEX-S8`).
2. Obfuscated or stripped native method signatures (`native <methods>;` on JNI helpers), causing `UnsatisfiedLinkError: No implementation found for boolean us.zoom.internal.jni.helper.PTMSdkService.initImpl()`.

## Goals / Non-Goals

**Goals:**
- Ensure Zoom SDK classes, interfaces, reflection bridges, and native JNI methods are preserved during R8 code shrinking in release builds.
- Eliminate `InstantiationException` and `UnsatisfiedLinkError` when joining meetings in production release builds.

**Non-Goals:**
- Modifying Zoom SDK Java/Kotlin source or AAR binaries.
- Changing release signing configurations or Flutter build arguments.

## Decisions

### Add comprehensive Zoom SDK keep rules to `proguard-rules.pro`
- **Rule 1**: Keep all classes in `us.zoom.**` and `com.zipow.**` (in R8 `-keep class` covers both classes and interfaces).
- **Rule 2**: Keep `com.testpress.flutter_zoom_meeting_sdk.**`.
- **Rule 3**: Keep and suppress warnings for `org.webrtc.**` used internally by Zoom SDK for audio and video streaming (`-keep class org.webrtc.** { *; }`, `-dontwarn org.webrtc.**`).
- **Rule 4**: Keep all classes with native methods (`-keepclasseswithmembernames class * { native <methods>; }`) so JNI bindings remain intact regardless of obfuscation.

**Rationale**: These rules align directly with Zoom's official Android SDK ProGuard recommendations. WebRTC classes are looked up dynamically via JNI C++ code during `initMainboardImpl`.

## Risks / Trade-offs

- **[Risk] App size impact** → Preserving Zoom SDK and WebRTC symbols increases APK/AAB size, but ensures 100% runtime stability for live classes.
