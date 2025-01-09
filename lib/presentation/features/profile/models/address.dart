import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class AddressResponse with _$AddressResponse {
  const factory AddressResponse({
    required int perPage,
    required int pageNo,
    required String sortBy,
    required String sortDirection,
    required List<Address> content,
    required int count,
  }) = _AddressResponse;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    required String addressLine1,
    required String addressLine2,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String addressName,
    required bool primaryAddress,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
