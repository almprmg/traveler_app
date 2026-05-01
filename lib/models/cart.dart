import 'package:traveler_app/models/vehicle_model.dart';
import 'package:traveler_app/models/customer.dart';
import 'package:traveler_app/models/tamara.dart';
import 'package:traveler_app/models/location.dart';
import 'package:traveler_app/models/payment_method.dart';
import 'package:traveler_app/models/product.dart';
import 'package:traveler_app/util/app_constants.dart';

class CartModel {
  final String? cartId;
  final List<CartItem>? items;
  final Customer? customer;
  final Address? customerAddress;
  final DeliveryType? deliveryType;
  final List<DeliveryType>? deliveryTypes;
  final PaymentMethod? paymentMethod;
  final double? amountFromQitafPointsInSAR;
  final double? discount,
      paidFromCustomerBalance,
      remainingAmount,
      tax,
      taxPercentage,
      total,
      totalDeliveryFee,
      totalPreDiscount,
      paidFromCustomerPointsSAR;
  final int? amountFromCustomerPoints;
  final Tamara? tamara;
  final String? notes;
  final Vehicle? customerVehicle;
  final String? paymentSuccessUrl;
  final String? paymentFailureUrl;
  final String? paymentCancelUrl;
  final String? paymentDefaultUrl;
  final ProductCoupon? coupon;

  CartModel({
    this.cartId,
    this.items,
    this.customerAddress,
    this.deliveryType,
    this.deliveryTypes,
    this.paymentMethod,
    this.amountFromQitafPointsInSAR,
    this.discount,
    this.paidFromCustomerBalance,
    this.paidFromCustomerPointsSAR,
    this.amountFromCustomerPoints,
    this.remainingAmount,
    this.tax,
    this.taxPercentage,
    this.total,
    this.totalDeliveryFee,
    this.totalPreDiscount,
    this.notes,
    this.tamara,
    this.customerVehicle,
    this.paymentSuccessUrl,
    this.paymentFailureUrl,
    this.paymentCancelUrl,
    this.paymentDefaultUrl,
    this.customer,
    this.coupon,
  });

