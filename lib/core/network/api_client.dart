import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopinfinity/core/network/api_config.dart';
import 'package:shopinfinity/core/network/interceptors/auth_interceptor.dart';
import 'package:shopinfinity/core/services/storage_service.dart';
import 'dart:developer' as dev;

class ApiClient {
  late Dio _dio;
  final StorageService storageService;

  Dio get dio => _dio;

  ApiClient({required this.storageService}) {
    dev.log('Initializing API client with storage service', name: 'ApiClient');
    _dio = _createDio();
    _addInterceptors();
    dev.log('API client initialized with interceptors', name: 'ApiClient');
  }

  Dio _createDio() {
    return Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));
  }

  void _addInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(storageService: storageService),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    ]);
  }

  /// Updates the Dio instance with a new one and resets interceptors
  void updateDio([Dio? newDio]) {
    dev.log('Updating Dio instance...', name: 'ApiClient');

    // Close the existing Dio instance if it exists
    _dio.close(force: true);

    // Create a new Dio instance if one wasn't provided
    _dio = newDio ?? _createDio();
    _addInterceptors();

    dev.log('Dio instance updated with new interceptors', name: 'ApiClient');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      dev.log('GET request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      dev.log('POST request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      dev.log('PUT request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      dev.log('DELETE request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }
}
