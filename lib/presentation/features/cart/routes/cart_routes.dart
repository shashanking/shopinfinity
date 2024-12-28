import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/cart_screen.dart';
import '../overlays/add_address_overlay.dart';
import '../screens/cart_checkout_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/order_success_screen.dart';

final cartRoutes = [
  GoRoute(
    path: '/cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/cart/address',
    pageBuilder: (context, state) => const MaterialPage(
      fullscreenDialog: true,
      child: AddAddressOverlay(),
    ),
  ),
  GoRoute(
    path: '/cart/checkout',
    builder: (context, state) => const CartCheckoutScreen(),
  ),
  GoRoute(
    path: '/cart/payment',
    builder: (context, state) => const PaymentScreen(),
  ),
  GoRoute(
    path: '/cart/success',
    builder: (context, state) => const OrderSuccessScreen(),
  ),
];
