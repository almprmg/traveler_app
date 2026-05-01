import 'package:traveler_app/models/name.dart';

import 'category_models.dart';
import 'manufacturer_model.dart';
import 'price_models.dart';
import 'rate_model.dart';

/// Main product model containing all product information.
class ProductModel {
  final String? id;
  final int? sort;
  final NameModel? name;
  final NameModel? code;
  final NameModel? descriptionShort;
  final NameModel? aboutProduct;
  final bool? isNew;
  final NameModel? isNewLabel;
  final bool? isOnSale;
  final bool? isBestSellers;
  final bool? isBestOffer;
  final NameModel? offerLabel;
  final NameModel? descriptionBody;
  final List<String>? gallery;
  final Rate? rate;
  final ManufacturerModel? manufacturer;
  final CategoryModel? category;
  final List<ProductPriceListModel>? priceLists;
  final String? thumbnail;
  final String? offerLogo;
  final String? width;
  final int? height;
  final int? rim;
  final int? number;
  final String? numberStr;
  final double? averagePrice;

  const ProductModel({
    this.id,
    this.sort,
    this.name,
    this.code,
    this.descriptionShort,
    this.aboutProduct,
    this.isNew,
    this.isNewLabel,
    this.isOnSale,
    this.isBestSellers,
    this.isBestOffer,
    this.offerLabel,
    this.descriptionBody,
    this.manufacturer,
    this.category,
    this.priceLists,
    this.thumbnail,
    this.offerLogo,
    this.width,
    this.height,
    this.rate,
    this.rim,
    this.number,
    this.numberStr,
    this.averagePrice,
    this.gallery,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as String?,
      sort: json['sort'] as int?,
      name: NameModel.fromJson(json['name']),
      code: NameModel.fromJson(json['code']),
      descriptionShort: NameModel.fromJson(json['descriptionShort']),
      aboutProduct: NameModel.fromJson(json['aboutProduct']),
      isNew: json['isNew'] as bool?,
      isNewLabel: json['isNewLabel'] != null
          ? NameModel.fromJson(json['isNewLabel'] as Map<String, dynamic>)
          : null,
      isOnSale: json['isOnSale'] as bool?,
      isBestSellers: json['isBestSellers'] as bool?,
      isBestOffer: json['isBestOffer'] as bool?,
      offerLabel: NameModel.fromJson(json['offerLabel']),
      descriptionBody: NameModel.fromJson(json['descriptionBody']),
      manufacturer: json['manufacturer'] != null
          ? ManufacturerModel.fromJson(
              json['manufacturer'] as Map<String, dynamic>?,
            )
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      priceLists: (json['priceLists'] as List?)
          ?.map(
            (e) => ProductPriceListModel.fromJson(e as Map<String, dynamic>?),
          )
          .toList(),
      thumbnail: json['thumbnail'] as String?,
      offerLogo: json['offerLogo'] as String?,
      width: json['width']?.toString(),
      height: int.tryParse(json['height']?.toString() ?? ''),
      rim: int.tryParse(json['rim']?.toString() ?? ''),
      number: int.tryParse(json['number']?.toString() ?? ''),
      numberStr: json['numberStr'] as String?,
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'] as List)
          : null,
      rate: json['rate'] != null
          ? Rate.fromJson(json['rate'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Get the general price option (first price from general price list).
  PriceOptionModel? get generalPrice {
    if (priceLists == null || priceLists!.isEmpty) return null;

    final generalPriceList = priceLists!
        .where((e) => e.isGeneral == true)
        .firstOrNull;
    if (generalPriceList == null) return null;

    final priceOptions = generalPriceList.priceOption;
    if (priceOptions == null || priceOptions.isEmpty) return null;

    return priceOptions.first;
  }

  /// Get the quantity from the general price list.
  int get quantity {
    if (priceLists == null || priceLists!.isEmpty) return 0;
    final generalPriceList = priceLists!
        .where((e) => e.isGeneral == true)
        .firstOrNull;
    return generalPriceList?.quantity ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sort': sort,
      'name': name?.toJson(),
      'code': code?.toJson(),
      'descriptionShort': descriptionShort?.toJson(),
      'aboutProduct': aboutProduct?.toJson(),
      'isNew': isNew,
      'isOnSale': isOnSale,
      'isBestSellers': isBestSellers,
      'isBestOffer': isBestOffer,
      'offerLabel': offerLabel?.toJson(),
      'descriptionBody': descriptionBody?.toJson(),
      'manufacturer': manufacturer?.toJson(),
      'category': category?.toJson(),
      'priceLists': priceLists?.map((e) => e.toJson()).toList(),
      'thumbnail': thumbnail,
      'offerLogo': offerLogo,
      'width': width,
      'height': height,
      'rim': rim,
      'number': number,
      'numberStr': numberStr,
      'averagePrice': averagePrice,
      'gallery': gallery,
      'rate': rate?.toJson(),
    };
  }
}
