# payment-gateways Specification

## Purpose
TBD - created by archiving change add-payment-gateways. Update Purpose after archive.
## Requirements
### Requirement: Dynamic Gateway Selection
The system MUST dynamically select which payment gateway SDK to initialize based on the institute settings configuration.

#### Scenario: Razorpay is configured
- **WHEN** the `currentPaymentApp` setting is `"razorpay"`
- **THEN** the system initializes the Razorpay SDK flow

#### Scenario: PayU is configured as fallback
- **WHEN** the `currentPaymentApp` setting is empty, null, or unknown
- **THEN** the system initializes the PayU SDK flow

### Requirement: PayU Secure Hash Delegation
The system MUST NEVER store secret salts on the client for PayU integrations.

#### Scenario: Generating hash for PayU checkout
- **WHEN** the system prepares to launch the PayU SDK
- **THEN** it formats the transaction data and calls the backend `/api/v2.5/payu/dynamic_hash/` to retrieve the secure hash

### Requirement: Server-Side Payment Verification
The system MUST verify payment success directly with the backend server before granting access to purchased items.

#### Scenario: SDK returns success
- **WHEN** the third-party payment SDK (Razorpay or PayU) returns a success callback
- **THEN** the system calls the backend `/api/v2.5/orders/{order_id}/refresh/` endpoint

#### Scenario: Verification succeeds
- **WHEN** the refresh endpoint returns `{"status": "Completed"}`
- **THEN** the system displays the success confirmation UI

#### Scenario: Verification fails or pends
- **WHEN** the refresh endpoint returns any other status (e.g., `Processing` or `Bad Request`)
- **THEN** the system displays a pending or failed UI and does not grant access

