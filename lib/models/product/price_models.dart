import 'package:traveler_app/models/name.dart';

import 'delivery_models.dart';

/// Price list metadata.
class PriceListModel {
  final String? id;
  final NameModel? name;
  final int? number;
  final String? numberStr;

  const PriceListModel({this.id, this.name, this.number, this.numberStr});

  factory PriceListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PriceListModel();
    return PriceListModel(
      id: json['_id'] as String?,
      name: NameModel.fromJson(json['name']),
      number: json['number'] as int?,
      numberStr: json['numberStr'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name?.toJson(),
      'number': number,
      'numberStr': numberStr,
    };
  }
}

/// Product's price list with options and delivery types.
class ProductPriceListModel {
  final PriceListModel? priceList;
  final bool? isGeneral;
  final bool? forCustomers;
  final bool? forCompanies;
  final int? quantity;
  final NameModel? description;
  final List<PriceOptionModel>? priceOption;
  final List<DeliveryType>? deliveryTypes;

  const ProductPriceListModel({
    this.priceList,
    this.isGeneral,
    this.forCustomers,
    this.forCompanies,
    this.quantity,
    this.description,
    this.priceOption,
    this.deliveryTypes,
  });

  factory ProductPriceListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProductPriceListModel();
    return ProductPriceListModel(
      priceList: PriceListModel.fromJson(
        json['priceList'] as Map<String, dynamic>?,
      ),
      isGeneral: json['isGeneral'] as bool?,
      forCustomers: json['forCustomers'] as bool?,
      forCompanies: json['forCompanies'] as bool?,
      quantity: json['quantity'] as int?,
      description: NameModel.fromJson(json['description']),
      priceOption: (json['priceOption'] as List?)
          ?.map((e) => PriceOptionModel.fromJson(e as Map<String, dynamic>?))
          .toList(),
      deliveryTypes: (json['deliveryTypes'] as List?)
          ?.map((e) => DeliveryType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priceList': priceList?.toJson(),
      'isGeneral': isGeneral,
      'forCustomers': forCustomers,
      'forCompanies': forCompanies,
      'quantity': quantity,
      'description': description?.toJson(),
      'priceOption': priceOption?.map((e) => e.toJson()).toList(),
      'deliveryTypes': deliveryTypes?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Individual price option with quantity ranges and discounts.
class PriceOptionModel {
  final double? price;
  final NameModel? name;
  final int? minQuantity;
  final int? maxQuantity;
  final double? discount;
  final double? discountPercentage;

  const PriceOptionModel({
    this.price,
    this.name,
    this.minQuantity,
    this.maxQuantity,
    this.discount,
    this.discountPercentage,
  });

  factory PriceOptionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PriceOptionModel();
    return PriceOptionModel(
      price: (json['price'] as num?)?.toDouble(),
      name: NameModel.fromJson(json['name']),
      minQuantity: json['minQuantity'] as int?,
      maxQuantity: json['maxQuantity'] as int?,
      discount: (json['discount'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'name': name?.toJson(),
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'discount': discount,
      'discountPercentage': discountPercentage,
    };
  }
}
