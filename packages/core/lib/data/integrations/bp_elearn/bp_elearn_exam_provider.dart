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
BpElearnExamApiService bpElearnExamApiService(BpElearnExamApiServiceRef _) {
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

  return BpElearnExamApiService(dio);
}

@riverpod
BpElearnExamRepository bpElearnExamRepository(BpElearnExamRepositoryRef ref) {
  return BpElearnExamRepository(ref.watch(bpElearnExamApiServiceProvider));
}

@riverpod
Future<BpElearnPaginatedResponseDto> bpElearnModelExamResults(
  BpElearnModelExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return BpElearnPaginatedResponseDto();
  }

  final repository = ref.watch(bpElearnExamRepositoryProvider);
  return repository.getModelExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}

@riverpod
Future<BpElearnPaginatedResponseDto> bpElearnWeeklyExamResults(
  BpElearnWeeklyExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return BpElearnPaginatedResponseDto();
  }

  final repository = ref.watch(bpElearnExamRepositoryProvider);
  return repository.getWeeklyExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}
