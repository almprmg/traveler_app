import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_checker.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';
import 'package:traveler_app/routes.dart';

class AuthController extends GetxController {
  final LocalStorageService _storage;

  AuthController({required LocalStorageService storage}) : _storage = storage;

  @override
  void onInit() {
    super.onInit();
    ApiChecker.onUnauthorized = () async {
      if (isLoggedIn()) await logout();
    };
  }

  bool isLoggedIn() => _storage.getToken() != null;

  Future<void> saveToken(String token) => _storage.setToken(token);

  Future<void> logout() async {
    await _storage.removeAuthData();
    Get.offAllNamed(loginRoute);
  }
}
