import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:developer' as dev;

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@freezed
class OrderListResponse with _$OrderListResponse {
  const factory OrderListResponse({
    required int perPage,
    required int pageNo,
    required String sortBy,
    required String sortDirection,
    required List<OrderResponse> content,
    required int count,
  }) = _OrderListResponse;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);
}

@freezed
class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required String id,
    required String paymentId,
    required List<OrderItem> boughtProductDetailsList,
    required double totalItemCost,
    required double deliveryCharges,
    required double totalCost,
    required String orderStatus,
    @JsonKey(fromJson: _dateFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateFromJson) required DateTime paidDate,
    required UserDetails userDetailsDto,
    required ShippingInfo shippingInfo,
    required String paymentMode,
  }) = _OrderResponse;

  const OrderResponse._();

  String get orderTitle {
    if (boughtProductDetailsList.isEmpty) return 'Empty Order';

    final firstItem = boughtProductDetailsList.first;
    final remainingCount = boughtProductDetailsList.length - 1;

    if (remainingCount == 0) {
      return firstItem.name;
    } else {
      return '${firstItem.name} + $remainingCount';
    }
  }

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

// Helper function to parse date strings
DateTime _dateFromJson(String date) => DateTime.parse(date);

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
    @JsonKey(fromJson: _parseDocuments) required List<String> documents,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

List<String> _parseDocuments(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    return [value];
  }
  return [];
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

@freezed
class ShippingInfo with _$ShippingInfo {
  const factory ShippingInfo({
    required String id,
    required String landmark,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    required String addressName,
    required bool primaryAddress,
  }) = _ShippingInfo;

  factory ShippingInfo.fromJson(Map<String, dynamic> json) =>
      _$ShippingInfoFromJson(json);
}
