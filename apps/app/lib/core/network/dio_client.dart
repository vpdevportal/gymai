import 'package:dio/dio.dart';
import 'package:gymai/core/config/app_config.dart';
import 'package:gymai/core/network/auth_interceptor.dart';
import 'package:gymai/core/network/error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  DioClient({required AuthInterceptor authInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      authInterceptor,
      ErrorInterceptor(),
      if (AppConfig.isDevelopment)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
