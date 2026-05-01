import 'package:traveler_app/models/name.dart';
import 'package:traveler_app/util/extensions.dart';

class Country {
  final String id;
  final NameModel name;
  final String code;

  Country({required this.id, required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['_id'] ?? '',
      name: NameModel.fromJson(json['name'] ?? {}),
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name.toJson(), 'code': code};
  }
}

class Area {
  final String id;
  final Country? country;
  final NameModel name;
  final String? code;

  Area({required this.id, this.country, required this.name, this.code});

  factory Area.fromJson(Map<String, dynamic> json) {
    Country? parsedCountry;
    final rawCountry = json['country'];

    if (rawCountry != null) {
      if (rawCountry is Map<String, dynamic>) {
        parsedCountry = Country.fromJson(rawCountry);
      } else if (rawCountry is String) {
        parsedCountry = Country(
          id: rawCountry,
          name: NameModel(en: null, ar: null),
          code: '',
        );
      }
    }

    return Area(
      id: json['_id'] ?? '',
      country: parsedCountry,
      name: NameModel.fromJson(json['name'] ?? {}),
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (country != null) 'country': country!.toJson(),
      'name': name.toJson(),
      if (code != null) 'code': code,
    };
  }
}

class City {
  final String id;
  final Country? country;
  final Area? area;
  final NameModel name;
  final String? code;
  final Coordinates? coordinates;

  City({
    required this.id,
    this.country,
    this.area,
    required this.name,
    this.code,
    this.coordinates,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    Country? parsedCountry;
    final rawCountry = json['country'];

    if (rawCountry != null) {
      if (rawCountry is Map<String, dynamic>) {
        parsedCountry = Country.fromJson(rawCountry);
      } else if (rawCountry is String) {
        parsedCountry = Country(
          id: rawCountry,
          name: NameModel(en: null, ar: null),
          code: '',
        );
      }
    }

    Area? parsedArea;
    final rawArea = json['area'];

    if (rawArea != null) {
      if (rawArea is Map<String, dynamic>) {
        parsedArea = Area.fromJson(rawArea);
      } else if (rawArea is String) {
        parsedArea = Area(
          id: rawArea,
          country: null,
          name: NameModel(en: null, ar: null),
          code: '',
        );
      }
    }

    return City(
      id: json['_id'] ?? '',
      country: parsedCountry,
      area: parsedArea,
      name: NameModel.fromJson(json['name'] ?? {}),
      code: json['code'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (country != null) 'country': country!.toJson(),
      if (area != null) 'area': area!.toJson(),
      'name': name.toJson(),
      if (code != null) 'code': code,
      if (coordinates != null) 'coordinates': coordinates!.toJson(),
    };
  }
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

class Address {
  final String? id;
  final String? name;
  final Country? country;
  final Area? area;
  final City? city;
  final String? street;
  final int? floor;
  final int? flatNumber;
  final String? address;
  final String? building;
  final Coordinates? coordinates;
  final bool isDefaultAddress;

  Address({
    this.id,
    this.name,
    this.country,
    this.area,
    this.city,
    this.street,
    this.floor,
    this.flatNumber,
    this.address,
    this.building,
    this.coordinates,
    this.isDefaultAddress = false,
  });

  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Address();

    return Address(
      id: json['_id'],
      name: json['name'],
      country: json['country'] != null
          ? Country.fromJson(json['country'])
          : null,
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      street: json['street'],
      floor: json['floor'],
      flatNumber: json['flatNumber'],
      address: json['address'],
      building: json['building'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      isDefaultAddress: json['isDefaultAddress'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country': country?.toJson(),
      'area': area?.toJson(),
      'city': city?.toJson(),
      'street': street,
      'floor': floor,
      'flatNumber': flatNumber,
      'address': address,
      'building': building,
      'coordinates': coordinates?.toJson(),
      'isDefaultAddress': isDefaultAddress,
    }.removeNulls();
  }

  // copyWith لدعم تعديل isDefaultAddress مع الحفاظ على immutability
  Address copyWith({bool? isDefaultAddress}) {
    return Address(
      id: id,
      name: name,
      country: country,
      area: area,
      city: city,
      street: street,
      floor: floor,
      flatNumber: flatNumber,
      address: address,
      building: building,
      coordinates: coordinates,
      isDefaultAddress: isDefaultAddress ?? this.isDefaultAddress,
    );
  }

  String get fullAddress =>
      '${country?.name.en ?? ''} ${area?.name.en ?? ''} ${city?.name.en ?? ''} ${street ?? ''} ${floor ?? ''} ${flatNumber ?? ''} ${address ?? ''} ${building ?? ''}';
}
