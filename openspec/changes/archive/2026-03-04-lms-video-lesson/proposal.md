## Why

The current LMS lacks a dedicated, immersive, and feature-rich interface for video-based lessons. To provide an optimal learning experience, we need to implement a Video Lesson Detail Screen that seamlessly integrates video playback with supplementary learning tools such as lecture notes, transcripts, doubt resolution, and an AI study assistant. This ensures students can effectively consume video content and clarify their doubts without leaving the context of the lesson.

## What Changes

- Add a new `VideoLessonDetailScreen` dedicated to video-type lessons.
- Implement a custom video player with controls for playback, volume, speed, full-screen, and offline download.
- Introduce a tabbed interface alongside or beneath the video player containing:
  - **Notes**: Structured lecture notes and key formulas (with PDF download capability).
  - **Transcripts**: Timestamped video transcripts (with PDF download capability).
  - **Ask Doubt**: A dedicated discussion space for the video where users can post questions and see instructor/peer replies.
  - **AI Support**: A context-aware AI chat assistant that can answer questions related to the video lecture.
- Add lesson-to-lesson navigation ("Continue to Next Lesson").

## Capabilities

### New Capabilities
- `lms-video-lesson`: Covers the core video playback experience, including custom controls (speed, full-screen, seeking), lesson navigation, and the tabbed auxiliary tools (Notes, Transcripts, Ask Doubt, AI Assistant).

### Modified Capabilities
- 

## Impact

- **UI/Screens**: A new `VideoLessonDetailScreen` screen will be added to the LMS module.
- **Routing**: Lesson navigation logic needs to route video-type lessons to this new screen instead of the regular text-based `LessonDetailScreen`.
- **Dependencies**: May require additional video player packages (e.g., `video_player`, `chewie` or the existing custom DRM player `tpstreams`), and potential AI/Chat integration plugins.
