import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier()
      : super(
          const Profile(
            name: 'Salmaan Ahmed',
            email: 'salmaan@example.com',
            mobile: '96000 16417',
          ),
        );

  void updateProfile({
    String? name,
    String? email,
    String? mobile,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      mobile: mobile,
    );
  }
}
