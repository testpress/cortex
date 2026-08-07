import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/exam_result_response_dto.dart';

part 'exam_results_api_service.g.dart';

const _baseUrl = 'https://65.108.62.51';
const _endpoint = '/studentexamapi';
const _apiToken = '8ee49eb9f9e3477aa36d209657024cab';

class ExamResultApiService {
  final Dio dio;

  ExamResultApiService(this.dio);

  Future<ExamResultResponseDto> fetchExamResults({
    required String studentNo,
    required int pageNo,
    required int limit,
    required String examType,
  }) async {
    final response = await dio.post(
      _endpoint,
      data: {
        'token': _apiToken,
        'studentno': studentNo,
        'pageno': pageNo,
        'limit': limit,
        'examtype': examType,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return ExamResultResponseDto.fromJson(response.data);
  }
}

@riverpod
Dio examResultDio(ExamResultDioRef ref) {
  final dio = Dio(BaseOptions(baseUrl: _baseUrl));

  if (!kIsWeb) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  return dio;
}

@riverpod
ExamResultApiService examResultApiService(ExamResultApiServiceRef ref) {
  final dio = ref.watch(examResultDioProvider);
  return ExamResultApiService(dio);
}
