import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Core product model that represents a product from the API
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String code,
    required String category,
    required String subCategory,
    @JsonKey(name: 'subCategory2') String? subCategory2,
    required String description,
    String? brand,
    @JsonKey(name: 'varietyList') required List<ProductVariety> varieties,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

/// Represents a product variety with pricing and inventory details
@freezed
class ProductVariety with _$ProductVariety {
  const factory ProductVariety({
    required String id,
    required String type,
    required String value,
    required String unit,
    required String description,
    required double price,
    required double discountPercent,
    required double discountPrice,
    required int quantity,
    required String productId,
    @JsonKey(name: 'documentUrls') required List<String> imageUrls,
  }) = _ProductVariety;

  factory ProductVariety.fromJson(Map<String, dynamic> json) =>
      _$ProductVarietyFromJson(json);
}

/// Response model for paginated product list
@freezed
class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    /// List of products in the current page
    required List<Product> content,
    /// Total number of pages
    @Default(1) int totalPages,
    /// Total number of products
    @Default(0) int totalElements,
    /// Whether the current page is the last page
    @Default(true) bool isLastPage,
    /// Current page number
    @Default(0) int pageNumber,
    /// Number of products per page
    @Default(10) int pageSize,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);
}
