## Why

Currently, PDF lessons and attachments share the same explicit download progress UI and are being stored in problematic locations. PDFs, which are only meant for secure, offline viewing within the app (caching), are stored in user-accessible folders. Meanwhile, attachments, which are meant for explicit download and external access, are stored in app-private folders. This causes a confusing user experience and breaks intended privacy boundaries. 

## What Changes

- Create a centralized `FileDownloader` utility to strictly separate the logic for "caching" vs "downloading" files.
- Ensure proper Android storage permissions are handled securely for external downloads.
- Change PDF storage to use internal, app-scoped support directories (invisible to users/other apps).
- Remove the explicit download progress UI for PDFs; they will be silently cached in the background for a better UX.
- Change Attachment storage to use the public device `Downloads` directory so users can access them outside the app.
- Retain explicit download progress UI for Attachments.

## Capabilities

### New Capabilities
- `lesson-background-caching`: Silent pre-fetching and caching of PDF lesson content to internal storage without exposing download progress UI.
- `attachment-public-downloads`: Explicit downloading of attachments to the device's public Downloads directory with proper permission handling.

### Modified Capabilities
- `lesson-pdf-playback`: Updating the rendering behavior to rely on silently cached internal files rather than showing explicit download progress.

## Requirements

### Requirement: Silently Cached PDF Lessons
PDF lesson content SHALL be cached in app-private storage without displaying download progress UI to ensure a seamless "instant viewing" experience.

#### Scenario: Silent caching on lesson entry
- **WHEN** a user opens a PDF lesson
- **THEN** the system SHALL initiate a background cache operation if the file is missing.
- **AND** the UI SHALL show a simple loading state instead of a progress bar.

### Requirement: Publicly Accessible Attachments
Attachment files SHALL be stored in the device's public Downloads directory to allow users to view and share them using external applications.

#### Scenario: Explicit download to public storage
- **WHEN** a user initiates an attachment download
- **THEN** the system SHALL display a real-time progress indicator.
- **AND** it SHALL save the file to the system's public Downloads directory upon completion.

## Impact

- **UI / UX**: PDF loading will appear instantaneous and distraction-free. Attachment downloads will behave like native browser downloads.
- **Security & Privacy**: PDFs will be locked inside the app's secure storage.
- **Dependencies**: Integrates `permission_handler` to properly request public storage access on Android.
