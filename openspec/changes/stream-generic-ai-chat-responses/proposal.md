## Why

The Generic AI Chat screen currently waits for the full JSON turn response before showing any assistant text. LearnLens exposes server-sent event (SSE) streaming routes that deliver the answer in pieces. Streaming the answer progressively makes the chat feel responsive and gives students feedback while long generations (up to 150 s) are running.

## What Changes

- **SSE transport in `packages/core`**: Add an incremental SSE parser and two streaming calls on `LearnLensNetworkClient` and `LearnLensRepository` for `POST /chats/stream/` (first message) and `POST /chats/<chat_id>/messages/stream/` (follow-up), authenticated with the existing `X-Session-Token` interceptor.
- **Progressive rendering in `genericAiChatProvider`**: Show the user's message immediately, insert a provisional assistant message on `accepted`, append `delta` text in arrival order, and replace the provisional text with the authoritative `done.answer`.
- **Failure and recovery handling**: Map pre-stream JSON errors to the existing send-error path; treat `error` events, disconnects, and timeouts as uncertain outcomes recovered via conversation status and message history; preserve the original request ID and target route for idempotent replay.
- **Generating indicator**: Reuse `AiAssistantCard` to render a typing indicator while the assistant message has no text yet.
- **Platform scope**: Streaming is enabled on Android/iOS only. Web keeps the existing JSON request path unchanged.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `learnlens-data-network`: Adds SSE streaming routes and incremental event parsing.
- `generic-ai-chat-controller`: Adds progressive streamed turn lifecycle and uncertain-outcome recovery.
- `generic-ai-chat-screen`: Adds the assistant generating indicator for provisional streamed messages.

## Impact

- `packages/core/lib/network/sse_parser.dart`: New incremental SSE parser.
- `packages/core/lib/network/learnlens_network_client.dart`: New streaming requests.
- `packages/core/lib/data/repositories/learnlens_repository.dart`: New streaming repository methods.
- `packages/core/lib/data/models/learnlens_dto.dart`: New `AiChatStreamEvent` model.
- `packages/core/lib/data/providers/generic_ai_chat_provider.dart`: Streamed turn lifecycle, recovery, and submission target tracking.
- `packages/core/lib/widgets/ai_assistant_card.dart`, `packages/core/lib/screens/ai_screen.dart`: Generating indicator for provisional assistant messages.
- `packages/core/lib/l10n/*.arb`: New `aiGeneratingResponse` string.
- `packages/core/test/`: SSE parser, network client, DTO, provider, and screen tests.
