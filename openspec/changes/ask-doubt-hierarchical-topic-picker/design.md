## Context

The current Ask Doubt feature fetches only root-level topics via the `doubtSubtopicsProvider(null)` and presents them as a flat `Wrap` of chips. However, the backend categorizes doubts in a 3-level tree structure (`Topic` > `Subtopic` > `Subject`). Students need to select the most specific topic available or explicitly indicate "I don't know" at any intermediate level.

## Goals / Non-Goals

**Goals:**
- Enable dynamic fetching of child topics by passing `parent_id` to the API.
- Re-architect the topic selection UI to show an inline drill-down component replacing the current static chip wrap.
- Provide breadcrumb navigation allowing users to jump back up the hierarchy.
- Ensure the "I don't know" chip captures the nearest known parent topic.

**Non-Goals:**
- Completely rewriting the overall `AskDoubtFormScreen` or how the doubt text content is managed.
- Modifying offline sync logic beyond the existing `DoubtRepository` cache logic.

## Decisions

1. **State Management for Topic Picker**
   - **Decision**: Extract the hierarchical picker into its own stateful widget (`HierarchicalTopicPicker`) to encapsulate the state (`List<DoubtTopicDto> _topicPath`). 
   - **Rationale**: Keeps navigation in place without complicated routing or polluting the main form state. Breadcrumbs can easily be built by mapping over `_topicPath`. The provider `doubtSubtopicsProvider(_topicPath.lastOrNull?.id)` drives the current options.

2. **Backend API Parameter Updates**
   - **Decision**: Add an optional `parentId` parameter to `HttpDataSource.getDoubtTopics({int? parentId})`.
   - **Rationale**: `DoubtRepository.syncTopics({int? parentId})` already has this parameter but was ignoring it. Passing it through to `ApiEndpoints.helpdeskTopics` as a query parameter `?parent_id=<id>` ensures we fetch child topics on demand.

3. **"I don't know" Logic**
   - **Decision**: When "I don't know" is selected, the `topicId` sent via `onTopicFinalized(int? topicId)` defaults to the ID of the last item in `_topicPath` (or null if the path is empty).

## Risks / Trade-offs

- **[Risk] State Complexity**: The local state of `AskDoubtFormScreen` grows.
  - *Mitigation*: Solved by Decision #1 (extracting to `HierarchicalTopicPicker`).
