import 'dart:io';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/exam_result_response_dto.dart';

part 'exam_results_api_service.g.dart';

const _baseUrl = 'https://65.108.62.51';
const _endpoint = '/studentexamapi';
const _apiToken = '8ee49eb9f9e3477aa36d209657024cab';

class ExamResultApiService {
  final Dio _dio;

  ExamResultApiService(this._dio);

  Future<ExamResultResponseDto> fetchExamResults({
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

    return ExamResultResponseDto.fromJson(response.data);
  }
}

@riverpod
ExamResultApiService examResultApiService(Ref ref) {
  final coreDio = ref.watch(dioProvider);

  // Clone the core Dio instance to reuse its auth and logging interceptors,
  // but override the adapter to bypass SSL for this specific IP address.
  final dio = Dio(coreDio.options);
  dio.interceptors.addAll(coreDio.interceptors);

  if (!kIsWeb) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) =>
            host == '65.108.62.51';
        return client;
      },
    );
  }

  return ExamResultApiService(dio);
}
