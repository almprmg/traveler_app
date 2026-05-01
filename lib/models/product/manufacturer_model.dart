import 'package:traveler_app/models/name.dart';

/// Product manufacturer/brand model.
class ManufacturerModel {
  final String? id;
  final NameModel? name;
  final String? icon;
  final String? code;
  final int? number;
  final String? numberStr;
  final NameModel? warranty;

  const ManufacturerModel({
    this.id,
    this.name,
    this.icon,
    this.code,
    this.number,
    this.numberStr,
    this.warranty,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ManufacturerModel();
    return ManufacturerModel(
      id: json['_id'] as String?,
      name: NameModel.fromJson(json['name']),
      icon: json['icon'] as String?,
      code: json['code'] as String?,
      number: json['number'] as int?,
      numberStr: json['numberStr'] as String?,
      warranty: NameModel.fromJson(json['warranty']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name?.toJson(),
      'icon': icon,
      'code': code,
      'number': number,
      'numberStr': numberStr,
      'warranty': warranty?.toJson(),
    };
  }
}
