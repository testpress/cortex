## Why
The backend provides a rich `cover_image` (16:9) for lesson contents in the v3 API. However, the current `LessonDto` data model only maps the generic `icon` property to its `image` field. As a result, the app ignores the actual video/content thumbnails and only displays generic 1x1 icons everywhere, resulting in a suboptimal user experience. Updating the models and the UI to support the 16:9 `cover_image` will make the lesson lists visually richer.

## What Changes
- Update `LessonDto.fromJson` to map `cover_image` directly to the `image` property. It will no longer fall back to the `icon` field; if `cover_image` is missing, `image` will be `null`. No new data fields will be added.
- Update the UI component (`LessonListItem`) to use a 16:9 aspect ratio container (e.g., width 72, height 40) for thumbnails instead of a 1x1 square.
- Implement a fallback strategy in the UI: If `image` is `null`, display the 16:9 container with the lesson's generic vector icon centered over a tinted background.

## Capabilities

### New Capabilities
- `lesson-thumbnail-support`: Introduces support for parsing and displaying 16:9 lesson cover images gracefully across the app, ensuring consistent fallback behavior when thumbnails are missing.

### Modified Capabilities
- `course-api`: Updating the data model parsing logic to extract `cover_image`.

## Impact
- **Data Models:** `LessonDto`, `Lesson`.
- **UI Components:** `LessonListItem` (and potentially other widgets that render lesson thumbnails).
- **Behavior:** Lesson lists will shift from a square 40x40 icon to a 16:9 rectangular thumbnail.
