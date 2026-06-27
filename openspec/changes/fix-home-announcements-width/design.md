## Context

The home screen displays announcement cards in a horizontal carousel. Currently, each card occupies a large portion of the screen width, limiting how many announcements are visible at once and making the section feel oversized relative to the rest of the home screen. The goal is to reduce the card width so more announcements are visible without scrolling, without changing any data-fetching, navigation, or structural behaviour.

## Goals / Non-Goals

**Goals:**
- Announcement cards in the carousel are narrower, letting users see more at a glance.
- The change is isolated to the carousel layout — no structural or data changes.

**Non-Goals:**
- Changing card height or content layout.
- Affecting the single-card rendering path.
- Modifying navigation, data fetching, or caching behaviour.
- Redesigning the announcement card visual design.

## Decisions

**Reduce announcement card width**
The announcement carousel card width should be reduced so the section feels less dominant on the home screen and users can see more content at a glance. No new abstraction or shared token is needed — this is a localised layout adjustment within the courses package.

## Risks / Trade-offs

- **Card content may feel more compact** → Announcement titles and summaries may appear more condensed. Text truncation (already in place) handles this gracefully.
- **Wider-than-expected content** → If announcement content is longer, the narrower card may truncate more aggressively, but this is an acceptable trade-off for the improved layout density.
