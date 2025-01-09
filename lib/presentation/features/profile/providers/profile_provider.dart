import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepository(dio: dio);
});

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends AsyncNotifier<Profile> {
  late final ProfileRepository _repository;

  @override
  Future<Profile> build() async {
    _repository = ref.read(profileRepositoryProvider);
    return _fetchProfile();
  }

  Future<Profile> _fetchProfile() async {
    try {
      final response = await _repository.fetchProfile();
      return Profile(
        name: response['name'] ?? '',
        email: response['email'] ?? '',
        mobile: response['primaryPhoneNo'] ?? '',
      );
    } catch (e) {
      // Return a default profile on error
      return const Profile(
        name: 'Guest',
        email: '',
        mobile: '',
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? mobile,
  }) async {
    state = AsyncValue.data(state.value!.copyWith(
      name: name,
      email: email,
      mobile: mobile,
    ));
  }
}
