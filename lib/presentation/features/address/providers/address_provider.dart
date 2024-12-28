import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address.dart';

final addressListProvider = StateNotifierProvider<AddressNotifier, List<Address>>((ref) {
  return AddressNotifier();
});

class AddressNotifier extends StateNotifier<List<Address>> {
  AddressNotifier()
      : super([
          const Address(
            id: '1',
            type: 'Primary',
            fullAddress: 'Lorem ipsum dolor sit amet consectetur. Et at lectus congue...',
          ),
          const Address(
            id: '2',
            type: 'Secondary',
            fullAddress: 'Lorem ipsum dolor sit amet consectetur. Et at lectus congue...',
          ),
          const Address(
            id: '3',
            type: 'Other',
            fullAddress: 'Lorem ipsum dolor sit amet consectetur. Et at lectus congue...',
          ),
        ]);

  void addAddress(Address address) {
    state = [...state, address];
  }

  void removeAddress(String id) {
    state = state.where((address) => address.id != id).toList();
  }

  void editAddress(Address address) {
    state = state.map((a) => a.id == address.id ? address : a).toList();
  }
}
