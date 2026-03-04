## 1. Project Setup & Routing

- [x] 1.1 Create `VideoLessonDetailScreen` in `packages/courses/lib/screens/video_lesson_detail_page.dart`.
- [x] 1.2 Update routing logic in `packages/testpress/lib/navigation/app_router.dart` and `LessonDetailScreen` navigation logic to route video-type lessons to `VideoLessonDetailScreen`.

## 2. Core Video Layout

- [x] 2.1 Implement the video player overlay using the existing player widget.
- [x] 2.2 Add custom player badge overlays and UI hints (like the first lesson hint).
- [x] 2.3 Add full-screen, playback speed, and volume custom controls over the player.

## 3. Tabbed Interface

- [x] 3.1 Implement a `TabBar` below the video with tabs: "Notes", "Transcripts", "Ask Doubt", "AI Support".
- [x] 3.2 Create the `NotesTab` widget to render structured markdown-like notes and the PDF download button.
- [x] 3.3 Create the `TranscriptsTab` widget showing a scrolling list of transcript segments.

## 4. Interactive Tools

- [x] 4.1 Implement the `DoubtTab` widget: list of recent doubts, and a submission text field.
- [x] 4.2 Implement the `AITab` widget: mock conversational UI with a chat input and predefined mock AI responses.

## 5. Navigation & Polish

- [x] 5.1 Implement "Continue to Next Lesson" button at the bottom of the screen to load the next sequence item.
- [x] 5.2 Validate correct scrolling and keeping state alive for each tab (`AutomaticKeepAliveClientMixin`).
- [x] 5.3 Test responsive behavior when rotating device to landscape (force full-screen layout).
