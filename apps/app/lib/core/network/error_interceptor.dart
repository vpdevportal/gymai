import 'package:dio/dio.dart';
import 'package:gymai/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException(message: 'Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message =
            (err.response?.data as Map<String, dynamic>?)?['message'] as String?
                ?? err.message
                ?? 'Server error';
        if (statusCode == 401) {
          throw AuthException(message: message);
        }
        throw ServerException(message: message, statusCode: statusCode);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        throw ServerException(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }
}
