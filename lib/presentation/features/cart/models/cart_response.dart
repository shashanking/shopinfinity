import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_response.freezed.dart';
part 'cart_response.g.dart';

@freezed
class CartResponse with _$CartResponse {
  const factory CartResponse({
    required String id,
    required List<BoughtProductDetails> boughtProductDetailsList,
    required UserDetails userDetailsDto,
  }) = _CartResponse;

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);
}

@freezed
class BoughtProductDetails with _$BoughtProductDetails {
  const factory BoughtProductDetails({
    required String varietyId,
    required String name,
    required double price,
    required double discountPercent,
    required double discountedPrice,
    required int boughtQuantity,
    required String value,
    required String unit,
    required double boughtPrice,
    required double savings,
    required List<String> documents,
  }) = _BoughtProductDetails;

  factory BoughtProductDetails.fromJson(Map<String, dynamic> json) =>
      _$BoughtProductDetailsFromJson(json);
}

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required String id,
    required String name,
    required String email,
    required String primaryPhoneNo,
    String? secondaryPhoneNo,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}
