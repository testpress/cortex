## 1. Domain & Data Layer

- [x] 1.1 Implement `doubtThreadProvider` in `packages/discussions/lib/providers/doubt_providers.dart`
- [x] 1.2 Implement `postDoubtReply` mock method in `DoubtRepository`

## 2. UI Foundation

- [x] 2.1 Create `DoubtDetailScreen` scaffold in `packages/discussions/lib/screens/doubt_detail_screen.dart`
- [x] 2.2 Integrate `Skeletonizer` for high-fidelity loading states
- [x] 2.3 Implement `_DoubtHeader` with rich-text support for the primary question
- [x] 2.4 Implement `_ReplyList` and `_ReplyItem` with "Mentor" badge styling

## 3. Rich-Text & Media

- [x] 3.1 Configure `quill.QuillEditor` for read-only rendering of Delta JSON content
- [x] 3.2 Implement `_AttachmentStrip` for viewing thread attachments
- [x] 3.3 Add logic to open PDF attachments using existing `AppPdfViewer` navigation

## 4. Interaction & Navigation

- [x] 4.1 Implement persistent `ForumComposer` at the bottom of the detail screen
- [x] 4.2 Update `DoubtsListScreen` to navigate to `DoubtDetailScreen` on card tap
- [x] 4.3 Implement no-op reply submission flow with loading feedback
