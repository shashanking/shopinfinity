import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/delivery_address.dart';

class AddressNotifier extends StateNotifier<List<DeliveryAddress>> {
  AddressNotifier() : super([]);

  void addAddress(DeliveryAddress address) {
    if (state.isEmpty) {
      state = [...state, address.copyWith(isPrimary: true)];
    } else {
      state = [...state, address];
    }
  }

  void removeAddress(String id) {
    state = state.where((address) => address.id != id).toList();
  }

  void setPrimaryAddress(String id) {
    state = state.map((address) {
      if (address.id == id) {
        return address.copyWith(isPrimary: true);
      }
      return address.copyWith(isPrimary: false);
    }).toList();
  }

  void updateAddress(DeliveryAddress updatedAddress) {
    state = state.map((address) {
      if (address.id == updatedAddress.id) {
        return updatedAddress;
      }
      return address;
    }).toList();
  }

  DeliveryAddress? getPrimaryAddress() {
    try {
      return state.firstWhere((address) => address.isPrimary);
    } catch (e) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<DeliveryAddress>>(
  (ref) => AddressNotifier(),
);
