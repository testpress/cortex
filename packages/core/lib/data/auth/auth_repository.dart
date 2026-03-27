import '../db/app_database.dart';
import 'auth_api_service.dart';
import 'auth_local_data_source.dart';

class AuthRepository {
  final AuthApiService _apiService;
  final AuthLocalDataSource _localDataSource;
  final Future<AppDatabase> _database;

  AuthRepository({
    required AuthApiService apiService,
    required AuthLocalDataSource localDataSource,
    required Future<AppDatabase> database,
  })  : _apiService = apiService,
        _localDataSource = localDataSource,
        _database = database;

  Future<bool> isUserLoggedIn() async {
    return _localDataSource.isUserLoggedIn();
  }

  Future<String?> getToken() async {
    return _localDataSource.getToken();
  }

  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    final session = await _apiService.loginWithPassword(
      username: username,
      password: password,
    );

    await _localDataSource.saveToken(session.authToken);
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    return _apiService.generateOtp(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      email: email,
    );
  }

  Future<void> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    final session = await _apiService.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );

    await _localDataSource.saveToken(session.authToken);
  }

  Future<void> logout() async {
    final token = await _localDataSource.getToken();
    try {
      await _apiService.logout(authToken: token);
    } catch (_) {
      // Still logout locally if API fails
    } finally {
      await clearToken();
      final db = await _database;
      await db.purgeAllData();
    }
  }

  Future<void> resetPassword({required String email}) {
    return _apiService.resetPassword(email: email);
  }

  Future<void> clearToken() async {
    await _localDataSource.clearToken();
  }
}
