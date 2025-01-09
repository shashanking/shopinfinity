import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_response.freezed.dart';
part 'category_response.g.dart';

@freezed
class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    required int statusCode,
    required String message,
    @JsonKey(name: 'responseBody') required List<Category> categories,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String name,
    required String type,
    required String documentUrl,
    @JsonKey(name: 'subCategoryDtoList') required List<SubCategory> subCategories,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    required String name,
    required String type,
    required String documentUrl,
    @JsonKey(name: 'subCategory2DtoList') required List<SubCategory2> subCategories,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
}

@freezed
class SubCategory2 with _$SubCategory2 {
  const factory SubCategory2({
    required String name,
    required String type,
    required String documentUrl,
  }) = _SubCategory2;

  factory SubCategory2.fromJson(Map<String, dynamic> json) =>
      _$SubCategory2FromJson(json);
}
