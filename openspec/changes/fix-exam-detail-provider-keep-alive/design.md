## Context

`examDetailProvider` currently uses Riverpod's `AutoDispose`, meaning it discards the fetched `ExamDto` the moment `ExamPrescreen` unmounts. Every re-open triggers a full network fetch and shimmer. There is no persistent storage of exam metadata anywhere in the app.

The existing app already uses **Drift (SQLite)** as the persistence layer for courses, lessons, leaderboard, dashboard banners, etc. (see `packages/core/lib/data/db/`). The `ExamDto` model already implements `toJson()`/`fromJson()`. This makes a Drift-backed SWR cache the natural, consistent choice.

## Goals / Non-Goals

**Goals:**
- Show exam metadata instantly on every open (including after app kill) once it has been fetched at least once.
- Keep metadata fresh by silently refetching in the background on every open.
- Update the UI automatically if the server returns changed data.

**Non-Goals:**
- No TTL / expiry logic — the background fetch always runs on open.
- No offline-only mode — the app still requires a network for the very first fetch.
- No changes to any other providers.

## Decisions

### Decision: Store `ExamDto` as a JSON blob column in `LessonsTable`

Rather than mapping every `ExamDto` field to a separate Drift column, we store the full object as a single `TEXT` column (`examMetadataJson`) on the existing `LessonsTable`. `ExamDto` already has `toJson()`/`fromJson()`. The `LessonsTable` already has a `slug` column which corresponds to the exam slug.

**Why:** Simpler approach. No new Drift table needed. No schema migration complexity when `ExamDto` gains new fields. Consistent with how structured data can be cached.

**Alternatives considered:**

| Option | Why rejected |
|---|---|
| New `ExamMetadataTable` | Rejected by user to avoid creating a new table. |
| Individual columns per field | More migration work, breaks when ExamDto fields change |
| SharedPreferences | No stream/watch support; not consistent with existing DB patterns |
| In-memory only (`keepAlive: true`) | Lost on app kill — doesn't meet the requirement |

---

### Decision: Rewrite `examDetailProvider` as a `keepAlive: true` `AsyncNotifier`

The SWR logic lives inside the notifier's `build()`:
1. Read cached row from Drift — if found, set state to the cached `ExamDto` immediately (no shimmer).
2. Fetch from network in background (`unawaited`).
3. On success: compare with cached value. If different, upsert to DB → notifier re-reads watch stream → state updates.
4. On network failure with existing cache: silently ignore — show stale data.
5. On network failure with no cache: propagate error to `AsyncError`.

`keepAlive: true` ensures the provider (and its in-memory state) also survive within the same session — no re-trigger even for background-to-foreground transitions.

**SWR Flow:**

```
open prescreen
     │
     ├──▶ DB has row? → emit cached ExamDto instantly (no shimmer)
     │         └──▶ background fetch → diff → if changed, upsert DB
     │
     └──▶ DB empty? → show loading → fetch → upsert DB → emit ExamDto
```

## Risks / Trade-offs

- **Stale data window**: Between app open and background fetch completing, the user sees the last-cached data. For exam metadata (title, duration, question count) this is acceptable — admins rarely change these mid-day.
- **Schema migration**: We add a new Drift table and bump `schemaVersion`. The existing `onUpgrade` strategy recreates all tables (drops + creates), so no data from prior tables is lost on upgrade. The new `exam_metadata` table simply starts empty.
- **Memory**: `keepAlive: true` keeps one `ExamDto` per slug in memory for the session. Negligible.
