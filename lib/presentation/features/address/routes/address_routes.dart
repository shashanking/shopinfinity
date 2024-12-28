import 'package:go_router/go_router.dart';
import '../../cart/models/delivery_address.dart';
import '../screens/saved_addresses_screen.dart';
import '../../cart/overlays/add_address_overlay.dart';

final addressRoutes = [
  GoRoute(
    path: '/addresses',
    builder: (context, state) => const SavedAddressesScreen(),
    routes: [
      GoRoute(
        path: 'add',
        builder: (context, state) => const AddAddressOverlay(),
      ),
      GoRoute(
        path: 'edit/:id',
        builder: (context, state) {
          final address = state.extra as DeliveryAddress;
          return AddAddressOverlay(address: address);
        },
      ),
    ],
  ),
];
