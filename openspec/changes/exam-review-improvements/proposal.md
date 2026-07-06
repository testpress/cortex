## Why
When a user navigates to the "Ask Doubt" screen from an exam review, a context box is displayed with the raw Question ID. Currently, there is no breadcrumb hierarchy shown at all for questions (only for lessons). This is a poor user experience. It should display the Exam Title as a breadcrumb above the context box, and the context box should display the actual question text. Separately, the "Ask Doubt" breadcrumb widget currently uses specific domain names (`courseName`, `chapterName`), limiting its reusability as a generic context component. We need it to handle a flexible list of breadcrumb strings instead of hardcoded fields.

## What Changes
- **Ask Doubt Context UI:** Update the Ask Doubt screen's context box to display the actual question text instead of the question ID.
- **Hierarchical Breadcrumbs:** Plumb `chapterContentId` down the router stack so the Ask Doubt screen can fetch and display the full `Course Name > Chapter Name > Exam Title` hierarchy.
- **Generic Breadcrumbs:** Update the Ask Doubt breadcrumb widget to accept a `List<String> breadcrumbs` instead of specific `courseName`/`chapterName` fields, allowing flexible hierarchy display (e.g. passing just the Exam Title).

## Capabilities

### New Capabilities
None

### Modified Capabilities
- `doubts-compose-ui`: Update UI requirement to display stripped question text in the context box instead of question ID.
- `ui-ask-doubt-breadcrumb`: Update widget to use a `List<String>` for breadcrumbs to make the component fully domain-agnostic.

## Impact
- **UI:** Ask Doubt Compose Screen (displays question text context), Ask Doubt Breadcrumb (uses dynamic list).
