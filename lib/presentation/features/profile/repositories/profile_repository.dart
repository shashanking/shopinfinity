import 'dart:developer' as dev;
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/presentation/features/profile/models/profile.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Profile> fetchProfile() async {
    try {
      // dev.log('Fetching profile from API...', name: 'ProfileRepository');

      // Log the request headers
      final token = await _apiClient.storageService.getToken();
      // dev.log('Request headers - Authorization: $token',
      //     name: 'ProfileRepository');

      final response = await _apiClient.get('/login/v1/profile/user/fetch');
      // dev.log('Profile API response: ${response.data}',
      //     name: 'ProfileRepository');
      // dev.log('Response status code: ${response.statusCode}',
      //     name: 'ProfileRepository');

      if (response.data == null) {
        dev.log('No data in profile response', name: 'ProfileRepository');
        throw Exception('No data in profile response');
      }

      final responseData = response.data as Map<String, dynamic>;
      // dev.log('Response data: $responseData', name: 'ProfileRepository');

      // Extract data from responseBody if it exists
      final userData =
          responseData['responseBody'] as Map<String, dynamic>? ?? responseData;
      // dev.log('Extracted user data: $userData', name: 'ProfileRepository');

      final profile = Profile(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        mobile: userData['primaryPhoneNo'] ?? '',
      );

      // dev.log('Created profile object: ${profile.toString()}',
      //     name: 'ProfileRepository');
      return profile;
    } catch (e, stack) {
      dev.log('Error fetching profile: $e\n$stack',
          name: 'ProfileRepository', error: e);
      rethrow;
    }
  }
}
