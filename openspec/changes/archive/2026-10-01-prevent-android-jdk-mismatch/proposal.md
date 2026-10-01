# Proposal

## Why
Fresh checkouts inherit an arbitrary Java installation from Flutter or the IDE and fail inside Gradle with an opaque version error. Developers need a declared Android build environment, a setup command, and actionable validation before Gradle starts.

## What Changes
- Declare Java 21 as the supported Android build JDK.
- Add a macOS/Linux setup command that finds an installed Java 21 JDK and configures Flutter, or explains how to install one.
- Reject unsupported Java versions in both Gradle launchers before starting Gradle.
- Align Android CI with the declared JDK and correct first-run documentation.

## Capabilities

### New Capabilities
- `android-build-environment`: Supported JDK discovery, setup, and early Android build validation.

### Modified Capabilities
None. Existing quality-check workflow requirements remain unchanged.

## Impact
Root JDK declaration, development tooling, Android Gradle launchers, Android CI setup, and setup documentation. Flutter's JDK configuration is machine-wide; setup must disclose this before changing it. No application or SDK behavior changes.
