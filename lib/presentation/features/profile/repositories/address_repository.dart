import 'package:dio/dio.dart';
import '../models/address.dart';
import '../../../../core/network/api_exception.dart';

class AddressRepository {
  final Dio _dio;

  AddressRepository({required Dio dio}) : _dio = dio;

  Future<AddressResponse> fetchAddresses() async {
    try {
      final response = await _dio.get('/login/v1/profile/address/fetch');
      final responseData =
          response.data['responseBody'] as Map<String, dynamic>;
      return AddressResponse.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw ApiException(
          message:
              e.response?.data['errorMessage'] ?? 'Failed to fetch addresses',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      throw ApiException(message: 'Failed to fetch addresses');
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

      // Check for error status in response body even if HTTP status is 200
      if (response.data is Map && response.data['statusCode'] == 400) {
        final errorMessage =
            response.data['errorMessage'] ?? 'Failed to add address';
        throw ApiException(
          message: errorMessage,
          statusCode: 400,
          isServiceError:
              true, // Flag to indicate this is a service-level error
        );
      }

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.data['errorMessage'] ?? 'Failed to add address',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw ApiException(
          message: e.response?.data['errorMessage'] ?? 'Failed to add address',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      throw ApiException(message: 'Failed to add address. Please try again.');
    }
  }
}
