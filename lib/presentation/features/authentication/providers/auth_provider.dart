import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/auth/auth_response.dart';
import 'package:shopinfinity/core/services/auth_service.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'package:shopinfinity/core/services/storage_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthResponse?>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService: authService, storageService: storageService);
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthResponse?>> {
  final AuthService _authService;
  final StorageService _storageService;

  AuthNotifier({
    required AuthService authService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService,
        super(const AsyncValue.data(null)) {
    // Check for existing session on initialization
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      if (isLoggedIn) {
        final userDetails = await _storageService.getUserDetails();
        if (userDetails != null) {
          state = AsyncValue.data(AuthResponse(
            statusCode: 200,
            responseBody: ResponseBody(
              userDetails: userDetails,
              status: 'success',
              existing: true,
            ),
          ));
        }
      }
    } catch (e) {
      dev.log('Error initializing auth state: $e', name: 'AuthNotifier');
    }
  }

  Future<AuthResponse?> sendOtp(String phoneNumber) async {
    state = const AsyncValue.loading();
    try {
      dev.log('Sending OTP for phone: $phoneNumber', name: 'AuthNotifier');
      final response = await _authService.sendOtp(phoneNumber);
      dev.log('OTP send response: ${response.toJson()}', name: 'AuthNotifier');
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      dev.log('Error sending OTP: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<AuthResponse?> verifyOtp(String phoneNumber, String otp) async {
    state = const AsyncValue.loading();
    try {
      dev.log('Verifying OTP for phone: $phoneNumber', name: 'AuthNotifier');
      final response = await _authService.verifyOtp(phoneNumber, otp);
      dev.log('OTP verify response: ${response.toJson()}', name: 'AuthNotifier');
      
      // Save token for both new and existing users if token is present
      if (response.statusCode == 200 && response.responseBody?.token != null) {
        try {
          dev.log('Saving token for user', name: 'AuthNotifier');
          final token = response.responseBody!.token!;
          // Ensure token has Bearer prefix
          final formattedToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
          await _storageService.saveToken(formattedToken);
          
          if (response.responseBody?.userDetails != null) {
            dev.log('Saving user details', name: 'AuthNotifier');
            await _storageService.saveUserDetails(response.responseBody!.userDetails!);
          }
          dev.log('Token and user details saved successfully', name: 'AuthNotifier');
        } catch (e, stack) {
          dev.log('Error saving session: $e\n$stack', name: 'AuthNotifier', error: e);
          throw Exception('Failed to save session: $e');
        }
      } else if (response.statusCode == 200 && response.responseBody?.token == null) {
        dev.log('No token in response - user may need to complete registration', name: 'AuthNotifier');
      }
      
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      dev.log('Error verifying OTP: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<AuthResponse?> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      dev.log('Logging in user: $username', name: 'AuthNotifier');
      final response = await _authService.login(username, password);
      dev.log('Login response: ${response.toJson()}', name: 'AuthNotifier');
      
      if (response.statusCode == 200) {
        try {
          dev.log('Saving token and user details', name: 'AuthNotifier');
          if (response.responseBody?.token != null) {
            final token = response.responseBody!.token!;
            // Ensure token has Bearer prefix
            final formattedToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
            await _storageService.saveToken(formattedToken);
          }
          if (response.responseBody?.userDetails != null) {
            await _storageService.saveUserDetails(response.responseBody!.userDetails!);
          }
          dev.log('Token and user details saved', name: 'AuthNotifier');
        } catch (e, stack) {
          dev.log('Error saving session: $e\n$stack', name: 'AuthNotifier', error: e);
          throw Exception('Failed to save session: $e');
        }
      }
      
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      dev.log('Error logging in: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<AuthResponse?> register({
    required String phone,
    required String name,
    required String email,
    String? secondaryPhone,
  }) async {
    state = const AsyncValue.loading();
    try {
      dev.log('Registering user: $name ($phone)', name: 'AuthNotifier');
      final response = await _authService.register(
        phone: phone,
        name: name,
        email: email,
        secondaryPhone: secondaryPhone,
      );
      dev.log('Register response: ${response.toJson()}', name: 'AuthNotifier');
      
      if (response.statusCode == 200) {
        try {
          dev.log('Saving token and user details', name: 'AuthNotifier');
          if (response.responseBody?.token != null) {
            final token = response.responseBody!.token!;
            // Ensure token has Bearer prefix
            final formattedToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
            await _storageService.saveToken(formattedToken);
          }
          if (response.responseBody?.userDetails != null) {
            await _storageService.saveUserDetails(response.responseBody!.userDetails!);
          }
          dev.log('Token and user details saved', name: 'AuthNotifier');
        } catch (e, stack) {
          dev.log('Error saving session: $e\n$stack', name: 'AuthNotifier', error: e);
          throw Exception('Failed to save session: $e');
        }
      }
      
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      dev.log('Error registering: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _storageService.clearAll();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      dev.log('Error logging out: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
