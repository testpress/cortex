## 1. Data Layer — Provider Field

- [x] 1.1 Add `liveStreamProvider` (`String?`) field to `LessonDto` in `packages/core/lib/data/models/lesson_dto.dart` (constructor, `copyWith`, `mergeWith`, `toJson`)
- [x] 1.2 In `_parseLiveStreamLesson`, parse `liveStream?['provider']?.toString()` into `liveStreamProvider`, then assign `contentUrl` provider-aware:
  - **Fermion** (`provider.contains("fermion")`): use `liveStream?['stream_url']` (the embed URL needed by the WebView)
  - **TpStreams / null**: keep existing priority — `json['uuid'] ?? liveStream?['stream_url'] ?? ...` (UUID is the asset ID expected by the TpStreams SDK)
- [x] 1.3 Add `liveStreamProvider` (`String?`) field to `Lesson` domain model in `packages/courses/lib/models/course_content.dart` (constructor, `toDto()`)

## 2. UI — Fermion Lobby Screen

- [x] 2.1 In `live_stream_viewer.dart`, add a provider branch: when `lesson.liveStreamProvider?.toLowerCase() == 'fermion'`, render `_FermionLobbyView` instead of `CustomVideoPlayer`
- [x] 2.2 Implement `_FermionLobbyView` as a private `StatelessWidget` inside `live_stream_viewer.dart` using `AppText`, `AppButton.primary`, `Design.of(context)`, and `LucideIcons` — no Material/Cupertino widgets
- [x] 2.3 `_FermionLobbyView` shows different UI based on `lesson.streamStatus` and `lesson.showRecordedVideo`:
  - `isScheduled == true` → `_ScheduledMessageView` (calendar icon + message, no button)
  - `streamStatus == "Running"` → session title + **"Join Now"** button
  - `streamStatus == "Completed"` and `showRecordedVideo == true` → session title + **"Watch Recording"** button
  - `streamStatus == "Completed"` and `showRecordedVideo == false` → ended/unavailable notice (no button)
- [x] 2.4 Display Duration in minutes and Start Time formatted as 'dd MMM yyyy, hh.mm a' in a card/container on the Fermion lobby screen if available

## 3. UI — WebView Navigation

- [x] 3.1 On "Attend Class" tap inside `_FermionLobbyView`, push `AppWebView(url: lesson.contentUrl!)` using `Navigator.of(context).push(AppRoute(page: AppWebView(...)))` — no new route name or `GoRouter` change required
- [x] 3.2 Wrap the "Attend Class" button with `AppSemantics.button` (label: "Join live session") to meet WCAG touch-target and semantic requirements
- [x] 3.3 Revert edge-to-edge `SystemChrome` configuration and retain standard `SafeArea` wrapper in `AppWebView`
- [x] 3.4 Apply CSS reset margins and padding in `AppWebView`'s `onPageFinished` in media mode
- [x] 3.5 Fix `lessonDetail` provider keep-alive logic to ensure background API sync triggers on every lesson re-entry
- [x] 3.6 Invalidate `lessonDetailProvider` inside `FermionLobbyView` on returning from `AppWebView` to trigger refetches

## 4. Verification

- [x] 4.1 Hot-reload with a Fermion lesson (`status: "Running"`): confirm lobby shows metadata card (Duration & Start Time) + "Attend Class" button (no title or header icon)
- [x] 4.2 Tap "Attend Class": confirm the Fermion embed URL loads in a full-screen WebView
- [x] 4.3 Test with a Fermion lesson (`status: "Completed"`, `showRecordedVideo: true`): confirm lobby shows metadata card + "Attend Class" button (recording state)
- [x] 4.4 Tap "Attend Class": confirm the same embed URL loads in a full-screen WebView (recording playback)
- [x] 4.5 Test with a Fermion lesson (`status: "Completed"`, `showRecordedVideo: false`): confirm an ended/unavailable notice is shown (no button)
- [x] 4.6 Confirm a TpStreams lesson still renders the inline video player (no regression)
- [x] 4.7 Confirm a lesson with no `provider` field still renders the inline video player (null-safety)
- [x] 4.8 Confirm a scheduled Fermion session shows the scheduled message view (no button)
