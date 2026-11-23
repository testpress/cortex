## ADDED Requirements

### Requirement: Attachment State Tracking and Submission
The controller SHALL maintain staged attachment state, upload progress, and pass attachment IDs when dispatching conversation turns.

#### Scenario: Dispatching turn with attachment IDs
- **WHEN** sending turn in a new or existing conversation with staged attachments
- **THEN** controller SHALL include the uploaded `attachment_ids` in `startConversation` or `sendFollowUpMessage` payload.
