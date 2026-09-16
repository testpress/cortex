## MODIFIED Requirements

### Requirement: Server-Side Payment Verification
The system MUST verify payment success directly with the backend server using the third-party gateway order identifier before granting access to purchased items.

#### Scenario: SDK returns success
- **WHEN** the third-party payment SDK (Razorpay or PayU) returns a success callback
- **THEN** the system calls the backend `/api/v2.5/orders/{order_id}/refresh/` endpoint using the gateway string order ID (`orderId` or fallback stringified `id`)

#### Scenario: Verification succeeds
- **WHEN** the refresh endpoint returns `{"status": "Completed"}`
- **THEN** the system displays the success confirmation UI

#### Scenario: Verification fails or pends
- **WHEN** the refresh endpoint returns any other status (e.g., `Processing` or `Bad Request`)
- **THEN** the system displays a pending or failed UI and does not grant access
