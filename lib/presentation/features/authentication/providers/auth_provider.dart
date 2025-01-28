import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/auth/auth_response.dart';
import 'package:shopinfinity/core/services/auth_service.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'package:shopinfinity/core/services/storage_service.dart';
import 'package:shopinfinity/presentation/features/cart/providers/cart_provider.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthResponse?>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(
      authService: authService, storageService: storageService, ref: ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthResponse?>> {
  final AuthService _authService;
  final StorageService _storageService;
  final Ref _ref;

  AuthNotifier({
    required AuthService authService,
    required StorageService storageService,
    required Ref ref,
  })  : _authService = authService,
        _storageService = storageService,
        _ref = ref,
        super(const AsyncValue.data(null)) {
    // Check for existing session on initialization
    _initializeAuthState();
  }

  /// Saves the user session data (token and user details) to storage
  Future<void> _saveSession(AuthResponse response) async {
    try {
      dev.log('Saving session data...', name: 'AuthNotifier');

      // Validate response data first
      if (response.responseBody == null) {
        throw Exception('Invalid response: no response body');
      }

      // Validate token
      final token = response.responseBody?.token;
      if (token == null || token.isEmpty) {
        throw Exception('No token received from server');
      }

      // Validate user details
      final userDetails = response.responseBody?.userDetails;
      if (userDetails == null) {
        throw Exception('No user details received from server');
      }

      // Only after validation, clear old session and save new one
      await _clearSession();

      // Reset cart provider state before saving new user's data
      _ref.invalidate(cartProvider);

      // Save validated data
      final formattedToken =
          token.startsWith('Bearer ') ? token : 'Bearer $token';
      await _storageService.saveToken(formattedToken);
      await _storageService.saveUserDetails(userDetails);

      dev.log('Saved user details: ${userDetails.toJson()}',
          name: 'AuthNotifier');
      dev.log('Session data saved successfully', name: 'AuthNotifier');
    } catch (e, stack) {
      dev.log('Error saving session: $e\n$stack',
          name: 'AuthNotifier', error: e);
      // Clear any partially saved data
      await _clearSession();
      throw Exception('Failed to save session: $e');
    }
  }

  /// Clears the user session data and resets related states
  Future<void> _clearSession() async {
    dev.log('Clearing session data...', name: 'AuthNotifier');
    await _storageService.clearAll();
    _ref.invalidate(cartProvider);
    dev.log('Session data cleared', name: 'AuthNotifier');
  }

  Future<void> _initializeAuthState() async {
    try {
      dev.log('Initializing auth state...', name: 'AuthNotifier');
      final isLoggedIn = await _storageService.isLoggedIn();
      dev.log('Is logged in: $isLoggedIn', name: 'AuthNotifier');

      if (isLoggedIn) {
        final token = await _storageService.getToken();
        final userDetails = await _storageService.getUserDetails();
        dev.log('Retrieved token: $token', name: 'AuthNotifier');
        dev.log('Retrieved user details: ${userDetails?.toJson()}',
            name: 'AuthNotifier');

        if (userDetails != null && token != null) {
          state = AsyncValue.data(AuthResponse(
            statusCode: 200,
            responseBody: ResponseBody(
              userDetails: userDetails,
              token: token,
              status: 'success',
              existing: true,
            ),
          ));
          dev.log('Auth state initialized with user details',
              name: 'AuthNotifier');
        } else {
          dev.log('Invalid session data found, clearing auth state',
              name: 'AuthNotifier');
          await _clearSession();
          state = const AsyncValue.data(null);
        }
      } else {
        dev.log('Not logged in, auth state is null', name: 'AuthNotifier');
        await _clearSession();
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      dev.log('Error initializing auth state: $e\n$stack',
          name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      await _clearSession();
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
      dev.log('OTP verify response: ${response.toJson()}',
          name: 'AuthNotifier');

      if (response.statusCode == 200) {
        try {
          await _saveSession(response);
          state = AsyncValue.data(response);
        } catch (e, stack) {
          dev.log('Error saving session after OTP verification: $e\n$stack',
              name: 'AuthNotifier', error: e);
          state = const AsyncValue.data(null);
          rethrow;
        }
      } else {
        state = AsyncValue.data(response);
      }

      return response;
    } catch (e, stack) {
      dev.log('Error verifying OTP: $e\n$stack',
          name: 'AuthNotifier', error: e);
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
        await _saveSession(response);
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
        await _saveSession(response);
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
      dev.log('Logging out user...', name: 'AuthNotifier');

      // First set state to null to trigger listeners
      state = const AsyncValue.data(null);

      // Clear session data
      await _clearSession();

      // Clear Dio client's cache by recreating it
      _authService.resetClient();

      dev.log('Logout complete', name: 'AuthNotifier');
    } catch (e, stack) {
      dev.log('Error logging out: $e\n$stack', name: 'AuthNotifier', error: e);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
