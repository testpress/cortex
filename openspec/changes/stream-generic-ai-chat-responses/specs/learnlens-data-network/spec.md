## ADDED Requirements

### Requirement: Streamed Turn Submission
The system SHALL support submitting chat turns over the LearnLens SSE routes `POST /chats/stream/` and `POST /chats/<chat_id>/messages/stream/` using the same `request_id` and `query` body as the JSON routes, the `X-Session-Token` header, and `Accept: text/event-stream`.

#### Scenario: Streaming a first message
- **WHEN** a first message is submitted with streaming enabled
- **THEN** the client SHALL POST to `/chats/stream/` and emit `accepted`, `delta`, `done`, and `error` events as they arrive.

#### Scenario: Streaming a follow-up message
- **WHEN** a follow-up is submitted for an existing conversation with streaming enabled
- **THEN** the client SHALL POST to `/chats/<chat_id>/messages/stream/` with the same event handling.

#### Scenario: Pre-stream JSON error
- **WHEN** the streaming route responds with a non-success status before streaming starts
- **THEN** the client SHALL read the JSON error body and surface a `LearnLensException` with the same code, message, limit, and retry timestamp normalization as the JSON routes.

#### Scenario: Unexpected JSON success body
- **WHEN** the streaming route responds with HTTP 200 and a JSON content type
- **THEN** the client SHALL parse the body as a turn response and emit it as a `done` event.

### Requirement: Incremental SSE Parsing
The system SHALL parse server-sent events incrementally from the byte stream.

#### Scenario: Fragmented and combined chunks
- **WHEN** a network chunk contains part of an event, several events, or part of a multi-byte UTF-8 character
- **THEN** the parser SHALL buffer bytes and emit each event exactly once with correctly decoded text.

#### Scenario: Keep-alive comments
- **WHEN** the stream contains lines beginning with `:`
- **THEN** the parser SHALL ignore them without emitting an event.

#### Scenario: Malformed event payload
- **WHEN** an event's `data` is not valid JSON
- **THEN** the stream SHALL surface a normalized `LearnLensException` instead of a raw decoding error.
