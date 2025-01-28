import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:shopinfinity/core/network/api_config.dart';
import 'package:shopinfinity/core/network/api_exception.dart';
import '../models/cart_response.dart';

class CartRepository {
  final Dio dio;

  CartRepository({required this.dio});

  Future<CartResponse> fetchCart() async {
    try {
      dev.log('Fetching cart...', name: 'CartRepository');
      final response = await dio.get(ApiConfig.fetchCart);
      dev.log('Cart response: ${response.data}', name: 'CartRepository');

      // Handle empty cart response (204)
      if (response.statusCode == 204 || response.data['statusCode'] == 204) {
        dev.log('Empty cart response', name: 'CartRepository');
        return const CartResponse(
          id: '',
          boughtProductDetailsList: [],
          userDetailsDto: UserDetails(
            id: '',
            name: '',
            email: '',
            primaryPhoneNo: '',
            secondaryPhoneNo: '',
          ),
        );
      }

      // Check for error response
      if (response.data['statusCode'] == 400) {
        final errorMessage =
            response.data['errorMessage'] ?? 'Failed to fetch cart';
        dev.log('Error fetching cart: $errorMessage', name: 'CartRepository');
        throw ApiException(message: errorMessage);
      }

      if (response.data == null || response.data['responseBody'] == null) {
        throw ApiException(message: 'Invalid response from server');
      }

      final cartResponse = CartResponse.fromJson(response.data['responseBody']);
      dev.log(
          'Cart fetched successfully: ${cartResponse.boughtProductDetailsList.length} items',
          name: 'CartRepository');
      return cartResponse;
    } on DioException catch (e) {
      dev.log('DioException fetching cart: ${e.message}',
          name: 'CartRepository', error: e);
      if (e.response?.data != null) {
        final errorMessage =
            e.response?.data['errorMessage'] ?? 'Failed to fetch cart';
        throw ApiException(message: errorMessage);
      }
      throw ApiException(message: 'Failed to fetch cart: ${e.message}');
    } catch (e) {
      dev.log('Error fetching cart: $e', name: 'CartRepository', error: e);
      rethrow;
    }
  }

  Future<CartResponse> updateCart({
    required String varietyId,
    required int quantity,
  }) async {
    try {
      dev.log('Updating cart - varietyId: $varietyId, quantity: $quantity',
          name: 'CartRepository');

      // For empty cart or first item, just send the new item
      final currentCart = await fetchCart();
      final List<Map<String, dynamic>> items = [];

      // Add existing items except the one being updated
      if (currentCart.boughtProductDetailsList.isNotEmpty) {
        for (final item in currentCart.boughtProductDetailsList) {
          if (item.varietyId != varietyId) {
            items.add({
              'varietyId': item.varietyId,
              'boughtQuantity': item.boughtQuantity,
            });
          }
        }
      }

      // Only add the new item if quantity > 0
      if (quantity > 0) {
        items.add({
          'varietyId': varietyId,
          'boughtQuantity': quantity,
        });
      }

      dev.log('Sending update cart request with ${items.length} items',
          name: 'CartRepository');

      // Send request to API
      final response = await dio.post(
        ApiConfig.updateCart,
        data: {
          'boughtProductDetailsList': items,
        },
      );

      dev.log('Update cart response: ${response.data}', name: 'CartRepository');

      // Check for error response
      if (response.data['statusCode'] == 400) {
        final errorMessage =
            response.data['errorMessage'] ?? 'Failed to update cart';
        dev.log('Error updating cart: $errorMessage', name: 'CartRepository');
        throw ApiException(message: errorMessage);
      }

      if (response.statusCode == 204 || response.data['statusCode'] == 204) {
        dev.log('Empty cart after update', name: 'CartRepository');
        return const CartResponse(
          id: '',
          boughtProductDetailsList: [],
          userDetailsDto: UserDetails(
            id: '',
            name: '',
            email: '',
            primaryPhoneNo: '',
            secondaryPhoneNo: '',
          ),
        );
      }

      if (response.data == null || response.data['responseBody'] == null) {
        throw ApiException(message: 'Invalid response from server');
      }

      final cartResponse = CartResponse.fromJson(response.data['responseBody']);
      dev.log(
          'Cart updated successfully: ${cartResponse.boughtProductDetailsList.length} items',
          name: 'CartRepository');
      return cartResponse;
    } on DioException catch (e) {
      dev.log('DioException updating cart: ${e.message}',
          name: 'CartRepository', error: e);
      if (e.response?.data != null) {
        final errorMessage =
            e.response?.data['errorMessage'] ?? 'Failed to update cart';
        throw ApiException(message: errorMessage);
      }
      throw ApiException(message: 'Failed to update cart: ${e.message}');
    } catch (e) {
      dev.log('Error updating cart: $e', name: 'CartRepository', error: e);
      rethrow;
    }
  }
}
