import 'package:traveler_app/models/name.dart';

class FitForModel {
  final String? id;
  final VehicleBrand? vehicleBrand;
  final List<VehicleModel>? vehicleModels;

  FitForModel({this.id, this.vehicleBrand, this.vehicleModels});

  factory FitForModel.fromJson(Map<String, dynamic> json) {
    return FitForModel(
      id: json['_id'],
      vehicleBrand: json['vehicleBrand'] != null
          ? VehicleBrand.fromJson(json['vehicleBrand'])
          : null,
      vehicleModels: json['vehicleModels'] != null
          ? (json['vehicleModels'] as List)
                .map((e) => VehicleModel.fromJson(e))
                .toList()
          : null,
    );
  }
}

class VehicleBrand {
  final String? id;
  final NameModel? name;
  final String? icon;
  final List<String>? code;

  VehicleBrand({this.id, this.name, this.icon, this.code});

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
      id: json['_id'],
      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,
      icon: json['icon'],
      code: json['code'] != null ? List<String>.from(json['code']) : null,
    );
  }
}

class VehicleModel {
  final String? id;
  final NameModel? name;
  final List<String>? code;
  final List<int>? years;

  VehicleModel({this.id, this.name, this.code, this.years});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'],
      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,
      code: json['code'] != null ? List<String>.from(json['code']) : null,
      years: json['years'] != null ? List<int>.from(json['years']) : null,
    );
  }
}
