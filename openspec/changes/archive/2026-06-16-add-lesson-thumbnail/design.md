## Context
Currently, the lesson items in the UI use a 1x1 image container to display the `image` field from `LessonDto`. The `image` field is currently mapped strictly to the generic `icon` property from the backend JSON. The backend also sends a `cover_image` property which has a 16:9 aspect ratio and is a richer thumbnail of the actual content, but it is ignored.

## Goals / Non-Goals

**Goals:**
- Extract the 16:9 `cover_image` from the backend JSON and store it in the existing `image` field.
- Display the `image` in the lesson list UI using a 16:9 aspect ratio layout.
- Ensure the UI gracefully handles the fallback if the backend only provides a 1x1 `icon`.

**Non-Goals:**
- Creating any new data model fields (e.g., no new `coverImage` field).
- Completely redesigning the lesson list item layout beyond accommodating the 16:9 image constraint.

## Decisions

1. **Reuse existing property**: We will NOT introduce a new field. Instead, `LessonDto.fromJson` will map `cover_image` to the `image` field. We will NOT fall back to `icon`; if `cover_image` is missing, `image` will simply be `null`.
2. **UI Container Aspect Ratio**: Use a fixed dimension box (e.g., width 72, height 40) to enforce the 16:9 format while maintaining standard paddings in the `LessonListItem`.
3. **Fallback rendering**: Since `image` will be strictly `null` when there's no cover image, the UI will fall back to using the local vector icons (`LucideIcons`) centered inside the 16:9 colored container.

## Risks / Trade-offs

- **Risk:** Existing usages of the `image` property outside of lessons might expect it to be 1x1.
  - **Mitigation:** The changes will only affect `LessonDto` specifically. If any other screen relies strictly on it being a 1x1 square, we will ensure it uses `BoxFit.cover` or `contain` safely.
