## Context

`genericAiChatProvider` already drives `AiScreen` through `LearnLensRepository` using the JSON turn routes, with status polling for `processing` turns and idempotent retry using a preserved `request_id`. LearnLens also offers SSE routes (`/chats/stream/`, `/chats/<chat_id>/messages/stream/`) that emit `accepted`, `delta`, `done`, and `error` events. This change adds streaming on top of the existing architecture without rebuilding the chat.

## Goals / Non-Goals

**Goals:**
- Stream assistant answers progressively on Android and iOS.
- Parse SSE incrementally: fragmented chunks, split UTF-8 sequences, keep-alive comments, CRLF line endings.
- Keep the UI from getting stuck on failures, disconnects, timeouts, or malformed events, without showing raw exceptions.
- Preserve existing idempotency, deduplication, history, and session handling.
- Keep Web behavior completely unchanged (JSON route).

**Non-Goals:**
- Stop/cancel generation UX (no stop endpoint exists).
- Changes to the video lesson AI tab or immersive screen.
- Resuming missed deltas (no event IDs or `Last-Event-ID` support).

## Decisions

### Decision 1: Pure Dart SSE parser as a `StreamTransformer`
`SseParser` converts `Stream<List<int>>` into `Stream<SseEvent>`. It decodes UTF-8 incrementally with `Utf8Decoder(allowMalformed: true)`, buffers text across chunks, splits on `\r\n`, `\n`, or `\r`, ignores comment lines starting with `:`, concatenates multiple `data:` lines with `\n`, and dispatches on a blank line. JSON is decoded only after a complete event has been assembled.
- *Rationale*: Dio's `ResponseType.stream` exposes raw bytes. A tiny transformer keeps the parser unit-testable and independent of Dio.

### Decision 2: Streaming lives in the existing client and repository
`LearnLensNetworkClient.streamConversation` and `streamFollowUpMessage` POST the same `{request_id, query}` body with `Accept: text/event-stream` and `responseType: ResponseType.stream`. The existing `LearnLensSessionInterceptor` still injects `X-Session-Token` and performs the single 401 refresh/retry. Before selecting the SSE parser the client checks the content type; a JSON body is parsed as a turn and surfaced as a synthetic `done` event. Pre-stream error statuses (401, 403, 409, 422, 429) have their `ResponseBody` read and normalized through the existing `parseDioException` so the quota and retry handling is unchanged.

### Decision 3: Provisional assistant message replaced by `done.answer`
On `accepted`, the notifier records `chat_id`, title, and `user_message_id`, and inserts a provisional assistant message (`isStreaming: true`). `delta` events append text. `done` replaces the provisional message in place: `completed` writes `done.answer` with the persisted assistant message ID, `failed` removes the provisional text and shows the existing failure card, and `processing` (replay) hands off to the existing status polling. Nothing is appended, so the answer never appears twice.

### Decision 4: Uncertain outcomes recover through status and history
An `error` event, a stream that ends without `done`, a receive timeout, or a connection drop leaves the outcome unknown. If `chat_id` is known the notifier reads conversation status; `completed` reconciles from message history (deduplicated by `message_id`), `failed` shows the failure card, `processing`/`unresolved` starts polling. If `chat_id` is unknown, or the status read fails, the user message is marked as a send error while keeping its original `request_id`, so the existing retry replays the same submission. Recovery never creates a new request ID or automatically resubmits.

### Decision 5: Submission target is pinned per request ID
The notifier remembers the route used for each `request_id` (first message or a specific `chat_id`). A retry of an uncertain first message keeps using `POST /chats/stream/` even after the `chat_id` is learned, as the API guide requires.

### Decision 6: Operation token guards and Web gating
The existing `_operationToken` invalidates stale streams when the user switches or starts a new conversation; late events are ignored and cannot touch the new conversation. Streaming is selected with `!kIsWeb`; Web continues to use the JSON routes with no behavior change.

## Risks / Trade-offs

- [Risk] Dio's `receiveTimeout` applies between chunks for stream responses, so a stalled stream without keep-alives surfaces as a receive timeout.
  -> *Mitigation*: Treated as an uncertain outcome and recovered via status/history.
- [Risk] Switching conversations mid-stream leaves the HTTP stream draining in the background.
  -> *Mitigation*: Events are ignored via the operation token; the subscription is cancelled on notifier disposal.
- [Risk] A `done` event with status `processing` (replay) has no text.
  -> *Mitigation*: Reuses existing status polling and message reconciliation.

### Review follow-up
The generating caption owns the accessible status; the dots are decorative. The pulse uses the very-slow motion token and stops when reduced motion is enabled. Submission targets remain pinned only while replay may be necessary; terminal completion/failure and conversation reset already remove them. Keep platform streaming selection unchanged: a build flag is outside the current requirements.
