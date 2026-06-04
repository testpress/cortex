# video-downloads Specification

## Purpose
TBD - created by archiving change integrate-video-downloads. Update Purpose after archive.
## Requirements
### Requirement: Native Player Download Integration
The system SHALL enable the native download option in the TPStreams player UI.

#### Scenario: Viewing a video lesson
- **WHEN** a user opens a video lesson
- **THEN** the TPStreams player UI SHALL display a download button, managed natively by the SDK.

### Requirement: Offline Playback
The system SHALL automatically load videos in offline mode if they have been successfully downloaded.

#### Scenario: Playing a downloaded video
- **WHEN** a user opens a video lesson that has `DownloadStatus.completed`
- **THEN** the system SHALL initialize `TPStreamPlayer` using the `.offline()` constructor with the downloaded asset ID.

### Requirement: Video Download Lifecycle Management
The system SHALL support pausing, resuming, and deleting video downloads via the TPStreams SDK.

#### Scenario: Pausing an active video download on Android
- **WHEN** a user taps the pause action on an actively downloading video
- **THEN** the system SHALL invoke `pauseDownload` on the `TPStreamsDownloadManager`.

#### Scenario: Resuming a paused video download on Android
- **WHEN** a user taps the resume action on a paused video download
- **THEN** the system SHALL invoke `resumeDownload` on the `TPStreamsDownloadManager`.

#### Scenario: Deleting a downloaded video
- **WHEN** a user taps the delete action on a video download
- **THEN** the system SHALL invoke `deleteDownload` on the `TPStreamsDownloadManager`.

