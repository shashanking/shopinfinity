import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

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

@HiveType(typeId: 1)
class UserDetails {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? primaryPhoneNo;
  @HiveField(4)
  final String? secondaryPhoneNo;
  @HiveField(5)
  final String? role;
  @HiveField(6)
  final bool? isActive;
  @HiveField(7)
  final String? createdAt;
  @HiveField(8)
  final String? updatedAt;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.primaryPhoneNo,
    this.secondaryPhoneNo,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json['id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        primaryPhoneNo: json['primaryPhoneNo'] as String?,
        secondaryPhoneNo: json['secondaryPhoneNo'] as String?,
        role: json['role'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'primaryPhoneNo': primaryPhoneNo,
        'secondaryPhoneNo': secondaryPhoneNo,
        'role': role,
        'isActive': isActive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

int _statusCodeFromJson(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.parse(value);
  throw ArgumentError('Invalid status code value: $value');
}
