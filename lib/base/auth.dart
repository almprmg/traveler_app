import 'package:traveler_app/models/customer.dart';

class AuthModel {
  final String? token;
  final int? tokenExp;
  final String? refreshToken;
  final int? refreshTokenExp;
  final Customer? customer;

  AuthModel({
    this.token,
    this.tokenExp,
    this.refreshToken,
    this.refreshTokenExp,
    this.customer,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      tokenExp: json['tokenExp'],
      refreshToken: json['refreshToken'],
      refreshTokenExp: json['refreshTokenExp'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tokenExp': tokenExp,
      'refreshToken': refreshToken,
      'refreshTokenExp': refreshTokenExp,
      'customer': customer?.toJson(),
    };
  }
}
