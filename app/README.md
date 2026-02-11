# Cortex Reference App

This application serves as a reference implementation for the Cortex SDK.

## Purpose
The `app/` package is strictly a **consumer** of the SDK modules. It demonstrates how to integrate `package:testpress` to build a complete learning experience.

### White-Labeling
Current branding is based on the default `DesignConfig`. Future white-label applications will replace this implementation with tenant-specific branding while consuming the same underlying SDK modules.

## Architecture
- Imports ONLY `package:testpress`.
- No direct references to `core`, `courses`, or `exams` implementation details.
- Uses `DesignProvider` at the root for design governance.

## Development
To run the app:
```bash
flutter run
```
