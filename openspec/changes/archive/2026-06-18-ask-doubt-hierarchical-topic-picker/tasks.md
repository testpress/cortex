## 1. API and Data Source Updates

- [x] 1.1 Update `HttpDataSource.getDoubtTopics` to accept `{int? parentId}` and pass `{'parent_id': parentId}` in `queryParameters` to `_dio.get(ApiEndpoints.helpdeskTopics)`.
- [x] 1.2 Update `DataSource` interface `getDoubtTopics` signature to accept `{int? parentId}`.
- [x] 1.3 Update `MockDataSource` `getDoubtTopics` signature to accept `{int? parentId}`.
- [x] 1.4 In `DoubtRepository.syncTopics`, update `_dataSource.getDoubtTopics()` call to pass the `parentId`.

## 2. UI Component Extraction

- [x] 2.1 Extract the topic picker section from `AskDoubtFormScreen` into a new stateful widget `HierarchicalTopicPicker`.
- [x] 2.2 Have `HierarchicalTopicPicker` maintain `List<DoubtTopicDto> _topicPath` state and expose an `onTopicFinalized(int? topicId)` callback to notify the parent form.

## 3. Hierarchical Topic Picker Implementation

- [x] 3.1 Implement the Breadcrumb UI in `HierarchicalTopicPicker` based on `_topicPath` (e.g. `Topics > Math > Calculus`), allowing taps on breadcrumb segments to navigate back (by truncating `_topicPath`).
- [x] 3.2 Update the `Wrap` in `HierarchicalTopicPicker` to fetch `doubtSubtopicsProvider(_topicPath.lastOrNull?.id)` instead of `null`.
- [x] 3.3 Add the "I don't know" chip at the end of every level. Tapping it calls `onTopicFinalized(_topicPath.lastOrNull?.id)`.
- [x] 3.4 Handle tap on a regular topic chip: if `hasChildren` is true, push it to `_topicPath`; if false, call `onTopicFinalized(topic.id)`.

## 4. Integration

- [x] 4.1 In `AskDoubtFormScreen`, replace the old `Wrap` with `HierarchicalTopicPicker` and store the finalized `topicId` in `AskDoubtFormScreen` state (e.g. `_finalizedTopicId`).
- [x] 4.2 Provide clear UI feedback in `AskDoubtFormScreen` showing the finalized topic selection (perhaps reusing the Breadcrumbs UI but read-only, and allowing them to clear/edit the selection).
- [x] 4.3 Update `_submitDoubt` in `AskDoubtFormScreen` to use the `_finalizedTopicId`.

## 5. Attachment Removal

- [x] 5.1 In `AskDoubtFormScreen`, remove `_attachments` and `_fileAttachments` state variables.
- [x] 5.2 Remove `_pickAttachments` and `_pickFiles` methods.
- [x] 5.3 Remove the UI section for "Attachments (optional)" (the upload button and the preview strip).
- [x] 5.4 Update `_submitDoubt` to remove the logic that uploads attachments and appends them to the HTML.
