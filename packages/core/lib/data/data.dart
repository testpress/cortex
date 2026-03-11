/// Unified Foundation for the Cortex App.
/// This barrel file re-exports all shared models, database infrastructure,
/// auth providers, and repositories.
library core.data;

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

// Database
export 'db/app_database.dart';
export 'db/database_provider.dart';

// Auth
export 'auth/auth_provider.dart';

// Sources
export 'sources/data_source.dart';
export 'sources/mock_data_source.dart';
export 'sources/http_data_source.dart';
export 'sources/data_source_provider.dart';

// Repositories
export 'repositories/user_repository.dart';
export 'repositories/forum_repository.dart';
export 'repositories/repository_providers.dart';

// Infra & Mocks
export 'infra/mock_data.dart';
