import 'package:traveler_app/models/name.dart';

class PaymentMethod {
  final String? id;
  final String? type;
  final NameModel? name;
  final String? code;
  final String? icon;
  final bool? forceOnline;
  final NameModel? customerInstructions;
  final int? sort;
  final String? attachment;
  final int? number;
  final String? numberStr;
  final NameModel? beneficiaryName;

  PaymentMethod({
    this.id,
    this.type,
    this.name,
    this.code,
    this.icon,
    this.forceOnline,
    this.customerInstructions,
    this.sort,
    this.attachment,
    this.number,
    this.numberStr,
    this.beneficiaryName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['_id'],
      type: json['type'],
      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,
      code: json['code'],
      icon: json['icon'],
      forceOnline: json['forceOnline'],
      customerInstructions: json['customerInstructions'] != null
          ? NameModel.fromJson(json['customerInstructions'])
          : null,
      sort: json['sort'],
      attachment: json['attachment'],
      number: json['number'],
      numberStr: json['numberStr'],
      beneficiaryName: json['beneficiaryName'] != null
          ? NameModel.fromJson(json['beneficiaryName'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'name': name?.toJson(),
      'code': code,
      'icon': icon,
      'forceOnline': forceOnline,
      'customerInstructions': customerInstructions?.toJson(),
      'sort': sort,
      'attachment': attachment,
      'number': number,
      'numberStr': numberStr,
      'beneficiaryName': beneficiaryName?.toJson(),
    };
  }
}
