import 'package:traveler_app/models/name.dart';

/// Delivery type/method model.
class DeliveryType {
  final String? id;
  final String? code;
  final NameModel? name;
  final NameModel? description;
  final String? icon;
  final bool? selected;
  final List<DeliveryFee>? fees;

  const DeliveryType({
    this.id,
    this.code,
    this.name,
    this.description,
    this.icon,
    this.selected,
    this.fees,
  });

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    return DeliveryType(
      id: json['_id'] as String?,
      code: json['code'] as String?,
      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,
      description: json['description'] != null
          ? NameModel.fromJson(json['description'])
          : null,
      icon: json['icon'] as String?,
      selected: json['selected'] as bool?,
      fees: json['fees'] != null
          ? (json['fees'] as List)
                .map((e) => DeliveryFee.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'name': name?.toJson(),
      'description': description?.toJson(),
      'icon': icon,
      'selected': selected,
      'fees': fees?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Delivery fee configuration.
class DeliveryFee {
  final int? i;
  final int? minQuantity;
  final int? maxQuantity;
  final double? price;
  final double? priceCompany;
  final List<String>? cityIds;
  final List<String>? manufacturerIds;
  final double? minWeight;
  final double? maxWeight;
  final double? minDistance;
  final double? maxDistance;
  final List<dynamic>? manufacturers;

  const DeliveryFee({
    this.i,
    this.minQuantity,
    this.maxQuantity,
    this.price,
    this.priceCompany,
    this.cityIds,
    this.manufacturerIds,
    this.minWeight,
    this.maxWeight,
    this.minDistance,
    this.maxDistance,
    this.manufacturers,
  });

  factory DeliveryFee.fromJson(Map<String, dynamic> json) {
    return DeliveryFee(
      i: json['i'] as int?,
      minQuantity: json['minQuantity'] as int?,
      maxQuantity: json['maxQuantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      priceCompany: (json['priceCompany'] as num?)?.toDouble(),
      cityIds: json['cityIds'] != null
          ? List<String>.from(json['cityIds'] as List)
          : null,
      manufacturerIds: json['manufacturerIds'] != null
          ? List<String>.from(json['manufacturerIds'] as List)
          : null,
      minWeight: (json['minWeight'] as num?)?.toDouble(),
      maxWeight: (json['maxWeight'] as num?)?.toDouble(),
      minDistance: (json['minDistance'] as num?)?.toDouble(),
      maxDistance: (json['maxDistance'] as num?)?.toDouble(),
      manufacturers: json['manufacturers'] as List?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'i': i,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'price': price,
      'priceCompany': priceCompany,
      'cityIds': cityIds,
      'manufacturerIds': manufacturerIds,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'minDistance': minDistance,
      'maxDistance': maxDistance,
      'manufacturers': manufacturers,
    };
  }
}
