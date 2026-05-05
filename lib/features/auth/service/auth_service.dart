import 'dart:convert';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await apiClient.postData(AppConstants.loginUrl, {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await apiClient.postData(AppConstants.registerUrl, {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    final response = await apiClient.postData(AppConstants.otpVerifyUrl, {
      'email': email,
      'otp': otp,
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> resendOtp(String email) async {
    final response = await apiClient.postData(
        AppConstants.otpResendUrl, {'email': email});
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> forgotPassword(String email) async {
    final response = await apiClient.postData(
        AppConstants.forgotPasswordUrl, {'email': email});
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await apiClient.postData(AppConstants.resetPasswordUrl, {
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return response.statusCode == 200;
  }

  Future<bool> logout() async {
    final response =
        await apiClient.postData(AppConstants.logoutUrl, null);
    return response.statusCode == 200;
  }

  Future<bool> deleteAccount() async {
    final response = await apiClient.deleteData(
      '${AppConstants.apiUrl}auth/account',
      null,
    );
    return response.statusCode == 200;
  }
}
