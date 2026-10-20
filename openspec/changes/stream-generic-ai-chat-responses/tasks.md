## 1. SSE Transport

- [x] 1.1 Add `SseParser` and `SseEvent` in `packages/core/lib/network/sse_parser.dart` with incremental UTF-8 decoding, keep-alive comment handling, and multi-line data support.
- [x] 1.2 Add `AiChatStreamEvent` to `learnlens_dto.dart` mapping `accepted`, `delta`, `done`, and `error` payloads.
- [x] 1.3 Add `streamConversation` and `streamFollowUpMessage` to `LearnLensNetworkClient` using `Accept: text/event-stream` and `ResponseType.stream`, with content-type checks and JSON error normalization.
- [x] 1.4 Expose the streaming calls through `LearnLensRepository` with local query validation.

## 2. Progressive Rendering in the Controller

- [x] 2.1 Add `isStreaming` to `GenericAiChatMessage` and insert a provisional assistant message on `accepted`.
- [x] 2.2 Append `delta` text in arrival order and replace with `done.answer` without duplication.
- [x] 2.3 Handle `done` with `failed` and `processing` statuses using the existing failure card and status polling.
- [x] 2.4 Gate streaming behind `!kIsWeb` so Web keeps the JSON path.

## 3. Failure Handling and Recovery

- [x] 3.1 Map pre-stream JSON errors (401, 409, 422, 429, timeouts) through the existing send-error path.
- [x] 3.2 Treat `error` events, disconnects, and malformed events as uncertain outcomes and recover via conversation status and message history.
- [x] 3.3 Pin the submission route per `request_id` so retries never switch from the first-message route to the follow-up route.
- [x] 3.4 Ignore late stream events after the user switches or starts a new conversation; cancel subscriptions on disposal.

## 4. UI

- [x] 4.1 Add a generating indicator to `AiAssistantCard` for provisional streamed messages.
- [x] 4.2 Pass `isStreaming` from `AiScreen` and add the `aiGeneratingResponse` localization string.

## 5. Tests

- [x] 5.1 SSE parser tests: fragmented chunks, split UTF-8 characters, keep-alive comments, CRLF, multi-line data.
- [x] 5.2 Network client tests: streaming request contract, event parsing, pre-stream error normalization.
- [x] 5.3 Provider tests: progressive rendering, completion, generation failure, error event recovery, disconnect recovery, retry route pinning, conversation switching, duplicate submission guard.
- [x] 5.4 Screen test: generating indicator and progressive text rendering.

## 6. Review follow-up

- [x] 6.1 Use design tokens for the typing indicator and respond to runtime motion changes.
- [x] 6.2 Expose a single generating status and name the auto-scroll proximity threshold.
- [ ] 6.3 Verify indicator accessibility and runtime motion behavior; run chat regression tests.

Review validation: 24 card/screen tests passed. Provider run passed 38 tests; the existing Web JSON-path test timed out after 30 seconds. Full validation and archive remain pending that investigation.
