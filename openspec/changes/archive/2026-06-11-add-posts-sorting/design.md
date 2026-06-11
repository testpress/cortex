## Context
Currently, the `/api/v3/posts/` endpoint does not specify an ordering parameter when fetching posts, relying on the backend's default ordering (which is database ID). This results in older posts being displayed first on the frontend. We want to update the API request to include `ordering=-published_date` to ensure newest posts are displayed first.

## Goals / Non-Goals
**Goals:**
- Update the API request in `http_data_source.dart` to sort posts by `published_date` in descending order.

**Non-Goals:**
- Allowing the user to dynamically change the sort order from the UI.
- Implementing local sorting mechanisms in the database cache. (The backend will handle sorting, and the database will just store the sorted items).

## Decisions
- **Decision 1**: Add an `ordering` query parameter directly to the `getPosts` function in `http_data_source.dart`.
  - **Rationale**: This is the simplest and most effective way to ensure the API always returns the newest posts first without overcomplicating the frontend state or repository layer.

## Risks / Trade-offs
- **Risk**: Backend doesn't support the `-published_date` ordering parameter for the posts endpoint.
  - **Mitigation**: Verify the backend API documentation or behavior to ensure it supports this specific ordering parameter. However, based on the web application behavior, this is expected to be supported.
