## Context

We are implementing the `LessonDetailScreen` in Flutter. The screen is the primary interface for text-based lessons, supporting structured content types like headings, paragraphs, images, lists, and callouts.

## Goals / Non-Goals

**Goals:**
- Implement a reusable content rendering system for structured lesson content.
- Support scroll-linked reading progress tracking.
- Adhere to the institute's design system using existing tokens and extensions.
- Provide a clean, minimal UI that prioritizes readability.

**Non-Goals:**
- Implementation of video playback (out of scope for this change).
- Implementation of interactive tests or assessments (out of scope).
- Integrating the AI Doubt Chat functionality in this phase.

## Decisions

### 1. Unified Content Model
We will define a sealed class `LessonContentItem` to represent the different content types (Heading, Paragraph, Image, List, Callout). This ensures type safety and makes the rendering logic exhaustive.

### 2. Scroll-Linked Progress Tracking
We will use a `ScrollController` listener on the main content area to calculate the reading progress percentage. This will be reflected in a sticky horizontal progress bar in the header.

### 3. Subject-Driven Theme Extensions
We will leverage the existing `SubjectColors` design tokens to dynamically style badges, list bullets, and other accent elements based on the lesson's subject.

### 4. Content Rendering Approach
Each `LessonContentItem` will map to a dedicated stateless widget (e.g., `LessonHeading`, `LessonCallout`). We will use a `ListView.separated` or `Column` within a `SingleChildScrollView` (depending on content size expectations) to render the items with consistent spacing.

## Risks / Trade-offs

- **[Risk] Heavy Content Performance** → [Mitigation] Use `ListView.builder` or `SliverList` if lesson content becomes extremely long to preserve 60fps scrolling.
- **[Risk] Diverse Image Aspect Ratios** → [Mitigation] Use `AppImage` with `BoxFit.fitWidth` and proper placeholders to prevent layout shifts.
- **[Trade-off] Static vs. HTML Content** → We are choosing a structured JSON-like model for content rather than raw HTML to maintain better control over typography and styling, matching the design requirements.
