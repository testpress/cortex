import 'package:dio/dio.dart';
import '../../network/network_utils.dart';
import '../config/institute_settings.dart';

class InstituteSettingsRemoteDataSource {
  final Dio _dio;

  InstituteSettingsRemoteDataSource({required Dio dio}) : _dio = dio;

  Future<InstituteSettings> fetchInstituteSettings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/v2.3/settings/');
      if (response.data != null) {
        return InstituteSettings.fromJson(response.data!);
      } else {
        throw Exception('Empty response from /api/v2.3/settings/');
      }
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
