import 'package:get/get.dart';
import 'package:traveler_app/controllers/localization_controller.dart';

class NameModel {
  final String? en;
  final String? ar;

  NameModel({this.en, this.ar});
  factory NameModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NameModel();
    return NameModel(ar: json['ar'], en: json['en']);
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'ar': ar};
  }

  String get name {
    final isLtr = Get.find<LocalizationController>().isLtr;
    return isLtr ? en ?? '' : ar ?? '';
  }
}
