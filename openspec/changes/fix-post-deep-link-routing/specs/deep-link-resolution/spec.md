## MODIFIED Requirements

### Requirement: Route Normalization Mapping
The system SHALL map legacy web endpoints and notification destination patterns to matching Cortex internal routes using a declarative list of pattern-to-target rules.

- **Posts & Announcements**:
  - `/posts/:slug` or `/p/:slug` SHALL map to `/home/posts/:slug`.
  - `/posts` or `/p` SHALL map to `/home/posts`.
- **Discussions / Forum**:
  - `/discussions/forum/posts/:slug` SHALL map to `/home/discussions/forum/posts/:slug`.
  - `/discussions/forum` or `/discussions` SHALL map to `/home/discussions/forum`.
  - `/discussions/doubts/:id` SHALL map to `/home/discussions/doubts/:id`.
  - `/discussions/doubts` SHALL map to `/home/discussions/doubts`.

#### Scenario: Deep linking to post / announcement
- **GIVEN** incoming URL `/p/important-exam-guidelines`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/home/posts/important-exam-guidelines`

#### Scenario: Deep linking to discussions forum post
- **GIVEN** incoming URL `/discussions/forum/posts/study-group-doubt`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/home/discussions/forum/posts/study-group-doubt`
