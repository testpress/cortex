## Context

The Cortex LMS is distributed as a white-labeled product across multiple clients (e.g., Brilliant Pala, Rays). Previously, developers had to manually modify native project files (iOS/Android) and use hardcoded `--dart-define` boolean flags to toggle branding assets. This caused issues when running standard environments (`lmsdemo`) and broke UI functionality when specific logos were missing. 

We need a scalable, dynamic approach to client generation and runtime asset resolution.

## Goals / Non-Goals

**Goals:**
- Completely automate the fetching of remote client configs and injection of local branding assets into the native Flutter shell.
- Make UI components (Splash Screen, Dashboard Banner) natively resilient to missing assets without relying on compile-time boolean flags.
- Create a streamlined `flutter run` wrapper for specific client configurations.

**Non-Goals:**
- Changing the internal data structures of the core LMS platform.
- Refactoring how colors or themes are handled (this is strictly focused on logos and package names).
- Rewriting the Brilliant Pala specific dashboard logic (we are just fixing the condition that triggers it).

## Decisions

**1. Centralized Dart Scripting for Automation**
- *Rationale*: Instead of bash scripts, using Dart scripts (`app/scripts/client_utils.dart`) allows us to leverage native Dart JSON parsing and ensure cross-platform execution (Windows/macOS). 
- *Alternatives Considered*: Bash or Python scripts. Rejected because it forces Flutter developers to manage external scripting environments.

**2. Dynamic Asset Detection at Runtime**
- *Rationale*: Rather than using `--dart-define=IS_LOCAL_LOGO=true`, the UI will dynamically check if the logo URL starts with `assets/`. If it does, it uses `Image.asset()`, otherwise `Image.network()`. If `Image.asset()` fails (file missing), `errorBuilder` provides a seamless fallback.
- *Alternatives Considered*: Continuing to pass boolean flags. Rejected because it led to the `lmsdemo` bug where standard environments were forced into custom layouts due to flag collisions.



## Risks / Trade-offs

- **[Risk] Missing local assets cause a red screen crash during development**
  - *Mitigation*: We heavily utilize Flutter's `errorBuilder` parameter on all local asset images (Splash Screen, Login Screen). If the image is missing, it silently falls back to a generic icon.
- **[Risk] Git pollution from script automation**
  - *Mitigation*: The `client_utils.dart` script automatically tracks downloaded assets and safely performs `git checkout .` after the build/run process completes to ensure the workspace remains clean.
