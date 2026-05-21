## 1. Database & Model updates

- [x] 1.1 Update Drift table `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart` to add `enableTranscript`, `videoSubtitleUrl` (text, stores subtitle URL), `isAiEnabled`, and `aiNotesUrl`
- [x] 1.2 Update Drift schema version to `20` and migration logic in `packages/core/lib/data/db/app_database.dart` to add the new columns safely
- [x] 1.3 Update `LessonDto` in `packages/core/lib/data/models/lesson_dto.dart` to include the new fields and update its constructor, JSON parser (`_parseBase`), `copyWith`, `mergeWith` and `toJson` methods
- [x] 1.4 Update `Lesson` domain model in `packages/courses/lib/models/course_content.dart` to include the new fields and mapper in `packages/courses/lib/providers/lesson_detail_provider.dart` and `course_repository.dart`
- [x] 1.5 Run `dart run build_runner build` in `packages/core` to regenerate Drift database files
- [x] 1.6 Run `dart run build_runner build` in `packages/courses` to regenerate Riverpod files

## 2. Dependencies & Parsers

- [x] 2.1 Add ``flutter_smooth_markdown`` to `packages/courses/pubspec.yaml` and run `flutter pub get`
- [x] 2.2 Implement a WebVTT parser function inside the courses package to convert VTT file content into a list of displayable cues (cues containing start time, end time, and text)
- [x] 2.3 Create `VideoSubtabsRepository` at `packages/courses/lib/repositories/video_subtabs_repository.dart` to fetch markdown notes and WebVTT transcript content using `Dio` (isolating heavy WebVTT parsing using `compute()`).
- [x] 2.4 Create `video_subtabs_provider.dart` at `packages/courses/lib/providers/video_subtabs_provider.dart` to expose `videoSubtabsRepositoryProvider`, `fetchNotesMarkdownProvider`, and `fetchTranscriptProvider`.
- [x] 2.5 Run `dart run build_runner build` in `packages/courses` to generate Riverpod provider code.

## 3. UI Implementation

- [x] 3.1 Modify `VideoLessonDetailScreen` in `packages/courses/lib/screens/video_lesson_detail_screen.dart` to dynamically construct the tabs and tab contents based on the lesson metadata flags
- [x] 3.2 Update the `TabController` initialization and updates (e.g. in `didUpdateWidget`) in `VideoLessonDetailScreen` to handle a variable number of tabs
- [x] 3.3 Refactor `TranscriptsTab` to watch `fetchTranscriptProvider(subtitleUrl)` rather than making raw `Dio` calls, mapping the async states cleanly
- [x] 3.4 Refactor `NotesTab` to watch `fetchNotesMarkdownProvider(notesUrl)` rather than making raw `Dio` calls, mapping the async states cleanly
- [x] 3.5 Convert `NotesTab` and `TranscriptsTab` into `StatefulConsumerWidget`s and mix in `AutomaticKeepAliveClientMixin` to prevent rebuilding on tab switches
- [x] 3.6 Wrap the contents of `NotesTab` and `TranscriptsTab` inside a `SingleChildScrollView` (or standard `ListView`) with `physics: const ClampingScrollPhysics()` to ensure highly responsive, smooth, non-conflicting nested scrolling
- [x] 3.7 Ensure the `TabBarView` scroll physics or keep-alive mechanics are perfectly integrated in `VideoLessonDetailScreen` and `VideoLessonViewer`
- [x] 3.8 Update the `isComplete` getter in `Lesson` (`packages/courses/lib/models/course_content.dart`) to require `isDetailFetched` to be true for `LessonType.video` to prevent tab insertion flickering
- [x] 3.9 Implement `Skeletonizer` loading states in `NotesTab` and `TranscriptsTab` to maintain intrinsic height and prevent the static footer from floating up
- [x] 3.10 Refactor `VideoLessonViewer` and tab components to use a sliver-based scrolling architecture (`CustomScrollView`, `SliverList`) to optimize layout performance and eliminate UI thread blocking during heavy rendering

