import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String code,
    required String category,
    required String subCategory,
    required String description,
    @JsonKey(name: 'varietyList') required List<ProductVariety> varieties,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

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

@freezed
class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    required int perPage,
    required int pageNo,
    required String sortBy,
    required String sortDirection,
    required List<Product> content,
    required int count,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);
}
