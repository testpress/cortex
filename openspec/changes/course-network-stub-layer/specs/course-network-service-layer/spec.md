## ADDED Requirements

### Requirement: Course API service scaffold
The courses package MUST provide a dedicated course network service class that exposes read-only method signatures for course list/detail retrieval.

#### Scenario: Service class exists with read methods
- **WHEN** developers inspect the courses network layer
- **THEN** they find a `CourseApiService` with methods for fetching courses, course detail, chapters, and lessons

### Requirement: Service provider availability
The courses package MUST expose a Riverpod provider that constructs `CourseApiService` using the shared core `dioProvider`.

#### Scenario: Provider is consumed in composition layer
- **WHEN** a repository/provider needs the service dependency
- **THEN** it can read a `courseApiServiceProvider` without creating `Dio` directly

### Requirement: Stub behavior safety
Until real endpoint integration is completed, scaffolded methods MUST fail fast with clear not-implemented messaging.

#### Scenario: Stub method is called before integration
- **WHEN** any `CourseApiService` read method is invoked in the stub phase
- **THEN** it throws an `UnimplementedError` that identifies the method to implement

## MODIFIED Requirements

### Requirement: Course data abstraction boundaries
The curriculum list domain SHALL allow API integration through feature-scoped service classes while preserving existing data flow during incremental migration.

#### Scenario: Parallel API preparation without runtime migration
- **WHEN** the service scaffold is introduced ahead of repository migration
- **THEN** current `DataSource`-based runtime behavior remains unchanged and functional
