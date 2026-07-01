## Context
When a user navigates from an exam review to the Ask Doubt form, a context box displays the raw Question ID instead of the question text. Currently, no breadcrumb is shown at all in this flow. Additionally, the "Ask Doubt" breadcrumb widget uses domain-specific names (`courseName`, `chapterName`) making it hard to reuse.

## Goals / Non-Goals
**Goals:**
- Display the stripped question text instead of the question ID on the Ask Doubt screen's context box.
- Make the "Ask Doubt" breadcrumb widget domain-agnostic by using a generic `List<String>` of breadcrumbs.

**Non-Goals:**
- Completely rewrite HTML stripping to use a DOM parser.

## Decisions
- **Decision 1: Update Breadcrumb Widget to use a List of Strings**
  - *Rationale:* Instead of rigid `courseName` and `chapterName` fields, a `List<String> breadcrumbs` makes the component fully generic and supports varying hierarchy depths (e.g. single exam title).

## Risks / Trade-offs
- None
