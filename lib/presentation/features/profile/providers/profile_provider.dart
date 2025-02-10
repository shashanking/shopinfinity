import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import 'package:shopinfinity/core/providers/api_client_provider.dart';
import 'package:shopinfinity/presentation/features/authentication/providers/auth_provider.dart';
import 'package:shopinfinity/presentation/features/profile/models/profile.dart';
import 'package:shopinfinity/presentation/features/profile/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepository(apiClient: apiClient);
});

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async {
    // Listen to auth state changes
    ref.listen(authProvider, (previous, next) {
      // dev.log('Auth state changed:', name: 'ProfileNotifier');
      // dev.log('Previous: ${previous?.value?.toJson()}',
      //     name: 'ProfileNotifier');
      // dev.log('Next: ${next.value?.toJson()}', name: 'ProfileNotifier');

      if (previous?.value != next.value) {
        // dev.log('Auth state changed, refreshing profile...',
        //     name: 'ProfileNotifier');
        ref.invalidateSelf();
      }
    });

    // Get current auth state
    final authState = ref.watch(authProvider);
    // dev.log('Current auth state: ${authState.value?.toJson()}',
    //     name: 'ProfileNotifier');

    return authState.when(
      data: (auth) async {
        if (auth == null) {
          // dev.log('No auth data, returning guest profile',
          //     name: 'ProfileNotifier');
          return const Profile(name: 'Guest', email: '', mobile: '');
        }

        // dev.log('Auth data exists: ${auth.toJson()}', name: 'ProfileNotifier');
        // dev.log('User details: ${auth.responseBody?.userDetails?.toJson()}',
        //     name: 'ProfileNotifier');

        try {
          // dev.log('Fetching profile...', name: 'ProfileNotifier');
          final repository = ref.watch(profileRepositoryProvider);
          final profile = await repository.fetchProfile();
          // dev.log('Profile fetched successfully: ${profile.name}',
          //     name: 'ProfileNotifier');
          return profile;
        } catch (e, stack) {
          dev.log('Error fetching profile: $e\n$stack',
              name: 'ProfileNotifier', error: e);
          // Instead of returning Guest profile on error, let's use the user details from auth if available
          if (auth.responseBody?.userDetails != null) {
            final userDetails = auth.responseBody!.userDetails!;
            return Profile(
              name: userDetails.name ?? 'Guest',
              email: userDetails.email ?? '',
              mobile: userDetails.primaryPhoneNo ?? '',
            );
          }
          return const Profile(name: 'Guest', email: '', mobile: '');
        }
      },
      loading: () {
        // dev.log('Auth state loading, returning guest profile',
        //     name: 'ProfileNotifier');
        return Future.value(
            const Profile(name: 'Guest', email: '', mobile: ''));
      },
      error: (e, stack) {
        dev.log('Auth state error, returning guest profile: $e\n$stack',
            name: 'ProfileNotifier', error: e);
        return Future.value(
            const Profile(name: 'Guest', email: '', mobile: ''));
      },
    );
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
