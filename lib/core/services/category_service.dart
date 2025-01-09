import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;
import '../models/category/category_response.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';
import '../network/api_exception.dart';
import 'storage_service.dart';

class CategoryService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  CategoryService({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<CategoryResponse> getAllCategories() async {
    try {
      dev.log('Fetching all categories', name: 'CategoryService');
      final token = await _storageService.getToken();
      
      final response = await _apiClient.get(
        '${ApiConfig.baseUrl}/v1/category/all',
        options: dio.Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      dev.log('Response Status Code: ${response.statusCode}', name: 'CategoryService');
      
      if (response.data == null) {
        throw ApiException(
          message: 'No data received from API',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode != 200) {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? 'Failed to fetch categories'
            : 'Failed to fetch categories';

        throw ApiException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }

      return CategoryResponse.fromJson(response.data);
    } catch (e, stack) {
      dev.log(
        'Error fetching categories',
        name: 'CategoryService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
