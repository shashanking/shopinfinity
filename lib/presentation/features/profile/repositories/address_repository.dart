import 'package:dio/dio.dart';
import '../models/address.dart';

class AddressRepository {
  final Dio _dio;

  AddressRepository({required Dio dio}) : _dio = dio;

  Future<AddressResponse> fetchAddresses() async {
    try {
      final response = await _dio.get('/login/v1/profile/address/fetch');
      final responseData = response.data['responseBody'] as Map<String, dynamic>;
      return AddressResponse.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response?.data['errorMessage'] ?? 'Failed to fetch addresses');
      }
      throw Exception('Failed to fetch addresses');
    }
  }

  Future<void> addAddress({
    required String addressLine1,
    required String addressLine2,
    required String landmark,
    required String city,
    required String state1,
    required String pincode,
    required String addressName,
    required bool primaryAddress,
  }) async {
    try {
      final response = await _dio.post(
        '/login/v1/profile/address/add',
        data: {
          'addressLine1': addressLine1,
          'addressLine2': addressLine2,
          'landmark': landmark,
          'city': city,
          'state': state1,
          'pincode': pincode,
          'addressName': addressName,
          'primaryAddress': primaryAddress,
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception(response.data['errorMessage'] ?? 'Failed to add address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['errorMessage'] ?? 'Failed to add address');
      }
      throw Exception('Failed to add address. Please try again.');
    }
  }
}
