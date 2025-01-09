import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;
import 'package:shopinfinity/core/models/auth/auth_request.dart';
import 'package:shopinfinity/core/models/auth/auth_response.dart';
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/network/api_config.dart';
import 'package:shopinfinity/core/network/api_exception.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({required ApiClient apiClient}) : _apiClient = apiClient {
    dev.log('Auth service initialized', name: 'AuthService');
  }

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
      return AuthResponse.fromJson(response.data);
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
        final message = response.data is Map ? 
          response.data['message'] ?? 'Registration failed' : 
          'Registration failed';
        throw ApiException(
          message: message,
          statusCode: 403,
        );
      }
      
      if (response.statusCode != 200) {
        final message = response.data is Map ? 
          response.data['message'] ?? 'Registration failed' : 
          'Registration failed';
        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }
      
      try {
        if (response.data is! Map) {
          throw FormatException('Invalid response format');
        }
        
        final responseData = response.data as Map<String, dynamic>;
        final responseBody = responseData['responseBody'] as Map<String, dynamic>;
        
        return AuthResponse(
          statusCode: responseData['statusCode'] ?? 200,
          responseBody: ResponseBody(
            token: responseBody['token'],
            message: responseData['message'],
            status: responseBody['status'] ?? 'success',
            existing: responseBody['existing'] ?? false,
            userDetails: null, // We don't get user details in the response
          ),
        );
      } catch (e, stack) {
        dev.log('Error parsing register response: $e\n$stack', 
               name: 'AuthService', 
               error: e);
        throw ApiException(
          message: 'Invalid response format from server',
          statusCode: response.statusCode,
          error: e,
        );
      }
    } on dio.DioException catch (e, stack) {
      dev.log('Register DioException: ${e.response?.data}\n$stack', 
             name: 'AuthService', 
             error: e);
      if (e.response?.statusCode == 403) {
        final message = e.response?.data is Map ? 
          e.response?.data['message'] ?? 'Registration failed' : 
          'Registration failed';
        throw ApiException(
          message: message,
          statusCode: 403,
        );
      }
      throw ApiException.fromDioError(e);
    } catch (e, stack) {
      dev.log('Register error: $e\n$stack', 
             name: 'AuthService', 
             error: e);
      throw ApiException(
        message: e.toString(),
        error: e,
      );
    }
  }
}
