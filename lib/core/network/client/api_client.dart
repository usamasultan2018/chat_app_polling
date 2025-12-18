import 'dart:io';

import 'package:daily_sales_app/core/network/api/endpoints.dart';
import 'package:daily_sales_app/core/network/client/auth_interceptor.dart';
import 'package:daily_sales_app/core/network/client/logging_interceptor.dart';
import 'package:daily_sales_app/core/network/erorr/api_exceptions.dart';
import 'package:daily_sales_app/core/network/erorr/erorr_handler.dart';

import 'package:daily_sales_app/core/network/utils/request_type.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
   dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ),
    );


    dio.interceptors.addAll([LoggerInterceptor(), AuthInterceptor()]);
  }

  Future<Response> request(
    String path, {
    RequestType requestType = RequestType.get,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final isMultipart = data is FormData;

      final options = Options(
        contentType: isMultipart
            ? Headers.multipartFormDataContentType
            : Headers.jsonContentType,
      );

      switch (requestType) {
        case RequestType.get:
          return await dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
          );

        case RequestType.post:
          return await dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );

        case RequestType.put:
          return await dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );

        case RequestType.delete:
          return await dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );

        case RequestType.patch:
          return await dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
      }
    } on DioException catch (dioError) {
      // Use a proper logger instead of print in production
      print('🔴 Dio Error');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');
      print('Message: ${dioError.message}');

      throw ErrorHandler.handleDioError(dioError);
    } catch (e) {
      throw ApiException('Unexpected error occurred: $e');
    }
  }
}
