import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier()
    : super([
        // Adding dummy data
        const CartItem(
          id: '1',
          name: 'Cadbury Bournville Rich Cocoa 70% Dark',
          imageUrl:
              'assets/images/chocolate.png', // Make sure this image exists in assets
          price: 42,
          originalPrice: 58,
          weight: '200g',
          quantity: 1,
        ),
        const CartItem(
          id: '2',
          name: 'Cadbury Bournville Rich Cocoa 70% Dark',
          imageUrl: 'assets/images/chocolate.png',
          price: 42,
          originalPrice: 58,
          weight: '200g',
          quantity: 1,
        ),
        const CartItem(
          id: '3',
          name: 'Cadbury Bournville Rich Cocoa 70% Dark',
          imageUrl: 'assets/images/chocolate.png',
          price: 42,
          originalPrice: 58,
          weight: '200g',
          quantity: 1,
        ),
      ]);

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        item.copyWith(quantity: state[existingIndex].quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void incrementQuantity(String id) {
    state =
        state.map((item) {
          if (item.id == id) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();
  }

  void decrementQuantity(String id) {
    state =
        state.map((item) {
          if (item.id == id) {
            if (item.quantity > 1) {
              return item.copyWith(quantity: item.quantity - 1);
            }
            return item;
          }
          return item;
        }).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
