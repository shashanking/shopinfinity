import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product/product.dart';
import '../../../../core/providers/providers.dart';

final productProvider = FutureProvider.family<Product, String>((ref, id) async {
  final productService = ref.read(productServiceProvider);
  return await productService.getProduct(id);
});
