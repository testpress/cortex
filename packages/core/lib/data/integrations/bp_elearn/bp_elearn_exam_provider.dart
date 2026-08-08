import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/user_provider.dart';

import 'bp_elearn_exam_api_service.dart';
import 'bp_elearn_exam_repository.dart';
import 'models/bp_elearn_paginated_response_dto.dart';

part 'bp_elearn_exam_provider.g.dart';

@riverpod
BPElearnExamApiService bPElearnExamApiService(BPElearnExamApiServiceRef _) {
  final dio = Dio();

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

  return BPElearnExamApiService(dio);
}

@riverpod
BPElearnExamRepository bPElearnExamRepository(BPElearnExamRepositoryRef ref) {
  return BPElearnExamRepository(ref.watch(bPElearnExamApiServiceProvider));
}

@riverpod
Future<BPElearnPaginatedResponseDto> bPElearnModelExamResults(
  BPElearnModelExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return BPElearnPaginatedResponseDto();
  }

  final repository = ref.watch(bPElearnExamRepositoryProvider);
  return repository.getModelExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}

@riverpod
Future<BPElearnPaginatedResponseDto> bPElearnWeeklyExamResults(
  BPElearnWeeklyExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return BPElearnPaginatedResponseDto();
  }

  final repository = ref.watch(bPElearnExamRepositoryProvider);
  return repository.getWeeklyExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}
