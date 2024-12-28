class Address {
  final String id;
  final String type;
  final String fullAddress;

  const Address({
    required this.id,
    required this.type,
    required this.fullAddress,
  });

  Address copyWith({
    String? id,
    String? type,
    String? fullAddress,
  }) {
    return Address(
      id: id ?? this.id,
      type: type ?? this.type,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}
