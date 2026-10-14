# zoom-sdk-proguard-rules Specification

## Purpose
TBD - created by archiving change fix-zoom-sdk-proguard-rules. Update Purpose after archive.
## Requirements
### Requirement: Zoom SDK ProGuard Preservation
The Android release build configuration SHALL preserve all Zoom SDK classes, interfaces, reflection constructors, and native JNI method bindings during R8 / ProGuard optimization.

#### Scenario: R8 release build optimization
- **WHEN** an Android release APK or AAB is built
- **THEN** R8 SHALL NOT strip or obfuscate classes under `us.zoom.**`, `com.zipow.**`, `com.testpress.flutter_zoom_meeting_sdk.**`, or `org.webrtc.**`
- **AND** R8 SHALL NOT remove native method declarations or reflection constructors required by the Zoom SDK
- **AND** R8 SHALL suppress warnings for optional missing dependencies referenced by Zoom (`com.microsoft.intune.mam.**`, `com.zipow.cnthirdparty.**`, `org.webrtc.**`).

#### Scenario: Joining a Zoom live class in release mode
- **WHEN** a user joins a Zoom meeting in a release build
- **THEN** the meeting initialization and authentication SHALL execute without `InstantiationException` or `UnsatisfiedLinkError`.

