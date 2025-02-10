import 'package:dio/dio.dart';
import '../models/order_response.dart';
import 'dart:developer' as dev;

class OrdersRepository {
  final Dio _dio;

  OrdersRepository({required Dio dio}) : _dio = dio;

  Future<OrderListResponse> fetchOrders() async {
    try {
      // dev.log('Fetching orders...', name: 'OrdersRepository');
      final response = await _dio.get('/v1/order/list');
      // dev.log('Orders response: ${response.data}', name: 'OrdersRepository');

      if (response.data['statusCode'] == 400) {
        final errorMessage =
            response.data['errorMessage'] ?? 'Failed to fetch orders';
        // dev.log('Error fetching orders: $errorMessage',
        //     name: 'OrdersRepository');
        throw Exception(errorMessage);
      }

      if (response.data == null || response.data['responseBody'] == null) {
        // dev.log('Invalid response from server', name: 'OrdersRepository');
        throw Exception('Invalid response from server');
      }

      final orderListResponse =
          OrderListResponse.fromJson(response.data['responseBody']);
      // dev.log('Fetched ${orderListResponse.content.length} orders',
      //     name: 'OrdersRepository');
      return orderListResponse;
    } on DioException catch (e) {
      // dev.log('DioException fetching orders: ${e.message}',
      //     name: 'OrdersRepository', error: e);
      if (e.response?.data != null) {
        final errorMessage =
            e.response?.data['errorMessage'] ?? 'Failed to fetch orders';
        throw Exception(errorMessage);
      }
      throw Exception('Failed to fetch orders');
    } catch (e, stack) {
      dev.log('Error fetching orders: $e',
          name: 'OrdersRepository', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<OrderResponse> fetchOrderDetails(String orderId) async {
    try {
      // dev.log('Fetching order details for ID: $orderId',
      //     name: 'OrdersRepository');
      final response = await _dio.get('/v1/order/$orderId');
      // dev.log('Order details response: ${response.data}',
      //     name: 'OrdersRepository');

      if (response.data['statusCode'] == 400) {
        final errorMessage =
            response.data['errorMessage'] ?? 'Failed to fetch order details';
        // dev.log('Error fetching order details: $errorMessage',
        //     name: 'OrdersRepository');
        throw Exception(errorMessage);
      }

      if (response.data == null || response.data['responseBody'] == null) {
        // dev.log('Invalid response from server', name: 'OrdersRepository');
        throw Exception('Invalid response from server');
      }

      final orderResponse =
          OrderResponse.fromJson(response.data['responseBody']);
      // dev.log('Fetched order details successfully', name: 'OrdersRepository');
      return orderResponse;
    } on DioException catch (e) {
      dev.log('DioException fetching order details: ${e.message}',
          name: 'OrdersRepository', error: e);
      if (e.response?.data != null) {
        final errorMessage =
            e.response?.data['errorMessage'] ?? 'Failed to fetch order details';
        throw Exception(errorMessage);
      }
      throw Exception('Failed to fetch order details');
    } catch (e, stack) {
      dev.log('Error fetching order details: $e',
          name: 'OrdersRepository', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
