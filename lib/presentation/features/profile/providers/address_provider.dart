import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/address.dart';
import '../repositories/address_repository.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressRepository(dio: dio);
});

final addressProvider = StateNotifierProvider<AddressNotifier, AsyncValue<AddressResponse?>>((ref) {
  return AddressNotifier(repository: ref.watch(addressRepositoryProvider));
});

class AddressNotifier extends StateNotifier<AsyncValue<AddressResponse?>> {
  final AddressRepository _repository;

  AddressNotifier({required AddressRepository repository})
      : _repository = repository,
        super(const AsyncValue.data(null)) {
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.fetchAddresses();
      if (mounted) {
        state = AsyncValue.data(response);
      }
    } catch (e) {
      if (mounted) {
        state = AsyncValue.data(const AddressResponse(
          perPage: 0,
          pageNo: 0,
          sortBy: '',
          sortDirection: '',
          content: [],
          count: 0,
        ));
      }
    }
  }

  Future<void> addAddress({
    required String addressLine1,
    required String addressLine2,
    required String landmark,
    required String city,
    required String state1,
    required String pincode,
    required String addressName,
    required bool primaryAddress,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _repository.addAddress(
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        landmark: landmark,
        city: city,
        state1: state1,
        pincode: pincode,
        addressName: addressName,
        primaryAddress: primaryAddress,
      );
      await _fetchAddresses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw e; // Re-throw to handle in UI
    }
  }
}
