## Context

Currently, the LMS uses a generic lesson detail screen (`LessonDetailScreen`) which may not provide the optimal layout and toolset for video-based learning. As video content becomes central to the curriculum, we need a dedicated `VideoLessonDetailScreen` that contextualizes the video player with supplementary learning aids such as lecture notes, transcripts, a doubt-resolution forum, and an AI-driven study assistant. This ensures that the user's focus remains on the learning material without navigating away.

## Goals / Non-Goals

**Goals:**
- Implement the UI for `VideoLessonDetailScreen` in Flutter.
- Integrate the existing video player (e.g., TPStreams or Chewie) with a custom overlay if necessary.
- Create a tabbed view (Notes, Transcripts, Ask Doubt, AI Support) beneath/alongside the player.
- Ensure responsive design that adapts well to various device orientations (landscape for full-screen video, portrait for video + tabs).

**Non-Goals:**
- Replacing the underlying video streaming DRM provider.
- Implementing the backend for the AI assistant or doubt forum (this will rely on existing or mocked APIs for now).
- **Functional PDF download**: The "Download PDF" buttons in Notes and Transcript tabs are UI-only; no actual file download is triggered.
- **Functional AI chat**: The AI Support tab displays static/mock chat messages; no real AI inference or API calls are made.
- **Functional doubt submission**: The Ask Doubt tab renders the input form and mock doubt cards, but submitting a doubt does not persist data or call any backend API.
- **Functional send in AI tab**: The send button in the AI input field is non-functional; it does not send messages or receive AI responses.

## Decisions

1. **Screen Separation**: 
   - *Decision*: Create `VideoLessonDetailScreen` distinct from `LessonDetailScreen`.
   - *Rationale*: A video-first layout differs significantly from a text-first layout (e.g., sticky player at the top, tabs below). Keeping them separate adheres to the Single Responsibility Principle and prevents the existing `LessonDetailScreen` from becoming a monolithic component full of conditionals.
   - *Alternatives*: Add an `if (lesson.type == 'video')` block in `LessonDetailScreen`. Rejected due to complexity.

2. **Tab Navigation**:
   - *Decision*: Use Flutter's `TabBar` and `TabBarView`.
   - *Rationale*: Provides a native, smooth swiping experience between Notes, Transcripts, Doubt, and AI tabs.

3. **Video Player UI**:
   - *Decision*: We will wrap the existing DRM player in a container that supports the "First Lesson Hint" overlays and custom badges, as defined in `VideoLessonDetailScreen.tsx` reference.

4. **Idempotent Database Migrations**:
   - *Decision*: Use a helper function to verify column existence (via `PRAGMA table_info`) before executing `ALTER TABLE` statements.
   - *Rationale*: Prevents common SQLite exceptions during development when migrations might be partially applied or schema desyncs occur.

5. **Real-time Input Feedback**:
   - *Decision*: Implement character counters (using `ValueListenableBuilder`) in tabs with text inputs.
   - *Rationale*: Improves user experience by providing immediate feedback on input limits without requiring a full rebuild of the tab.

## Risks / Trade-offs

- **Performance Risk**: Running a video player alongside a potentially heavy AI chat or doubt forum list might cause UI stutters.
  - *Mitigation*: Leverage lazy loading for tab contents. Use `AutomaticKeepAliveClientMixin` to retain state when switching tabs, preventing unnecessary re-renders.
  
- **Complexity**: Synchronizing video time with transcripts.
  - *Mitigation*: For v1, the transcript could just be a scrollable list. Auto-scrolling based on video time can be implemented as a phased enhancement if the player APIs allow it.
