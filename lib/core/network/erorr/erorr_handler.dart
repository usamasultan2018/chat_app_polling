import 'dart:io';
import 'package:daily_sales_app/core/network/erorr/api_exceptions.dart';
import 'package:dio/dio.dart';


class ErrorHandler {
  static ApiException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiException('Request to API was cancelled');

      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timeout with API server');

      case DioExceptionType.receiveTimeout:
        return ApiException('Receive timeout in connection with API server');

      case DioExceptionType.sendTimeout:
        return ApiException('Send timeout in connection with API server');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String message = 'Received invalid status code: $statusCode';

        if (error.response?.data != null) {
          if (error.response!.data is Map<String, dynamic>) {
            final data = error.response!.data as Map<String, dynamic>;
            if (data.containsKey('message') &&
                data['message'] is String) {
              message = data['message'] as String;
            }
          }
        }
        return ApiException(message, code: statusCode);

      case DioExceptionType.unknown:
      default:
        // ✅ Detect no internet or socket error
        if (error.error is SocketException) {
          return ApiException(
            'No Internet Connection. Please check your network.',
          );
        }

        return ApiException('Unexpected error occurred: ${error.message}');
    }
  }
}
