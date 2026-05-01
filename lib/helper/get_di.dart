import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/controllers/internet_controller.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/home/service/home_service.dart';
import 'package:traveler_app/features/nav/controller/nav_controller.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/features/profile/service/profile_service.dart';
import 'package:traveler_app/features/reservations/controller/reservations_controller.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';
import 'package:traveler_app/services/upload_service.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);
  Get.put(LocalStorageService(sharedPreferences));
  Get.put(ApiClient(localStorageService: Get.find()));
  Get.put(InternetController());

  // Services
  Get.put(UploadService(apiClient: Get.find()));
  Get.put(HomeService(apiClient: Get.find()));
  Get.put(ReservationsService(apiClient: Get.find()));
  Get.put(ProfileService(apiClient: Get.find()));

  // Controllers
  Get.put(AuthController(storage: Get.find()));
  Get.put(LocalizationController(localStorageService: Get.find()));
  Get.put(NavController());
  Get.put(HomeController(homeService: Get.find()));
  Get.put(ReservationsController(reservationsService: Get.find()));
  Get.put(ProfileController(profileService: Get.find()));

  Map<String, Map<String, String>> languages = {};
  for (final languageModel in LocalizationController.supportedLanguages) {
    String jsonStringValues = await rootBundle.loadString(
      'assets/language/${languageModel.languageCode}.json',
    );
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsons = {};
    mappedJson.forEach((key, value) {
      jsons[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        jsons;
  }
  return languages;
}
