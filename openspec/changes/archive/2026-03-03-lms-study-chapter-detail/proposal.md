## Why
The JEE/NEET coaching app needs a dedicated screen to display the lessons and assessments within a specific chapter. This screen acts as the bridge between the chapter list and the actual learning content (videos, PDFs, tests), providing a focused view of a chapter's curriculum.

## What Changes
- New `ChapterDetailPage` component in `packages/courses` to list chapter content (lessons, assessments, tests).
- Support for multiple content types: Video, PDF, Assessment, and Test with corresponding icons and labels.
- Integration with navigation to allow drilling down from a chapter list to its details.
- Status filters (Running, Upcoming, History) to help students organize their learning within a chapter.
- Interactive lesson items that navigate to specific content readers/players.

## Capabilities

### New Capabilities
- `chapter-detail`: Provides a detailed view of a chapter's contents, including lessons, assessments, and tests, with status-based filtering.

### Modified Capabilities
- `study-curriculum-list`: Navigation from the curriculum list to the chapter detail view.

## Impact
- `packages/courses`: UI components, data models, and logic for chapter details.
- `app/`: Navigation routing and deep linking support.
- `DesignConfig`: Potential extension for chapter-specific UI elements.
