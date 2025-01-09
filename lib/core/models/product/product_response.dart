import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_response.freezed.dart';
part 'product_response.g.dart';

@freezed
class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    required List<Product> content,
    required int totalPages,
    required int totalElements,
    required int pageSize,
    required int pageNumber,
    required bool isLastPage,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String documentUrl,
    required double price,
    required double originalPrice,
    required String unit,
    required int discount,
    required String category,
    required String subCategory,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
