import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/auth/auth_response.dart';

class StorageService {
  late Box<String> _tokenBox;
  late Box<Map> _userBox;
  bool _isInitialized = false;
  static const String _tokenKey = 'token';
  static const String _userDetailsKey = 'user_details';

  Future<void> init() async {
    if (_isInitialized) {
      dev.log('Storage service already initialized', name: 'StorageService');
      return;
    }

    try {
      dev.log('Initializing Hive...', name: 'StorageService');
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserDetailsAdapter());
      }

      dev.log('Opening storage boxes...', name: 'StorageService');
      _tokenBox = await Hive.openBox<String>('shopinfinity_token');
      _userBox = await Hive.openBox<Map>('shopinfinity_user');

      _isInitialized = true;
      dev.log('Storage service initialized successfully',
          name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error initializing storage service: $e\n$stack',
          name: 'StorageService', error: e);
      rethrow;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      dev.log('Storage not initialized, initializing now...',
          name: 'StorageService');
      await init();
    }
  }

  Future<void> saveToken(String token) async {
    await ensureInitialized();
    dev.log('Saving token...', name: 'StorageService');
    await _tokenBox.put(_tokenKey, token);
    dev.log('Token saved successfully', name: 'StorageService');
  }

  Future<String?> getToken() async {
    await ensureInitialized();
    return _tokenBox.get(_tokenKey);
  }

  Future<void> saveUserDetails(UserDetails userDetails) async {
    await ensureInitialized();
    dev.log('Saving user details...', name: 'StorageService');
    await _userBox.put(_userDetailsKey, userDetails.toJson());
    dev.log('User details saved successfully', name: 'StorageService');
  }

  Future<UserDetails?> getUserDetails() async {
    await ensureInitialized();
    final data = _userBox.get(_userDetailsKey);
    if (data != null) {
      return UserDetails.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    await ensureInitialized();
    final token = await getToken();
    final userDetails = await getUserDetails();
    dev.log(
        'Checking login status: token=${token != null}, userDetails=${userDetails != null}',
        name: 'StorageService');
    return token != null && userDetails != null;
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    dev.log('Clearing all storage...', name: 'StorageService');
    try {
      await Future.wait([
        _tokenBox.clear(),
        _userBox.clear(),
      ]);
      dev.log('Storage cleared successfully', name: 'StorageService');
    } catch (e, stack) {
      dev.log('Error clearing storage: $e\n$stack',
          name: 'StorageService', error: e);
      // Attempt to close and delete the boxes in case of corruption
      await _tokenBox.close();
      await _userBox.close();
      await Hive.deleteBoxFromDisk('shopinfinity_token');
      await Hive.deleteBoxFromDisk('shopinfinity_user');
      // Re-initialize the boxes
      _tokenBox = await Hive.openBox<String>('shopinfinity_token');
      _userBox = await Hive.openBox<Map>('shopinfinity_user');
      rethrow;
    }
  }
}
