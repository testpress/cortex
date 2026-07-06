import 'auth_api_service.dart';
import 'auth_local_data_source.dart';
import '../exceptions/api_exception.dart';
import '../sources/data_source.dart';
import 'types/auth_exception.dart';

class AuthRepository {
  final AuthApiService _apiService;
  final AuthLocalDataSource _localDataSource;
  final DataSource _dataSource;

  AuthRepository({
    required AuthApiService apiService,
    required AuthLocalDataSource localDataSource,
    required DataSource dataSource,
  }) : _apiService = apiService,
       _localDataSource = localDataSource,
       _dataSource = dataSource;

  Future<bool> isUserLoggedIn() async {
    return _localDataSource.isUserLoggedIn();
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
    await verifyLogin();
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
    await verifyLogin();
  }

  Future<void> logout() async {
    final token = await _localDataSource.getToken();
    try {
      await _apiService.logout(authToken: token);
    } catch (_) {
      // Still logout locally if API fails
    } finally {
      await _clearToken();
    }
  }

  Future<void> logoutOtherDevices() async {
    final token = await _localDataSource.getToken();
    if (token == null) return;
    await _apiService.logoutOtherDevices(authToken: token);
  }

  Future<void> resetPassword({required String email}) {
    return _apiService.resetPassword(email: email);
  }

  Future<void> _clearToken() async {
    await _localDataSource.clearToken();
  }

  /// Verifies the token against the /me/ endpoint to confirm there is no
  /// parallel login restriction active. If 403 with parallel_login_restriction
  /// is returned, a [ParallelLoginException] is thrown (the token is kept in
  /// storage so that LoginActivityScreen can use it).
  /// Any other error (network, server) is swallowed — the login proceeds normally.
  Future<void> verifyLogin() async {
    try {
      await _dataSource.getProfile();
    } on ApiException catch (e) {
      if (e.statusCode == 403 && _isParallelLoginRestriction(e.data)) {
        // Do NOT clear the token — it is valid and must remain in storage
        // so that LoginActivityScreen can use it to fetch and delete sessions.
        throw const ParallelLoginException();
      }
      // Any other error (network, etc.) — token is fine, allow login
    }
  }

  /// Checks whether the API error data indicates a parallel login restriction.
  /// Handles both [Map] and [String] response bodies — the server returns
  /// content-type: text/html for this error despite the body being JSON,
  /// causing Dio to store the response as a String rather than a parsed Map.
  static bool _isParallelLoginRestriction(dynamic data) {
    if (data is Map) {
      return data['error_code'] == 'parallel_login_restriction';
    }
    if (data is String) {
      return data.contains('parallel_login_restriction');
    }
    return false;
  }
}
