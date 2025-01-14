import 'package:dio/dio.dart';
import '../models/order_response.dart';

class OrdersRepository {
  final Dio _dio;

  OrdersRepository({required Dio dio}) : _dio = dio;

  Future<OrderResponse> fetchOrders() async {
    try {
      final response = await _dio.get('/v1/order/list');

      if (response.data['statusCode'] == 400) {
        throw Exception(response.data['errorMessage'] ?? 'Failed to fetch orders');
      }

      if (response.data == null || response.data['responseBody'] == null) {
        throw Exception('Invalid response from server');
      }

      return OrderResponse.fromJson(response.data['responseBody']);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['errorMessage'] ?? 'Failed to fetch orders';
        throw Exception(errorMessage);
      }
      throw Exception('Failed to fetch orders');
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> fetchOrderDetails(String orderId) async {
    try {
      final response = await _dio.get('/v1/order/$orderId');

      if (response.data['statusCode'] == 400) {
        throw Exception(response.data['errorMessage'] ?? 'Failed to fetch order details');
      }

      if (response.data == null || response.data['responseBody'] == null) {
        throw Exception('Invalid response from server');
      }

      return Order.fromJson(response.data['responseBody']);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['errorMessage'] ?? 'Failed to fetch order details';
        throw Exception(errorMessage);
      }
      throw Exception('Failed to fetch order details');
    } catch (e) {
      rethrow;
    }
  }
}
