import 'package:dio/dio.dart';
import '../models/create_order_request.dart';

class OrderRepository {
  final Dio _dio;

  OrderRepository({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>> createOrder(CreateOrderRequest request) async {
    try {
      final response = await _dio.post(
        '/v1/order/create',
        data: request.toJson(),
      );
      
      // Check if response has error message
      if (response.data['statusCode'] == 400) {
        throw Exception(response.data['errorMessage']);
      }
      
      return response.data['responseBody'];
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['errorMessage'] ?? 'Failed to create order';
        throw Exception(errorMessage);
      }
      throw Exception('Failed to create order');
    }
  }
}
