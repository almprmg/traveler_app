import 'package:get/get.dart';
import 'package:traveler_app/controllers/localization_controller.dart';

class TamaraInstalmentModel {
  final String? paymentType;
  final int? instalment;
  final String? descriptionEn;
  final String? descriptionAr;

  TamaraInstalmentModel({
    this.paymentType,
    this.instalment,
    this.descriptionEn,
    this.descriptionAr,
  });

  factory TamaraInstalmentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TamaraInstalmentModel();

    return TamaraInstalmentModel(
      paymentType: json['payment_type'] as String?,
      instalment: json['instalment'] as int?,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_type': paymentType,
      'instalment': instalment,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
    };
  }

  String get description {
    final isLtr = Get.find<LocalizationController>().isLtr;
    return isLtr ? (descriptionEn ?? '') : (descriptionAr ?? '');
  }

  @override
  String toString() =>
      'TamaraInstalmentModel(paymentType: $paymentType, instalment: $instalment, descriptionEn: $descriptionEn, descriptionAr: $descriptionAr)';
}

class Tamara {
  final TamaraInstalmentModel? selectedPaymentOption;

  Tamara({this.selectedPaymentOption});

  factory Tamara.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Tamara();

    return Tamara(
      selectedPaymentOption: json['selectedPaymentOption'] != null
          ? TamaraInstalmentModel.fromJson(json['selectedPaymentOption'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'selectedPaymentOption': selectedPaymentOption?.toJson()};
  }

  @override
  String toString() => 'Tamara(selectedPaymentOption: $selectedPaymentOption)';
}
