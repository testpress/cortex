## Why

Students need a seamless way to pick up their learning exactly where they left off. Currently, the "Resume Learning" section on the dashboard uses hardcoded mock data, which does not reflect the user's actual progress or recent activity.

## What Changes

- **API Integration**: Implementation of the `/api/v2.4/resume/` endpoint to fetch real-time user progress data.
- **Normalized Parsing Logic**: Enhanced `DashboardContentsDto.fromJson` to handle the relational "Resume" JSON structure by filtering `chapter_contents` (lessons) based on their presence in `user_videos` (for videos) and `assessments` (for exams/assessments).
- **Progress Synchronization**: Mapping of `watched_duration` and `remaining_time` to the standard `progress` field in `DashboardContentDto`.
- **Persistence**: Synchronization of the "Resume Learning" feed into the `DashboardContentsTable` with the `resumeLearning` section type for offline access.
- **UI Connectivity**: Updating `PaidActiveHomeScreen` to consume a new `resumeLearningFeedProvider` instead of static dummy data.

## Capabilities

### New Capabilities
- `api-dashboard-resume`: Handles the fetching and normalization of the resume learning feed, joining content metadata with user progress from videos and assessments.

### Modified Capabilities
<!-- No requirement changes to existing specs; using existing generic infrastructure. -->

## Impact

- **Core Package**:
    - `ApiEndpoints`: Addition of the `/api/v2.4/resume/` endpoint.
    - `DataSource`: Addition of `getResumeLearningFeed` (or extending `getWhatsNewFeed` if possible).
    - `DashboardContentsDto`: Updated `fromJson` to support the complex resume payload.
    - `DashboardRepository`: New `watchResumeLearningFeed` and `refreshResumeLearningFeed` methods.
- **Courses Package**:
    - `dashboard_providers.dart`: New Riverpod provider for the resume feed.
- **Testpress Package**:
    - `PaidActiveHomeScreen`: Replaced `dummyResumeLessons` with the real data stream.
