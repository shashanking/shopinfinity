class DeliveryAddress {
  final String id;
  final String landmark;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String label;
  final bool isPrimary;

  DeliveryAddress({
    required this.id,
    required this.landmark,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.label,
    this.isPrimary = false,
  });

  DeliveryAddress copyWith({
    String? id,
    String? landmark,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? label,
    bool? isPrimary,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      landmark: landmark ?? this.landmark,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
