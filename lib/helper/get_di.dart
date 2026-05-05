import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/controllers/internet_controller.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';
import 'package:traveler_app/features/auth/controller/auth_forgot_controller.dart';
import 'package:traveler_app/features/auth/controller/auth_login_controller.dart';
import 'package:traveler_app/features/auth/controller/auth_otp_controller.dart';
import 'package:traveler_app/features/auth/controller/auth_register_controller.dart';
import 'package:traveler_app/features/auth/controller/auth_reset_controller.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/home/service/home_service.dart';
import 'package:traveler_app/features/hotels/controller/hotel_detail_controller.dart';
import 'package:traveler_app/features/hotels/controller/hotels_controller.dart';
import 'package:traveler_app/features/hotels/service/hotels_service.dart';
import 'package:traveler_app/features/nav/controller/nav_controller.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/features/profile/service/profile_service.dart';
import 'package:traveler_app/features/reservations/controller/reservations_controller.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';
import 'package:traveler_app/features/tours/controller/tour_detail_controller.dart';
import 'package:traveler_app/features/tours/controller/tours_controller.dart';
import 'package:traveler_app/features/tours/service/tours_service.dart';
import 'package:traveler_app/features/activities/controller/activities_controller.dart';
import 'package:traveler_app/features/activities/service/activities_service.dart';
import 'package:traveler_app/features/visas/controller/visas_controller.dart';
import 'package:traveler_app/features/visas/service/visas_service.dart';
import 'package:traveler_app/features/transports/controller/transports_controller.dart';
import 'package:traveler_app/features/transports/service/transports_service.dart';
import 'package:traveler_app/features/packages/controller/packages_controller.dart';
import 'package:traveler_app/features/packages/service/packages_service.dart';
import 'package:traveler_app/features/blogs/controller/blogs_controller.dart';
import 'package:traveler_app/features/blogs/service/blogs_service.dart';
import 'package:traveler_app/features/destinations/controller/destinations_controller.dart';
import 'package:traveler_app/features/destinations/service/destinations_service.dart';
import 'package:traveler_app/features/categories/controller/categories_controller.dart';
import 'package:traveler_app/features/categories/service/categories_service.dart';
import 'package:traveler_app/features/payments/service/payments_service.dart';
import 'package:traveler_app/features/reviews/service/reviews_service.dart';
import 'package:traveler_app/features/reservations/controller/booking_create_controller.dart';
import 'package:traveler_app/features/wallet/controller/wallet_controller.dart';
import 'package:traveler_app/features/wallet/service/wallet_service.dart';
import 'package:traveler_app/features/devices/service/devices_service.dart';
import 'package:traveler_app/features/esim/controller/esim_controller.dart';
import 'package:traveler_app/features/esim/service/esim_service.dart';
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
  Get.put(AuthService(apiClient: Get.find()));
  Get.put(ReservationsService(apiClient: Get.find()));
  Get.put(ProfileService(apiClient: Get.find()));
  Get.put(ToursService(apiClient: Get.find()));
  Get.put(HotelsService(apiClient: Get.find()));
  Get.put(ActivitiesService(apiClient: Get.find()));
  Get.put(VisasService(apiClient: Get.find()));
  Get.put(TransportsService(apiClient: Get.find()));
  Get.put(PackagesService(apiClient: Get.find()));
  Get.put(BlogsService(apiClient: Get.find()));
  Get.put(DestinationsService(apiClient: Get.find()));
  Get.put(CategoriesService(apiClient: Get.find()));
  Get.put(PaymentsService(apiClient: Get.find()));
  Get.put(ReviewsService(apiClient: Get.find()));
  Get.put(WalletService(apiClient: Get.find()));
  Get.put(DevicesService(apiClient: Get.find()));
  Get.put(EsimService(apiClient: Get.find()));

  // Controllers
  Get.put(AuthController(storage: Get.find()));
  Get.put(LocalizationController(localStorageService: Get.find()));
  Get.put(NavController());
  Get.put(HomeController(homeService: Get.find()));
  Get.put(ReservationsController(reservationsService: Get.find()));
  Get.put(ProfileController(profileService: Get.find()));
  Get.lazyPut(() => ToursController(service: Get.find()), fenix: true);
  Get.lazyPut(() => HotelsController(service: Get.find()), fenix: true);
  Get.lazyPut(() => ActivitiesController(service: Get.find()), fenix: true);
  Get.lazyPut(() => VisasController(service: Get.find()), fenix: true);
  Get.lazyPut(() => TransportsController(service: Get.find()), fenix: true);
  Get.lazyPut(() => PackagesController(service: Get.find()), fenix: true);
  Get.lazyPut(() => BlogsController(service: Get.find()), fenix: true);
  Get.lazyPut(() => DestinationsController(service: Get.find()), fenix: true);
  Get.lazyPut(() => CategoriesController(service: Get.find()), fenix: true);
  Get.lazyPut(
      () => BookingCreateController(
            bookingService: Get.find(),
            paymentsService: Get.find(),
          ),
      fenix: true);
  Get.lazyPut(
      () => WalletController(
            service: Get.find(),
            payments: Get.find(),
          ),
      fenix: true);
  Get.lazyPut(() => EsimBrowseController(service: Get.find()), fenix: true);
  Get.lazyPut(() => EsimPackagesController(service: Get.find()), fenix: true);
  Get.lazyPut(
      () => EsimCheckoutController(
            service: Get.find(),
            payments: Get.find(),
          ),
      fenix: true);
  Get.lazyPut(() => EsimOrdersController(service: Get.find()), fenix: true);
  Get.lazyPut(() => EsimProfilesController(service: Get.find()), fenix: true);

  // Auth controllers (permanent so routes can always find them)
  Get.put(AuthLoginController(authService: Get.find()), permanent: true);
  Get.put(AuthRegisterController(authService: Get.find()), permanent: true);
  Get.put(AuthOtpController(authService: Get.find()), permanent: true);
  Get.put(AuthForgotController(authService: Get.find()), permanent: true);
  Get.put(AuthResetController(authService: Get.find()), permanent: true);

  // Detail controllers (recreated each time they're needed)
  Get.lazyPut(() => TourDetailController(service: Get.find<ToursService>()),
      fenix: true);
  Get.lazyPut(() => HotelDetailController(service: Get.find<HotelsService>()),
      fenix: true);
  Get.lazyPut(
      () => ActivityDetailController(service: Get.find<ActivitiesService>()),
      fenix: true);
  Get.lazyPut(() => VisaDetailController(service: Get.find<VisasService>()),
      fenix: true);
  Get.lazyPut(
      () => TransportDetailController(service: Get.find<TransportsService>()),
      fenix: true);
  Get.lazyPut(
      () => PackageDetailController(service: Get.find<PackagesService>()),
      fenix: true);
  Get.lazyPut(() => BlogDetailController(service: Get.find<BlogsService>()),
      fenix: true);
  Get.lazyPut(
      () => DestinationDetailController(
          service: Get.find<DestinationsService>()),
      fenix: true);

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
