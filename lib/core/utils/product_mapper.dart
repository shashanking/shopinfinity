import 'package:shopinfinity/core/models/product/product.dart';

/// Maps a Product model from one format to another
/// This is used to maintain backward compatibility with UI components
/// that expect the old CategoryProduct format
Product mapToUiProduct(Product product) {
  return product.copyWith(
    brand: product.brand ?? 'Unknown',
    subCategory2: product.subCategory2 ?? product.subCategory,
  );
}
