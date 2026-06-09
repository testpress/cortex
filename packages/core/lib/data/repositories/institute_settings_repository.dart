import '../config/institute_settings.dart';
import '../sources/institute_settings_remote_data_source.dart';
import '../sources/institute_settings_local_data_source.dart';

class InstituteSettingsRepository {
  final InstituteSettingsRemoteDataSource _remoteDataSource;
  final InstituteSettingsLocalDataSource _localDataSource;

  InstituteSettingsRepository({
    required InstituteSettingsRemoteDataSource remoteDataSource,
    required InstituteSettingsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  Future<InstituteSettings?> loadSettings() async {
    final settings = await _localDataSource.loadSettings();
    if (settings != null) {
      InstituteSettings.current = settings;
    }
    return settings;
  }

  Future<InstituteSettings> refreshSettings() async {
    final settings = await _remoteDataSource.fetchInstituteSettings();
    InstituteSettings.current = settings;
    await _localDataSource.saveSettings(settings);
    return settings;
  }
}
