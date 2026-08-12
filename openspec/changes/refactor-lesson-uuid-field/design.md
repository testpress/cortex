# Design — refactor-lesson-uuid-field

## Context

`contentUrl` currently serves two distinct purposes: a real media URL (PDF, embed, notes, attachment,
Fermion stream, video conference join URL) and, for TPStreams `video` / `liveStream` lessons, the
root-level `json['uuid']` that the TPStreams player needs as an asset id. This overload causes a real
bug for `videoConference` lessons: during the meeting `contentUrl` is the join URL, and after the
meeting ends the player needs the root UUID, which is currently dropped.

## Approach

Introduce a single dedicated `uuid` field that always mirrors the root `json['uuid']`, populate it in
`_parseBase` so every parser inherits it, and switch TPStreams consumers to read `lesson.uuid`.

### 1. `LessonDto` (packages/core)

- Add `final String? uuid;` alongside `contentUrl`.
- Add `this.uuid,` to the constructor, `String? uuid,` + `uuid: uuid ?? this.uuid` to `copyWith`,
  `uuid: (uuid?.isEmpty ?? true) ? other.uuid : uuid` to `merge`, and `'uuid': uuid` to `toJson`.
- `_parseBase` adds `uuid: json['uuid']?.toString()` so video, embed, pdf, notes, attachment,
  live-stream, and video-conference parsers all get it automatically.
- `_parseVideoLesson` sets `contentUrl: null`; the TPStreams asset id now travels in `uuid`.

### 2. Database (packages/core)

- Add a nullable `TextColumn uuid` to `LessonsTable` (mirroring the existing `contentUrl` column).
- Bump the drift migration version so `app_database.g.dart` picks up the new column.
- Run `dart run build_runner build --delete-conflicting-outputs` to regenerate.

### 3. Domain model (packages/courses)

- Add `final String? uuid;` to `Lesson` and pass it through `toDto()`.

### 4. Mapping layer (packages/courses)

- `lesson_detail_provider.dart`: map `lessonDto.uuid` into `Lesson.uuid`.
- `chapter_detail_provider.dart`: map `l.uuid` into `Lesson.uuid`.
- `course_repository.dart`: read `row.uuid` when hydrating from DB and write
  `Value(dto.uuid)` (absent when null) when persisting.

### 5. UI consumers (packages/courses)

- `video_lesson_viewer.dart`: `assetId: widget.lesson.uuid`.
- `live_stream_viewer.dart`: `assetId: lesson.uuid`.
- `ai_tab.dart`: TPStreams asset id = `lesson.uuid`.
- `video_mcq_tab.dart`: TPStreams asset id = `lesson.uuid`.

## Non-goals

- No changes to real-URL consumers (PDF, embed, notes, attachment, Fermion, video conference join URL).
- No change to the API contract; `uuid` is already present at the root of content payloads.

## Verification

- `flutter analyze` clean.
- `dart test` in `packages/core` and `packages/courses`.
- Manual: TPStreams video and live stream load; Fermion stream still uses its URL; PDF still opens.
