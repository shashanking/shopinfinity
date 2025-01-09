import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(fromJson: _statusCodeFromJson) required int statusCode,
    String? errorMessage,
    ResponseBody? responseBody,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class ResponseBody with _$ResponseBody {
  const factory ResponseBody({
    String? token,
    String? message,
    String? status,
    bool? existing,
    UserDetails? userDetails,
  }) = _ResponseBody;

  factory ResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ResponseBodyFromJson(json);
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

int _statusCodeFromJson(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.parse(value);
  throw ArgumentError('Invalid status code value: $value');
}
