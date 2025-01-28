import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/network/api_config.dart';
import 'package:shopinfinity/core/network/api_exception.dart';
import 'package:shopinfinity/core/services/storage_service.dart';

class ProductService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  ProductService(
      {required ApiClient apiClient, required StorageService storageService})
      : _apiClient = apiClient,
        _storageService = storageService;

  Future<ProductListResponse> listProducts({
    int pageNo = 1,
    int perPage = 300,
    String? category,
    String? subCategory,
    String? subCategory2,
    String? name,
    String? brand,
    double? minimumPrice,
    double? maximumPrice,
    String? varietyDescription,
    String? codes,
    int? quantity,
    String? sortDirection,
  }) async {
    try {
      final queryParams = {
        'pageNo': pageNo.toString(),
        'perPage': perPage.toString(),
        if (category != null) 'category': category,
        if (subCategory != null) 'subCategory': subCategory,
        if (subCategory2 != null) 'subCategory2': subCategory2,
        if (name != null) 'name': name,
        if (brand != null) 'brand': brand,
        if (minimumPrice != null) 'minimumPrice': minimumPrice.toString(),
        if (maximumPrice != null) 'maximumPrice': maximumPrice.toString(),
        if (varietyDescription != null)
          'varietyDescription': varietyDescription,
        if (codes != null) 'codes': codes,
        if (quantity != null) 'quantity': quantity.toString(),
        if (sortDirection != null) 'sortDirection': sortDirection,
      };

      dev.log('API Request URL: ${ApiConfig.listProducts}',
          name: 'ProductService');
      dev.log('Query Parameters: $queryParams', name: 'ProductService');

      final token = await _storageService.getToken();
      final response = await _apiClient.get(
        ApiConfig.listProducts,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      dev.log('Response Status Code: ${response.statusCode}',
          name: 'ProductService');
      if (response.data != null) {
        dev.log('Response Data Type: ${response.data.runtimeType}',
            name: 'ProductService');
      }

      // Log the response data
      dev.log('Response Data: ${response.data}', name: 'ProductService');

      if (response.data == null) {
        dev.log('No data received from API', name: 'ProductService');
        throw ApiException(
          message: 'No data received from API',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode != 200) {
        dev.log('API call failed with status: ${response.statusCode}',
            name: 'ProductService');
        throw ApiException(
          message: 'API call failed',
          statusCode: response.statusCode,
        );
      }

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        dev.log('Invalid response format: $responseData',
            name: 'ProductService', error: 'Response is not a Map');
        throw ApiException(
          message: 'Invalid API response format',
          statusCode: response.statusCode,
        );
      }

      // Handle both response formats
      final productData = responseData['responseBody'] ?? responseData;
      if (productData is! Map<String, dynamic>) {
        dev.log('Invalid product data format: $productData',
            name: 'ProductService', error: 'Product data is not a Map');
        throw ApiException(
          message: 'Invalid product data format',
          statusCode: response.statusCode,
        );
      }

      dev.log('Product Response Data: $productData', name: 'ProductService');
      final result = ProductListResponse.fromJson(productData);
      dev.log('Parsed ${result.content.length} products from page $pageNo',
          name: 'ProductService');
      return result;
    } on dio.DioException catch (e, stack) {
      dev.log(
        'DioError fetching products: ${e.message}',
        name: 'ProductService',
        error: e,
        stackTrace: stack,
      );

      if (e.response?.statusCode == 403) {
        throw ApiException(
          message: 'Not authorized to access products. Please log in again.',
          statusCode: e.response?.statusCode,
        );
      }

      throw ApiException.fromDioError(e);
    } catch (e, stack) {
      dev.log(
        'Error fetching products: $e',
        name: 'ProductService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Product> getProduct(String id) async {
    try {
      final response = await _apiClient.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
