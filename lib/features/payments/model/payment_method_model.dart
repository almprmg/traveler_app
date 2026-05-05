class PaymentMethod {
  final String key;
  final String displayName;
  final String? iconUrl;

  PaymentMethod({
    required this.key,
    required this.displayName,
    this.iconUrl,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        key: json['key']?.toString() ?? '',
        displayName: json['display_name']?.toString() ?? '',
        iconUrl: json['icon_url']?.toString(),
      );
}

class PaymentInitiation {
  final String orderId;
  final String orderNumber;
  final double amount;
  final String? clientSecret;
  final String? publicKey;
  final String paymentUrl;
  final String? methodKey;

  PaymentInitiation({
    required this.orderId,
    required this.orderNumber,
    required this.amount,
    required this.paymentUrl,
    this.clientSecret,
    this.publicKey,
    this.methodKey,
  });

  factory PaymentInitiation.fromJson(Map<String, dynamic> json) =>
      PaymentInitiation(
        orderId: json['order_id']?.toString() ?? '',
        orderNumber: json['order_number']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        clientSecret: json['client_secret']?.toString(),
        publicKey: json['public_key']?.toString(),
        paymentUrl: json['payment_url']?.toString() ?? '',
        methodKey: json['method_key']?.toString(),
      );
}
