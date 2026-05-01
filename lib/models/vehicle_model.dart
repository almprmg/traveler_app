import 'package:traveler_app/models/name.dart';

class Vehicle {
  String? id;
  String? name;
  String? code;
  Generic? brand;
  Generic? model;
  Generic? type;
  Generic? bodyStyle;
  String? chassisNumber;
  Map<String, String>? licencePlateNumber;
  int? year;
  double? km;
  String? icon;

  Vehicle({
    this.id,
    this.name,
    this.code,
    this.brand,
    this.model,
    this.type,
    this.bodyStyle,
    this.chassisNumber,
    this.licencePlateNumber,
    this.year,
    this.km,
    this.icon,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["_id"],
      name: json["name"]?.toString(),
      code: json["code"],
      brand: json["brand"] != null ? Generic.fromJson(json["brand"]) : null,
      model: json["model"] != null ? Generic.fromJson(json["model"]) : null,
      type: json["type"] != null ? Generic.fromJson(json["type"]) : null,
      bodyStyle: json["bodyStyle"] != null ? Generic.fromJson(json["bodyStyle"]) : null,
      chassisNumber: json["chassisNumber"]?.toString(),
      licencePlateNumber: json['licencePlateNumber'] != null
          ? Map<String, String>.from(json['licencePlateNumber'])
          : null,
      year: json["year"] is int ? json["year"] : int.tryParse(json["year"]?.toString() ?? ''),
      km: json['km'] is num ? (json['km'] as num).toDouble() : double.tryParse(json['km']?.toString() ?? '0.0'),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name ?? "",
      "code": code,
      "brand": brand?.toJson(),
      "model": model?.toJson(),
      "type": type?.toJson(),
      "chassisNumber": chassisNumber,
      "licencePlateNumber": licencePlateNumber ?? '',
      "year": year,
      "km": km ?? 0.0,
      "isAddNewDriver": true,
      "mainDriver": {
        "username": "",
        "email": "",
        "mobileNumber": "",
        "password": "",
        "licenceNumber": "",
        "licenceExpiry": "",
        "code": 0
      }
    };
  }
}

class Generic {
  String? id;
  NameModel? name;
  String? icon;
  String? code;

  Generic({this.id, this.name, this.icon, this.code});

  factory Generic.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Generic();
    return Generic(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,
      icon: (json['icon'] ?? json['thumbnail'])?.toString(),
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name?.toJson(),
      "code": code,
      "icon": icon,
    };
  }
}

class BodyStyle {
  String? id;
  String? thumbnail;
  NameModel? name;
  String? code;

  BodyStyle({this.id, this.thumbnail, this.name, this.code});

  factory BodyStyle.fromJson(Map<String, dynamic> json) {
    return BodyStyle(
      id: json["_id"],
      thumbnail: json["thumbnail"],
      name: json["name"] != null ? NameModel.fromJson(json["name"]) : null,
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "thumbnail": thumbnail,
    "name": name?.toJson(),
    "code": code
  };
}
