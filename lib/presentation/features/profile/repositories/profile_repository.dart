import 'package:dio/dio.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await _dio.get('/login/v1/profile/user/fetch');
      return response.data['responseBody'];
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response?.data['errorMessage'] ?? 'Failed to fetch profile');
      }
      throw Exception('Failed to fetch profile');
    }
  }
}
