# Proposal: Analytics Cleanup Refactoring

## Problem
The current analytics implementation has several inconsistencies in naming and UI design:
1. The `SubjectAnalytics` data model and its local database table `SubjectAnalyticsTable` use ambiguous field names like `leaf` instead of `isLeaf`, and `parent` instead of `parentId`.
2. The `SubjectAnalyticsTable` stores an `analyticsUrl`, which should ideally be constructed dynamically from the ID rather than stored statically in the database.
3. The UI components use generic labels like "Subject" and "Section Performance" instead of explicitly stating "Analytics" or "Subject Performance", causing potential user confusion.
4. Typography and button sizing across analytics screens do not align with the core design system's standards (e.g., `AppText.title`).

## Solution
To improve clarity, consistency, and maintainability across the analytics module, we propose the following refactoring steps:

### 1. Data Layer Enhancements
- **Rename Fields:** Change `leaf` to `isLeaf` and `parent` to `parentId` in `SubjectAnalyticsDto` and `SubjectAnalyticsTable`.
- **Remove Redundant Data:** Remove the `analyticsUrl` field from `SubjectAnalyticsTable` to avoid storing static URLs in the database.
- **Update Factory Methods:** Ensure all JSON parsing and from-row factory methods map correctly to the renamed fields.

### 2. Data Source & Repository Updates
- **MockDataSource:** Update all mock data generation to use the renamed fields (`isLeaf`, `parentId`).
- **HttpDataSource:** Remove URL parsing dependencies and rely on IDs.
- **SubjectAnalyticsRepository:** Construct URLs dynamically using IDs and pass them appropriately without depending on the removed `analyticsUrl` database field.

### 3. Presentation Layer & UI Cleanup
- **Widget Updates:** Update all references in the screens and widgets to use `isLeaf` and `parentId`.
- **Label Clarification:** Change generic screen titles and headers from "Subject" and "Section Performance" to "Subject Analytics" and "Subject Performance".
- **Design Standardization:** Apply `AppText.title` to analytics titles and standardize button and text sizing to match core design system conventions used in Ask Doubt and Forum screens.

## Scope
- `SubjectAnalyticsTable` and `SubjectAnalyticsDto`
- `MockDataSource` and `HttpDataSource`
- `SubjectAnalyticsRepository`
- Analytics UI screens (`SubjectAnalyticsScreen`, `OverallReportsView`, `IndividualReportsView`, etc.)

## Non-Goals
- Major UI/UX redesigns or changing the core layout of analytics screens.
- Altering the underlying API contracts or data models beyond naming conventions.
- Adding new analytics features.
