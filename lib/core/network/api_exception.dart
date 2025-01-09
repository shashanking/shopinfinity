import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiException.fromDioError(DioException dioError) {
    int? statusCode;
    if (dioError.response?.statusCode != null) {
      statusCode = dioError.response!.statusCode;
    }

    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          statusCode: statusCode,
          error: dioError.error,
        );
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout',
          statusCode: statusCode,
          error: dioError.error,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout',
          statusCode: statusCode,
          error: dioError.error,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout',
          statusCode: statusCode,
          error: dioError.error,
        );
      case DioExceptionType.badResponse:
        String message = 'Something went wrong';
        if (dioError.response?.data != null) {
          try {
            if (dioError.response?.data['message'] != null) {
              message = dioError.response?.data['message'].toString() ?? message;
            } else if (dioError.response?.data['errorMessage'] != null) {
              message = dioError.response?.data['errorMessage'].toString() ?? message;
            }
          } catch (e) {
            // If we can't parse the error message, use the default
            print('Error parsing error message: $e');
          }
        }
        return ApiException(
          message: message,
          statusCode: statusCode,
          error: dioError.error,
        );
      case DioExceptionType.unknown:
        if (dioError.error != null && dioError.error.toString().contains('SocketException')) {
          return ApiException(
            message: 'No Internet connection',
            statusCode: statusCode,
            error: dioError.error,
          );
        }
        return ApiException(
          message: 'Unexpected error occurred',
          statusCode: statusCode,
          error: dioError.error,
        );
      default:
        return ApiException(
          message: 'Something went wrong',
          statusCode: statusCode,
          error: dioError.error,
        );
    }
  }

  @override
  String toString() => message;
}
