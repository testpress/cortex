# forum-category-filter Specification

## Purpose
TBD - created by archiving change integrate-global-forum-feed. Update Purpose after archive.
## Requirements
### Requirement: Category Filtering
The system SHALL allow users to filter the global thread feed by category ID.

#### Scenario: User selects a category chip
- **WHEN** the user selects a category chip
- **THEN** the system SHALL request filtered global feed data with `?category=<categoryId>`
- **AND** render only matching threads

### Requirement: Independent Category Loading
The system SHALL load categories independently from feed thread loading.

#### Scenario: Forum feed starts loading
- **WHEN** `ForumPostsListScreen` is opened
- **THEN** categories SHALL be loaded asynchronously from `GET /api/v2.3/forum/categories/`
- **AND** feed rendering SHALL not wait for category response completion

