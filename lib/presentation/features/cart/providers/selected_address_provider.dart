import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/models/address.dart';
import '../../profile/providers/address_provider.dart';

final selectedAddressProvider = StateNotifierProvider<SelectedAddressNotifier, Address?>((ref) {
  final addressAsync = ref.watch(addressProvider);
  return SelectedAddressNotifier(
    addressAsync.whenOrNull(
      data: (addressData) {
        if (addressData?.content.isEmpty ?? true) return null;
        return addressData!.content.firstWhere(
          (addr) => addr.primaryAddress == true,
          orElse: () => addressData.content.first,
        );
      },
    ),
  );
});

class SelectedAddressNotifier extends StateNotifier<Address?> {
  SelectedAddressNotifier(Address? initialAddress) : super(initialAddress);

  void setSelectedAddress(Address address) {
    state = address;
  }
}
