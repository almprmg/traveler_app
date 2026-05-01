import 'package:traveler_app/models/cart.dart';

class OrderModel extends CartModel {
  final String? status;
  final int? orderNumber;
  final String? id;
  final Payment? payment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? individualInvoice;

  OrderModel({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.individualInvoice,
    super.cartId,
    super.items,
    super.customer,
    super.customerAddress,
    super.deliveryType,
    super.deliveryTypes,
    super.paymentMethod,
    super.discount,
    super.paidFromCustomerBalance,
    super.remainingAmount,
    super.tax,
    super.taxPercentage,
    super.total,
    super.totalDeliveryFee,
    super.totalPreDiscount,
    super.tamara,
    super.notes,
    super.paymentSuccessUrl,
    super.paymentFailureUrl,
    super.paymentCancelUrl,
    super.paymentDefaultUrl,
    super.coupon,
    this.payment,
    this.orderNumber,
  });

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is Map) {
      final inner = value[r'$date'];
      if (inner != null) return _parseDate(inner);
    }
    return DateTime.tryParse(value.toString());
  }

  static DateTime? _lastStatusTime(dynamic history) {
    if (history is! List || history.isEmpty) return null;
    final last = history.last;
    if (last is Map) return _parseDate(last['timeStamp'] ?? last['timestamp']);
    return null;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final cart = CartModel.fromJson(json);
    return OrderModel(
      status: json['status'] as String?,
      orderNumber: json['orderNumber'] as int?,
      id: json['_id'] as String?,
      createdAt: _parseDate(
        json['createdTime'] ?? json['createdAt'] ?? json['date'],
      ),
      updatedAt:
          _lastStatusTime(json['statusHistory']) ??
          _parseDate(json['updatedAt'] ?? json['updatedTime']),
      payment: json['payment'] != null
          ? Payment.fromJson(json['payment'])
          : null,
      individualInvoice: json['individualInvoice'] as String?,
      cartId: cart.cartId,
      items: cart.items,
      customer: cart.customer,
      customerAddress: cart.customerAddress,
      deliveryType: cart.deliveryType,
      deliveryTypes: cart.deliveryTypes,
      paymentMethod: cart.paymentMethod,
      discount: cart.discount,
      paidFromCustomerBalance: cart.paidFromCustomerBalance,
      remainingAmount: cart.remainingAmount,
      tax: cart.tax,
      taxPercentage: cart.taxPercentage,
      total: cart.total,
      totalDeliveryFee: cart.totalDeliveryFee,
      totalPreDiscount: cart.totalPreDiscount,
      tamara: cart.tamara,
      notes: cart.notes,
      paymentSuccessUrl: cart.paymentSuccessUrl,
      paymentFailureUrl: cart.paymentFailureUrl,
      paymentCancelUrl: cart.paymentCancelUrl,
      paymentDefaultUrl: cart.paymentDefaultUrl,
      coupon: cart.coupon,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['status'] = status;
    data['orderNumber'] = orderNumber;
    data['_id'] = id;
    data['payment'] = payment?.toJson();
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['individualInvoice'] = individualInvoice;
    return data;
  }
}

class Payment {
  String? paymentRedirectUrl;

  Payment({this.paymentRedirectUrl});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(paymentRedirectUrl: json['paymentRedirectUrl'] as String?);
  }
  Map<String, dynamic> toJson() {
    return {'paymentRedirectUrl': paymentRedirectUrl};
  }
}
