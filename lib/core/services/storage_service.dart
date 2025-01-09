import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';

import '../models/auth/auth_response.dart';
class StorageService {
  late Box _box;
  static const String _tokenKey = 'token';
  static const String _userDetailsKey = 'user_details';

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox('shopinfinity');
      dev.log('Storage initialized', name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error initializing storage: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      // Ensure token has Bearer prefix
      final formattedToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
      await _box.put(_tokenKey, formattedToken);
      dev.log('Saved token: $formattedToken', name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error saving token: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _box.get(_tokenKey) as String?;
      dev.log('Retrieved token: $token', name: 'StorageService');
      
      if (token == null) {
        dev.log('No token found in storage', name: 'StorageService');
        return null;
      }
      
      // Ensure token has Bearer prefix
      if (!token.startsWith('Bearer ')) {
        final formattedToken = 'Bearer $token';
        dev.log('Adding Bearer prefix to token: $formattedToken', name: 'StorageService');
        await saveToken(formattedToken);
        return formattedToken;
      }
      
      return token;
    } catch (e, stack) {
      dev.log('Error getting token: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> saveUserDetails(UserDetails userDetails) async {
    try {
      await _box.put(_userDetailsKey, userDetails.toJson());
      dev.log('Saved user details', name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error saving user details: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<UserDetails?> getUserDetails() async {
    try {
      final userDetailsJson = await _box.get(_userDetailsKey);
      if (userDetailsJson == null) {
        dev.log('No user details found in storage', name: 'StorageService');
        return null;
      }
      final userDetails = UserDetails.fromJson(userDetailsJson);
      dev.log('Retrieved user details', name: 'StorageService');
      return userDetails;
    } catch (e, stack) {
      dev.log('Error getting user details: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      dev.log('Checking login status: ${token != null} (token: $token)',
          name: 'StorageService');
      return token != null;
    } catch (e, stack) {
      dev.log('Error checking login status: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      return false;
    }
  }

  Future<void> clearAll() async {
    try {
      await _box.clear();
      dev.log('Cleared all storage', name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error clearing storage: $e\n$stack',
          name: 'StorageService', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
