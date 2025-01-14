import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@freezed
class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required int perPage,
    required int pageNo,
    required String sortBy,
    required String sortDirection,
    required List<Order> content,
    required int count,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String paymentId,
    required List<OrderItem> boughtProductDetailsList,
    required double totalItemCost,
    required double deliveryCharges,
    required double totalCost,
    required String orderStatus,
    required DateTime createdAt,
    required DateTime paidDate,
    required UserDetails userDetailsDto,
    required ShippingInfo shippingInfo,
    required String paymentMode,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
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
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required String id,
    required String name,
    required String email,
    required String primaryPhoneNo,
    required String secondaryPhoneNo,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

@freezed
class ShippingInfo with _$ShippingInfo {
  const factory ShippingInfo({
    required String id,
    required String landmark,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String pincode,
    required String addressName,
    required bool primaryAddress,
  }) = _ShippingInfo;

  factory ShippingInfo.fromJson(Map<String, dynamic> json) =>
      _$ShippingInfoFromJson(json);
}
