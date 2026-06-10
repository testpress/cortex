# Analytics Cleanup Refactoring

## Overview
Refactor analytics codebase to improve clarity and consistency by:
1. Clarifying UI naming to use "Analytics" instead of generic "Subject" where analytics context is intended
2. Renaming table and DTO fields for clarity (`leaf` → `isLeaf`, `analyticsUrl` removal)
3. Standardizing button and text sizing across analytics screens

## Goals
- Improve code readability and intent clarity in analytics-related code
- Standardize field naming conventions (snake_case → camelCase, clarify purpose)
- Ensure consistent UI sizing patterns across analytics components
- Remove redundant URL field from table (use direct API calls)

## Non-Goals
- Major UI/UX redesign
- Changing analytics data models or API contracts
- Refactoring other modules (courses, lessons)
- Adding new analytics features

---

## Changes by Category

### 1. Table & DTO Field Renames

#### 1.1 SubjectAnalyticsTable.leaf → isLeaf
- **Current**: `BoolColumn get leaf => boolean().withDefault(const Constant(true))();`
- **Target**: `BoolColumn get isLeaf => boolean().withDefault(const Constant(true))();`
- **Reason**: Consistency with chapter_dto.dart which also uses `isLeaf`

#### 1.2 SubjectAnalyticsDto.leaf → isLeaf
- **Current**: `final bool leaf;`
- **Target**: `final bool isLeaf;`
- **Reason**: Consistency with naming conventions

#### 1.3 Remove analyticsUrl from SubjectAnalyticsTable
- **Current**: `TextColumn get analyticsUrl => text()();`
- **Target**: Remove entirely
- **Reason**: URL should be constructed from ID or passed directly in repositories

### 2. UI Screen/Component Naming

#### 2.1 Clarify Analytics Screen Labels
- Subject analytics header: Change from generic "Analytics" to "Subject Analytics"
- Section headers: "Section Performance" → "Subject Performance" (more descriptive)

### 3. Text & Button Sizing Standardization
- Match analytics titles and typography with the core design system's `AppText.title` used in Ask Doubt and Forum headers.
- Maintain consistent spacing and button sizing according to standard.