  CartItem? get item => items?.isNotEmpty == true ? items!.first : null;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] as String?,
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
                .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : (json['item'] != null ? [CartItem.fromJson(json['item'])] : null),
      customerAddress: json['customerAddress'] != null
          ? Address.fromJson(json['customerAddress'])
          : null,
      deliveryType: json['deliveryType'] != null
          ? DeliveryType.fromJson(json['deliveryType'])
          : null,
      deliveryTypes: json['deliveryTypes'] != null
          ? (json['deliveryTypes'] as List<dynamic>)
                .map((e) => DeliveryType.fromJson(e))
                .toList()
          : null,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      paidFromCustomerPointsSAR: json['paidFromCustomerPointsSAR'] != null
          ? (json['paidFromCustomerPointsSAR'] as num?)?.toDouble()
          : null,
      amountFromCustomerPoints: json['amountFromCustomerPoints'] != null
          ? (json['amountFromCustomerPoints'] as num?)?.toInt()
          : null,
      amountFromQitafPointsInSAR: json['amountFromQitafPointsInSAR'] != null
          ? (json['amountFromQitafPointsInSAR'] as num?)?.toDouble()
          : null,
      discount: (json['discount'] as num?)?.toDouble(),
      paidFromCustomerBalance:
          (json['paidFromCustomerBalance'] as num?)?.toDouble(),
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      totalDeliveryFee: (json['totalDeliveryFee'] as num?)?.toDouble(),
      totalPreDiscount: (json['totalPreDiscount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      tamara: json['tamara'] != null ? Tamara.fromJson(json['tamara']) : null,
      paymentSuccessUrl: json['paymentSuccessUrl'] as String?,
      paymentFailureUrl: json['paymentFailureUrl'] as String?,
      paymentCancelUrl: json['paymentCancelUrl'] as String?,
      paymentDefaultUrl: json['paymentDefaultUrl'] as String?,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      coupon: json['coupon'] != null
          ? ProductCoupon.fromJson(json['coupon'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'item': item?.toJson(),
      'items': items?.map((e) => e.toJson()).toList(),
      'customerAddress': customerAddress?.toJson(),
      'deliveryType': deliveryType?.toJson(),
      'deliveryTypes': deliveryTypes?.map((e) => e.toJson()).toList(),
      'paymentMethod': paymentMethod?.toJson(),
      'discount': discount,
      'paidFromCustomerBalance': paidFromCustomerBalance,
      'remainingAmount': remainingAmount,
      'amountFromQitafPointsInSAR': amountFromQitafPointsInSAR,
      'tax': tax,
      'taxPercentage': taxPercentage,
      'total': total,
      'totalDeliveryFee': totalDeliveryFee,
      'totalPreDiscount': totalPreDiscount,
      'notes': notes,
      'customerVehicle': customerVehicle?.toJson(),
      'paymentSuccessUrl': paymentSuccessUrl ?? AppConstants.paymentSuccessUrl,
      'paymentFailureUrl': paymentFailureUrl ?? AppConstants.paymentFailureUrl,
      'paymentCancelUrl': paymentCancelUrl ?? AppConstants.paymentCancelUrl,
      'paymentDefaultUrl': paymentDefaultUrl ?? AppConstants.paymentDefaultUrl,
      'tamara': tamara?.toJson(),
      'customer': customer?.toJson(),
      'coupon': coupon?.toJson(),
    };
  }

  CartModel copyWith({
    String? cartId,
    List<CartItem>? items,
    Customer? customer,
    Address? customerAddress,
    DeliveryType? deliveryType,
    List<DeliveryType>? deliveryTypes,
    PaymentMethod? paymentMethod,
    double? discount,
    double? paidFromCustomerBalance,
    double? remainingAmount,
    double? tax,
    double? taxPercentage,
    double? total,
    double? totalDeliveryFee,
    double? totalPreDiscount,
    Tamara? tamara,
    String? notes,
    String? paymentSuccessUrl,
    String? paymentFailureUrl,
    String? paymentCancelUrl,
    String? paymentDefaultUrl,
    ProductCoupon? coupon,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      items: items ?? this.items,
      customer: customer ?? this.customer,
      customerAddress: customerAddress ?? this.customerAddress,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryTypes: deliveryTypes ?? this.deliveryTypes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discount: discount ?? this.discount,
      paidFromCustomerBalance:
          paidFromCustomerBalance ?? this.paidFromCustomerBalance,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      tax: tax ?? this.tax,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      total: total ?? this.total,
      totalDeliveryFee: totalDeliveryFee ?? this.totalDeliveryFee,
      totalPreDiscount: totalPreDiscount ?? this.totalPreDiscount,
      tamara: tamara ?? this.tamara,
      notes: notes ?? this.notes,
      paymentSuccessUrl: paymentSuccessUrl ?? this.paymentSuccessUrl,
      paymentFailureUrl: paymentFailureUrl ?? this.paymentFailureUrl,
      paymentCancelUrl: paymentCancelUrl ?? this.paymentCancelUrl,
      paymentDefaultUrl: paymentDefaultUrl ?? this.paymentDefaultUrl,
    );
  }
}

class CartItem {
  final String? id;
  final ProductModel? product;
  final int? quantity;
  final DeliveryType? deliveryType;
  final bool? fromCustomerProductsBalance;
  final PriceOptionModel? selectedProductPriceOption;
  final ProductPriceListModel? selectedProductPriceList;
  final bool? isDiscountFreeReward;

  CartItem({
    this.id,
    this.product,
    this.quantity,
    this.deliveryType,
    this.fromCustomerProductsBalance,
    this.selectedProductPriceOption,
    this.selectedProductPriceList,
    this.isDiscountFreeReward,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] as String?,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      quantity: json['quantity'] as int?,
      deliveryType: json['deliveryType'] != null
          ? DeliveryType.fromJson(json['deliveryType'])
          : null,
      fromCustomerProductsBalance: json['fromCustomerProductsBalance'] as bool?,
      selectedProductPriceOption: json['selectedProductPriceOption'] != null
          ? PriceOptionModel.fromJson(json['selectedProductPriceOption'])
          : null,
      selectedProductPriceList: json['selectedProductPriceList'] != null
          ? ProductPriceListModel.fromJson(json['selectedProductPriceList'])
          : null,
      isDiscountFreeReward: json['isDiscountFreeReward'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': product?.toJson(),
      'quantity': quantity,
      'deliveryType': deliveryType?.toJson(),
      'fromCustomerProductsBalance': fromCustomerProductsBalance,
      'selectedProductPriceOption': selectedProductPriceOption?.toJson(),
      'selectedProductPriceList': selectedProductPriceList?.toJson(),
      'isDiscountFreeReward': isDiscountFreeReward,
    };
  }
}

class AddItemToCartRequest {
  final String? cartId;
  final CartItem? item;
  final Address? customerAddress;
  final DeliveryType? deliveryType;
  final Customer? customer;
  final String? notes;

  AddItemToCartRequest({
    this.cartId,
    this.item,
    this.customerAddress,
    this.deliveryType,
    this.customer,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'item': item?.toJson(),
      'customerAddress': customerAddress?.toJson(),
      'deliveryType': deliveryType?.toJson(),
      'customer': customer?.toJson(),
      'notes': notes,
    };
  }
}

class ProductCoupon {
  final String? id;
  final String? name;

  ProductCoupon({this.name, this.id});

  factory ProductCoupon.fromJson(Map<String, dynamic> json) {
    return ProductCoupon(
      name: json['name'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, '_id': id};
  }
}
