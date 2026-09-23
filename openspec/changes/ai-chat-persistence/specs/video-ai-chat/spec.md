## ADDED Requirements

### Requirement: Asset-Based AI Chat History Retrieval
The system SHALL retrieve existing chat sessions for the asset upon opening the AI Support tab and load the message history for the most recent chat session.

#### Scenario: Existing chat history restored
- **WHEN** the user opens the AI Support tab for an asset that has previous chat sessions
- **THEN** the system fetches the chat list via `/v2/{org_uuid}/assets/{asset_id}/chats/`, retrieves messages for the latest chat via `/v2/{org_uuid}/chats/{chat_id}/messages/`, and renders the full conversation history.

#### Scenario: No previous chat found
- **WHEN** the user opens the AI Support tab for an asset with no prior chats
- **THEN** the system displays the default introductory AI tutor greeting and prepares to initialize a new chat session on the first message.

#### Scenario: History retrieval error
- **WHEN** loading chat history fails due to network or server issues
- **THEN** the system displays a user-friendly error state with a retry option without crashing the video lesson screen.

#### Scenario: Automatic 401 session token refresh and retry
- **WHEN** a chat history or message request encounters an HTTP 401 unauthorized status
- **THEN** the system automatically requests a fresh session token from the authentication provider, updates the request header, and retries the request without failing the user UI.

### Requirement: Persistent Chat Continuation
The system SHALL retain the active chat identifier (`chat_id`) and include it in subsequent query submissions to append messages to the existing thread.

#### Scenario: Appending new queries to existing chat
- **WHEN** the user sends a message in an active or restored chat session
- **THEN** the system submits the query with the active `chat_id`, appends the new user and assistant messages to the conversation list, and preserves the same `chat_id` for future turns.

## MODIFIED Requirements

### Requirement: Submitting AI Chat Queries
The system SHALL allow users to submit queries, associate turns with an active `chat_id`, and display markdown-formatted responses.

#### Scenario: Valid Chat Query with persistent thread
- **WHEN** the user submits a question in the AI Chat tab
- **THEN** the system calls the LearnLens Chat API passing the cached session token, learner ID, asset ID, and active `chat_id` (if present), receives the response with updated `chat_id`, and displays the markdown response.
