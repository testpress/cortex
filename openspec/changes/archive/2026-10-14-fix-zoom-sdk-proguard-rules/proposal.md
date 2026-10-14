## Why

In Android release builds, R8 code shrinking and minification strips unused classes, constructors, and obfuscates native JNI symbols. Because `app/android/app/proguard-rules.pro` only specified `-dontwarn us.zoom.**`, R8 stripped reflection constructors (`us.zoom.bridge.core.*`) and JNI native method signatures (`us.zoom.internal.jni.helper.*`), causing crashes (`InstantiationException` and `UnsatisfiedLinkError`) whenever students tap "Attend Class" in production.

## What Changes

- Add Zoom SDK `-keep` rules to `app/android/app/proguard-rules.pro` to prevent R8 from stripping or obfuscating Zoom classes, interfaces, reflection constructors, and native JNI methods.

## Capabilities

### New Capabilities
- `zoom-sdk-proguard-rules`: ProGuard / R8 preservation rules for Zoom SDK classes, interfaces, reflection bridges, and native JNI method bindings in Android release builds.

### Modified Capabilities
<!-- None -->

## Impact

- `app/android/app/proguard-rules.pro`: Keeps Zoom SDK classes and native methods in release builds.
- Resolves Sentry crash `CORTEX-S8`.
