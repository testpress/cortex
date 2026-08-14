# Zoom Native Wrapper

A locally managed Flutter plugin wrapper for integrating the Zoom Meeting SDK across Android and iOS platforms. 

This plugin is a custom fork of `flutter_zoom_meeting_sdk` tailored for this monorepo codebase.

## Directory Structure
- `android/`: Native Android wrapper code using Zoom's `mobilertc` library.
- `ios/`: Native iOS wrapper code using Zoom's `MobileRTC` framework.
- `lib/`: Dart wrapper classes exposing platform channels and model representations.

---

## Developer Requirements (Git LFS)
The Zoom SDK contains native binaries that are larger than 100 MB (`mobilertc.aar` and `MobileRTC`). To avoid committing these huge files directly to standard git history, this repository utilizes **Git LFS (Large File Storage)**.

When checking out this package for the first time, you must download the LFS assets using:
```bash
# Install Git LFS on your system
brew install git-lfs

# Initialize in your shell
git lfs install

# Download the large binaries to your local directory
git lfs pull
```

---

## Architectural Configurations (Android)
To prevent runtime clashes and integration errors, the following build structures are configured automatically:
1. **ViewBinding Integration**: Enabled `viewBinding = true` inside the plugin's `build.gradle.kts` to resolve native ViewBinding layout loader crashes.
2. **Jetpack Compose Compatibility**: Added Compose BOM dependency alignment platform blocks to resolve `NoSuchMethodError` inside native preview layouts.
3. **SQLite Collision Fix**: The app cap constraints `sqlite3` to `<3.0.0` in `packages/core` to disable native asset generation, ensuring both Drift and Zoom share the single SQLite library packaged by `mobilertc.aar`.
