import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/cart_response.dart';
import '../repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CartRepository(dio: dio);
});

// Track loading state for individual products
final productLoadingProvider = StateProvider.family<bool, String>((ref, id) => false);

final cartProvider = AsyncNotifierProvider<CartNotifier, CartResponse?>(() {
  return CartNotifier();
});

class CartNotifier extends AsyncNotifier<CartResponse?> {
  @override
  Future<CartResponse?> build() async {
    return _fetchCart();
  }

  Future<CartResponse?> _fetchCart() async {
    try {
      final repository = ref.read(cartRepositoryProvider);
      final response = await repository.fetchCart();
      return response;
    } catch (e) {
      // Return empty cart instead of null
      return const CartResponse(
        id: '',
        boughtProductDetailsList: [],
        userDetailsDto: UserDetails(
          id: '',
          name: '',
          email: '',
          primaryPhoneNo: '',
          secondaryPhoneNo: '',
        ),
      );
    }
  }

  Future<void> updateCart({
    required String varietyId,
    required int quantity,
  }) async {
    try {
      // Set loading state for this specific product
      ref.read(productLoadingProvider(varietyId).notifier).state = true;
      
      final repository = ref.read(cartRepositoryProvider);
      final response = await repository.updateCart(
        varietyId: varietyId,
        quantity: quantity,
      );
      state = AsyncValue.data(response);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      await Future.delayed(const Duration(seconds: 1));
      state = await AsyncValue.guard(() => _fetchCart());
    } finally {
      // Reset loading state for this specific product
      ref.read(productLoadingProvider(varietyId).notifier).state = false;
    }
  }
}
