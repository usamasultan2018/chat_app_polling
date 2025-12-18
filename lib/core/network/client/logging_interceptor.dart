import 'package:dio/dio.dart';
import 'dart:developer' as dev;

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log(
      '🌐 REQUEST[${options.method}] => ${options.path}',
      name: 'DioLogger',
    );
    dev.log('📤 Data: ${options.data}', name: 'DioLogger');
    dev.log('📋 Headers: ${options.headers}', name: 'DioLogger');
    dev.log('🔗 Query: ${options.queryParameters}', name: 'DioLogger');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
      name: 'DioLogger',
    );
    dev.log('📥 Data: ${response.data}', name: 'DioLogger');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log(
      '❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}',
      name: 'DioLogger',
    );
    dev.log('📛 Message: ${err.message}', name: 'DioLogger');
    dev.log('📛 Response: ${err.response?.data}', name: 'DioLogger');
    dev.log('📛 Type: ${err.type}', name: 'DioLogger');
    super.onError(err, handler);
  }
}
