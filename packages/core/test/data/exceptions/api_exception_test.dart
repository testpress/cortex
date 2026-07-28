import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/exceptions/api_exception.dart';
import 'package:dio/dio.dart';

void main() {
  group('ApiException', () {
    test('extractApiMessage extracts string from flat structure', () {
      final message = ApiException.extractApiMessage('Error occurred');
      expect(message, 'Error occurred');
    });

    test('extractApiMessage extracts from map', () {
      final message = ApiException.extractApiMessage({
        'message': 'Invalid token',
      });
      expect(message, 'Invalid token');
    });

    test('extractApiMessage extracts from nested detail map', () {
      final message = ApiException.extractApiMessage({
        'detail': {'message': 'Not found'},
      });
      expect(message, 'Not found');
    });

    test('extractApiMessage extracts from list of strings', () {
      final message = ApiException.extractApiMessage(['Error 1', 'Error 2']);
      expect(message, 'Error 1\nError 2');
    });

    test('fromDioException maps connectionError to noInternet', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );
      final apiException = ApiException.fromDioException(dioException);
      expect(apiException.type, ApiErrorType.noInternet);
    });

    test('fromDioException maps 401 response to unauthorized', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {'message': 'Token expired'},
        ),
      );
      final apiException = ApiException.fromDioException(dioException);
      expect(apiException.type, ApiErrorType.unauthorized);
      expect(apiException.message, 'Token expired');
    });
  });
}
