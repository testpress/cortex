// Unified Foundation for the Cortex App.
// This barrel file re-exports all shared models, database infrastructure,
// auth providers, and repositories.

// Config
export 'config/app_config.dart';

// DTOs
export 'models/course_dto.dart';
export 'models/chapter_dto.dart';
export 'models/lesson_dto.dart';
export 'models/live_class_dto.dart';
export 'models/forum_thread_dto.dart';
export 'models/user_progress_dto.dart';
export 'models/user_dto.dart';
export 'models/settings_models.dart';
export 'models/study_momentum_dto.dart';
export 'models/explore_models.dart';

// Database
export 'db/app_database.dart';
export 'db/database_provider.dart';

// Auth
export 'auth/auth_exception.dart';
export 'auth/auth_provider.dart';
export 'auth/auth_service.dart';
export 'auth/models/auth_token_response.dart';
export 'auth/session/session_manager.dart';

// Sources
export 'sources/data_source.dart';
export 'sources/mock_data_source.dart';
export 'sources/http_data_source.dart';
export 'sources/data_source_provider.dart';
export 'sources/study_momentum_provider.dart';

// Repositories
export 'repositories/user_repository.dart';
export 'repositories/forum_repository.dart';
export 'repositories/repository_providers.dart';

// Infra & Mocks
export 'sources/mock_data.dart';
export 'auth/session/session_storage.dart';
export 'auth/auth_client.dart';
export 'network/interceptors/auth_interceptor.dart';
export 'network/interceptors/logging_interceptor.dart';
export 'network/dio_provider.dart';
export 'network/api_endpoints.dart';
