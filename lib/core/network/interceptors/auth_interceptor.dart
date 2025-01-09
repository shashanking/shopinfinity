import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:shopinfinity/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService storageService;

  AuthInterceptor({required this.storageService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await storageService.getToken();
      dev.log('Auth token from storage: $token', name: 'AuthInterceptor');
      
      if (token != null && token.isNotEmpty) {
        // Always add Bearer prefix if not present
        final formattedToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
        options.headers['Authorization'] = formattedToken;
        dev.log('Added authorization header: $formattedToken', name: 'AuthInterceptor');
      } else {
        dev.log('No auth token found in storage', name: 'AuthInterceptor');
      }
    } catch (e, stack) {
      dev.log('Error reading token: $e\n$stack', name: 'AuthInterceptor', error: e);
    }
    
    dev.log('Final request headers: ${options.headers}', name: 'AuthInterceptor');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log('Response status: ${response.statusCode}', name: 'AuthInterceptor');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log(
      'Request error: ${err.message}\nResponse: ${err.response?.data}',
      name: 'AuthInterceptor',
      error: err,
    );

    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Token might be expired or invalid
      dev.log(
        'Authentication error: ${err.response?.statusCode}. Token may be invalid or expired.',
        name: 'AuthInterceptor',
      );
    }
    return handler.next(err);
  }
}
