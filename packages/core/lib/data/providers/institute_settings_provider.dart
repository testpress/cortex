import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/dio_provider.dart';
import '../config/institute_settings.dart';
import '../sources/institute_settings_remote_data_source.dart';
import '../sources/institute_settings_local_data_source.dart';
import '../repositories/institute_settings_repository.dart';

final instituteSettingsRemoteDataSourceProvider = Provider<InstituteSettingsRemoteDataSource>((ref) {
  return InstituteSettingsRemoteDataSource(dio: ref.watch(dioProvider));
});

final instituteSettingsLocalDataSourceProvider = Provider<InstituteSettingsLocalDataSource>((ref) {
  return InstituteSettingsLocalDataSource();
});

final instituteSettingsRepositoryProvider = Provider<InstituteSettingsRepository>((ref) {
  return InstituteSettingsRepository(
    remoteDataSource: ref.watch(instituteSettingsRemoteDataSourceProvider),
    localDataSource: ref.watch(instituteSettingsLocalDataSourceProvider),
  );
});

final instituteSettingsProvider = StateProvider<InstituteSettings?>((ref) {
  return InstituteSettings.current;
});
