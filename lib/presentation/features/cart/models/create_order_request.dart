class CreateOrderRequest {
  final String paymentId;
  final List<BoughtProductDetails> boughtProductDetailsList;
  final ShippingInfo shippingInfo;
  final String paymentMode;

  CreateOrderRequest({
    required this.paymentId,
    required this.boughtProductDetailsList,
    required this.shippingInfo,
    required this.paymentMode,
  });

  Map<String, dynamic> toJson() => {
        'paymentId': paymentId,
        'boughtProductDetailsList': boughtProductDetailsList.map((x) => x.toJson()).toList(),
        'shippingInfo': shippingInfo.toJson(),
        'paymentMode': paymentMode,
      };
}

class BoughtProductDetails {
  final String varietyId;
  final int boughtQuantity;

  BoughtProductDetails({
    required this.varietyId,
    required this.boughtQuantity,
  });

  Map<String, dynamic> toJson() => {
        'varietyId': varietyId,
        'boughtQuantity': boughtQuantity,
      };
}

class ShippingInfo {
  final String id;

  ShippingInfo({required this.id});

  Map<String, dynamic> toJson() => {'id': id};
}
