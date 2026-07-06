## Why
The "Offline Exam" feature allows students to download an exam while online, take it without internet connectivity, and sync their results back to the server. This is a critical capability ported from the old Android SDK to provide network resilience for exams, especially in regions with spotty internet connectivity.

## What Changes
- Introduce local persistence for the offline exam hierarchy (instructions, sections, questions, choices).
- Add robust local state tracking for exam attempts and timers that relies on the device's uptime or absolute `endDate`.
- Add a background sync mechanism to push completed attempts to the backend before the `endDate` + grace period expires.
- Implement HTML caching strategies (WebView interception, asset downloading) for WebView and native components to serve media locally.

## Capabilities
### New Capabilities
- `offline-persistence`: Local storage definitions for offline exam models.
- `offline-sync`: Queueing, grace-period validation, and syncing mechanisms for completed attempts.
- `offline-asset-caching`: Handling local storage and retrieval of images, MathJax, and HTML assets.

### Modified Capabilities
- `exam-engine`: Modifying the exam engine to support an offline-first state machine instead of purely relying on live API calls.

## Impact
- **Code:** `packages/exams` (engine and UI), `packages/core` (local db setup).
- **APIs:** Modifying how submissions are pushed and how exams are fetched to support the offline payload.
- **Dependencies:** Will introduce robust local database management (e.g., Drift/Isar), background sync (`workmanager`), and local asset serving mechanisms.
