## Context
When a user navigates from an exam review to the Ask Doubt form, a context box displays the raw Question ID instead of the question text. Currently, no breadcrumb is shown at all in this flow. Additionally, the "Ask Doubt" breadcrumb widget uses domain-specific names (`courseName`, `chapterName`) making it hard to reuse.

## Goals / Non-Goals
**Goals:**
- Display the stripped question text instead of the question ID on the Ask Doubt screen's context box.
- Make the "Ask Doubt" breadcrumb widget domain-agnostic by using a generic `List<String>` of breadcrumbs.

**Non-Goals:**
- Completely rewrite HTML stripping to use a DOM parser.

## Decisions
- **Decision 1: Full Hierarchical Breadcrumbs for Exams**
  - *Rationale:* Passing `chapterContentId` down the router stack allows the Ask Doubt screen to fetch the `Course Name` and `Chapter Name`, appending the `Exam Title` to show a full 3-level hierarchy instead of just the exam title.
- **Decision 2: Update Breadcrumb Widget to use a List of Strings**
  - *Rationale:* Instead of rigid `courseName` and `chapterName` fields, a `List<String> breadcrumbs` makes the component fully generic and supports varying hierarchy depths.

## Risks / Trade-offs
- None
