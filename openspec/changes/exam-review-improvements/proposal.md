## Why
When a user navigates to the "Ask Doubt" screen from an exam review, a context box is displayed with the raw Question ID. Currently, there is no breadcrumb hierarchy shown at all for questions (only for lessons). This is a poor user experience. It should display the Chapter Name and Exam Title as a breadcrumb above the context box, and the context box should display the actual question text. Separately, the "Ask Doubt" breadcrumb widget currently uses specific domain names (`courseName`, `chapterName`), limiting its reusability as a generic context component. We need it to handle a flexible list of breadcrumb strings instead of hardcoded fields.

## What Changes
- **Ask Doubt Context UI:** Update the Ask Doubt screen's context box to display the actual question text using `AppHtml` to properly render math equations and preserve rich formatting, instead of showing raw question IDs or stripping HTML.
- **Hierarchical Breadcrumbs:** Plumb `chapterContentId` down the router stack so the Ask Doubt screen can fetch and display the `Chapter Name > Exam Title` hierarchy.
- **Generic Breadcrumbs:** Update the Ask Doubt breadcrumb widget to accept a `List<String> breadcrumbs` instead of specific `courseName`/`chapterName` fields, allowing flexible hierarchy display (e.g. passing just the Chapter and Exam Title).

## Capabilities

### New Capabilities
None

### Modified Capabilities
- `doubts-compose-ui`: Update UI requirement to render the raw question text (including math and HTML) in the context box using a single-line WebView (`AppHtml`), instead of stripping HTML or showing the question ID.
- `ui-ask-doubt-breadcrumb`: Update widget to use a `List<String>` for breadcrumbs to make the component fully domain-agnostic.

## Impact
- **UI:** Ask Doubt Compose Screen (displays question text context), Ask Doubt Breadcrumb (uses dynamic list).
