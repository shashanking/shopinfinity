import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;
import 'package:shopinfinity/core/models/auth/auth_request.dart';
import 'package:shopinfinity/core/models/auth/auth_response.dart';
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/network/api_config.dart';
import 'package:shopinfinity/core/network/api_exception.dart';
import 'package:shopinfinity/core/services/storage_service.dart';

class AuthService {
  final ApiClient _apiClient;
  final dio.Dio _dio;
  final StorageService _storageService;

  AuthService({
    required ApiClient apiClient,
    required dio.Dio dio,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _dio = dio,
        _storageService = storageService;

  Future<AuthResponse> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.sendOtp,
        data: SendOtpRequest(phone: phoneNumber).toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AuthResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.verifyOtp,
        data: VerifyOtpRequest(
          phone: phoneNumber,
          authCode: otp,
        ).toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // If verification successful, fetch user details
      if (authResponse.statusCode == 200 &&
          authResponse.responseBody?.token != null) {
        dev.log('OTP verified, fetching user details...', name: 'AuthService');

        // Set token for subsequent requests
        final token = authResponse.responseBody!.token!;
        final formattedToken =
            token.startsWith('Bearer ') ? token : 'Bearer $token';

        // Create options with the token
        final options = dio.Options(
          headers: {
            'Authorization': formattedToken,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        // Fetch user details
        final userResponse = await _apiClient.get(
          ApiConfig.fetchUserProfile,
          options: options,
        );

        dev.log('User details response: ${userResponse.data}',
            name: 'AuthService');

        if (userResponse.data != null &&
            userResponse.data['responseBody'] != null) {
          final userDetails =
              UserDetails.fromJson(userResponse.data['responseBody']);

          // Return combined response
          return AuthResponse(
            statusCode: authResponse.statusCode,
            responseBody: ResponseBody(
              token: formattedToken,
              message: authResponse.responseBody?.message,
              status: authResponse.responseBody?.status,
              existing: authResponse.responseBody?.existing,
              userDetails: userDetails,
            ),
          );
        }
      }

      return authResponse;
    } on dio.DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.login,
        data: LoginRequest(
          userName: username,
          password: password,
        ).toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AuthResponse> register({
    required String phone,
    required String name,
    required String email,
    String? secondaryPhone,
  }) async {
    try {
      final request = {
        'name': name,
        'email': email,
        'primaryPhoneNo': phone,
        if (secondaryPhone != null && secondaryPhone.isNotEmpty)
          'secondaryPhoneNo': secondaryPhone,
      };

      dev.log('Register request: $request', name: 'AuthService');

      final response = await _apiClient.post(
        ApiConfig.register,
        data: request,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      dev.log('Register raw response: ${response.data}', name: 'AuthService');

      if (response.statusCode == 403) {
        final message = response.data is Map
            ? response.data['message'] ?? 'Registration failed'
            : 'Registration failed';
        throw ApiException(
          message: message,
          statusCode: 403,
        );
      }

      if (response.statusCode != 200) {
        final message = response.data is Map
            ? response.data['message'] ?? 'Registration failed'
            : 'Registration failed';
        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }

      try {
        if (response.data is! Map) {
          throw const FormatException('Invalid response format');
        }

        final responseData = response.data as Map<String, dynamic>;
        final responseBody =
            responseData['responseBody'] as Map<String, dynamic>;

        // Create user details from the registration data
        final userDetails = UserDetails(
          id: responseBody['id'] as String?,
          name: name,
          email: email,
          primaryPhoneNo: phone,
          secondaryPhoneNo: secondaryPhone,
          role: responseBody['role'] as String?,
          isActive: responseBody['isActive'] as bool? ?? true,
          createdAt: responseBody['createdAt'] as String?,
          updatedAt: responseBody['updatedAt'] as String?,
        );

        dev.log(
            'Created user details from registration: ${userDetails.toJson()}',
            name: 'AuthService');

        return AuthResponse(
          statusCode: responseData['statusCode'] ?? 200,
          responseBody: ResponseBody(
            token: responseBody['token'],
            message: responseData['message'],
            status: responseBody['status'] ?? 'success',
            existing: responseBody['existing'] ?? false,
            userDetails: userDetails,
          ),
        );
      } catch (e, stack) {
        dev.log('Error parsing register response: $e\n$stack',
            name: 'AuthService', error: e);
        throw ApiException(
          message: 'Invalid response format from server',
          statusCode: response.statusCode,
          error: e,
        );
      }
    } on dio.DioException catch (e, stack) {
      dev.log('Register DioException: ${e.response?.data}\n$stack',
          name: 'AuthService', error: e);
      if (e.response?.statusCode == 403) {
        final message = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Registration failed'
            : 'Registration failed';
        throw ApiException(
          message: message,
          statusCode: 403,
        );
      }
      throw ApiException.fromDioError(e);
    } catch (e, stack) {
      dev.log('Register error: $e\n$stack', name: 'AuthService', error: e);
      throw ApiException(
        message: e.toString(),
        error: e,
      );
    }
  }

  /// Resets the Dio client by recreating it with default options
  void resetClient() {
    dev.log('Resetting Dio client...', name: 'AuthService');

    try {
      // Reset the ApiClient which will handle closing and recreating the Dio instance
      _apiClient.updateDio();
      dev.log('Dio client reset complete', name: 'AuthService');
    } catch (e, stack) {
      dev.log('Error resetting Dio client: $e\n$stack',
          name: 'AuthService', error: e);
      rethrow; // Rethrow to ensure the error is not silently ignored
    }
  }
}
