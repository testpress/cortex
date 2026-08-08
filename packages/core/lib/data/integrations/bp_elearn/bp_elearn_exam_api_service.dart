import 'package:dio/dio.dart';
import 'models/bp_elearn_paginated_response_dto.dart';

const _baseUrl = 'https://65.108.62.51';
const _endpoint = '/studentexamapi';
const _apiToken = '8ee49eb9f9e3477aa36d209657024cab';

class BPElearnExamApiService {
  final Dio _dio;

  BPElearnExamApiService(this._dio);

  Future<BPElearnPaginatedResponseDto> fetchExamResults({
    required String studentNo,
    required int pageNo,
    required int limit,
    required String examType,
  }) async {
    final response = await _dio.post(
      '$_baseUrl$_endpoint',
      data: {
        'token': _apiToken,
        'studentno': studentNo,
        'pageno': pageNo,
        'limit': limit,
        'examtype': examType,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return BPElearnPaginatedResponseDto.fromJson(response.data);
  }
}
