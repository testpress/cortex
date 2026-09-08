## Context

See `proposal.md` for motivation. Currently, `LessonDto.mergeWith` preserves `isScheduled = true` from SQLite cache regardless of fresh detail API responses, and `LiveStreamViewer` does not poll the backend for status changes while displaying a scheduled live stream.

## Goals / Non-Goals

**Goals:**
- Fix `LessonDto.mergeWith` so fresh detail updates (`isScheduled == false`) properly overwrite cached `isScheduled == true` in SQLite database.
- Implement 5-second periodic polling in `LiveStreamViewer` while `lesson.isScheduled == true` to match native Android SDK behavior (`5000ms` retry delay).

**Non-Goals:**
- Changing websocket or notification infrastructure.
- Altering player playback logic for already active streams or ready recordings.

## Decisions

### D1: Authoritative `isScheduled` Resolution in `LessonDto.mergeWith`

**Decision:** When `this.isDetailFetched` is true, `this.isScheduled` and `this.scheduledMessage` are authoritative and overwrite the cached values in `other`.

```dart
isScheduled: isDetailFetched ? isScheduled : (isScheduled || other.isScheduled),
scheduledMessage: isDetailFetched
    ? scheduledMessage
    : ((scheduledMessage?.isEmpty ?? true)
        ? other.scheduledMessage
        : scheduledMessage),
```

### D2: Stateful 5-Second Refresh Timer in `LiveStreamViewer`

**Decision:** Convert `LiveStreamViewer` into a `ConsumerStatefulWidget` that manages a 5-second `Timer.periodic`.

## Risks / Trade-offs

- **[Risk]** Excessive network calls if the user stays on the scheduled screen for a long time.
  - → **Mitigation:** The polling timer only runs while the user actively views the scheduled screen and stops immediately when `isScheduled == false` or on widget disposal.
