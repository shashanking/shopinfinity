import 'dart:developer' as dev;
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/services/auth_service.dart';
import 'package:shopinfinity/core/services/storage_service.dart';

void main() async {
  final storageService = StorageService();
  await storageService.init();
  dev.log('Storage service initialized', name: 'TestAuth');
  
  final apiClient = ApiClient(storageService: storageService);
  dev.log('API client initialized', name: 'TestAuth');
  
  final authService = AuthService(apiClient: apiClient);
  dev.log('Auth service initialized', name: 'TestAuth');
  
  const phoneNumber = '9380969957';
  const otp = '4444';

  try {
    dev.log('Sending OTP...', name: 'TestAuth');
    final sendOtpResponse = await authService.sendOtp(phoneNumber);
    dev.log('Send OTP Response: ${sendOtpResponse.toJson()}', name: 'TestAuth');

    dev.log('Verifying OTP...', name: 'TestAuth');
    final verifyOtpResponse = await authService.verifyOtp(phoneNumber, otp);
    dev.log('Verify OTP Response: ${verifyOtpResponse.toJson()}', name: 'TestAuth');

    // For login, we should use username and password
    dev.log('Logging in...', name: 'TestAuth');
    final loginResponse = await authService.login('testuser', 'testpass');
    dev.log('Login Response: ${loginResponse.toJson()}', name: 'TestAuth');
  } catch (e, stack) {
    dev.log('Error: $e', name: 'TestAuth', error: e, stackTrace: stack);
  }
}
