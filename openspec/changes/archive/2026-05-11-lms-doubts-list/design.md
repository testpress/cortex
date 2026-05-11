## Context
Introduction of a private doubt-clearing system inside the `discussions` package.

## Goals / Non-Goals
**Goals:**
- Establish a normalized database schema for doubts and replies.
- Implement a searchable landing screen for personal doubts.
- Integrate doubts into the `discussions` namespace and navigation drawer.

**Non-Goals:**
- Rich-text composition (this will be handled in `lms-ask-doubt-form`).
- Tutor reply interface (mentors will use a separate dashboard or API).
- Complex pagination (initially using a simple List for the landing screen).

## Decisions
### 1. Data Layer
- **Decision**: Define `DoubtsTable` and `DoubtRepliesTable` in the `core` package.
- **Rationale**: Keeps the central database as the source of truth for all content, while the `discussions` package handles the domain logic.

### 2. UI Pattern
- **Decision**: Use a global search bar at the top of the list, rather than tabbed filters.
- **Rationale**: Matches the reference UI design and provides a simpler discovery flow for students with many doubts.

### 3. Navigation Structure
- **Decision**: Use a nested path `/home/discussions/doubts` as a sibling to `/home/discussions/forum`.
- **Rationale**: Consolidates all interactive features under the `discussions` namespace while keeping clear separation between public and private channels.

### 4. Simplified Data Contract
- **Decision**: Removed `getDoubtDetail` and pagination from the initial `DataSource` contract.
- **Rationale**: `DoubtDto` contains all metadata needed for both the list and the header of the detail view. Pagination is avoided to prevent over-engineering the initial landing screen.

## Risks / Trade-offs
- **[Risk]** Drift code generation overhead.
- **[Mitigation]** Batch all table changes and run `build_runner` once.
