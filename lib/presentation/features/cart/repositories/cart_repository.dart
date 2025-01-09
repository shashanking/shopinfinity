import 'package:dio/dio.dart';
import '../models/cart_response.dart';

class CartRepository {
  final Dio dio;

  CartRepository({required this.dio});

  Future<CartResponse> fetchCart() async {
    try {
      final response = await dio.get('/v1/cart/list');
      
      // Handle empty cart response (204)
      if (response.statusCode == 204 || response.data['statusCode'] == 204) {
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
        throw Exception('Invalid response from server');
      }
      return CartResponse.fromJson(response.data['responseBody']);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartResponse> updateCart({
    required String varietyId,
    required int quantity,
  }) async {
    try {
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

      // Send request to API
      final response = await dio.post(
        '/v1/cart/create-or-update',
        data: {
          'boughtProductDetailsList': items,
        },
      );
      
      if (response.statusCode == 204 || response.data['statusCode'] == 204) {
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
        throw Exception('Invalid response from server');
      }
      
      return CartResponse.fromJson(response.data['responseBody']);
    } catch (e) {
      rethrow;
    }
  }
}
