## ADDED Requirements

### Requirement: Fetch posts ordered by published date
The system SHALL request posts from the backend API ordered by published date in descending order.

#### Scenario: Requesting posts from the API
- **WHEN** the `http_data_source` fetches posts using `getPosts`
- **THEN** it must include the query parameter `ordering=-published_date` in the API request
