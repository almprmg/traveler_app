class AppConstants {
  AppConstants._();

  static const String fontFamily = 'Cairo';
  static const String baseUrl =
      'https://2a0c-2001-16a3-f8d-4c00-4626-1090-fc24-d7ea.ngrok-free.app';
  static const String apiUrl = '$baseUrl/api/v1/';
  static const double appVersion = 0.01;

  // Home
  static const String homeUrl = '${apiUrl}home';

  // Storage
  static const String generalStorageUrl = '${apiUrl}general/storage/';
  static const String uploadFileUri =
      '${generalStorageUrl}file/fullUrl/customer';

  // Payment URLs
  static String paymentSuccessUrl = '${baseUrl}payment/paymentSuccess';
  static String paymentFailureUrl = '${baseUrl}payment/paymentFailure';
  static String paymentCancelUrl = '${baseUrl}payment/paymentCancel';
  static String paymentDefaultUrl =
      '${baseUrl}orders-history/view-order/Default';

  // Local storage keys
  static const String languageCode = 'LANGUAGE_CODE';
  static const String countryCode = 'COUNTRY_CODE';
  static const String tokenCode = 'TOKEN_CODE';
  static const String userKey = 'user_data';
  static const String cityId = 'CITY_ID';
  static const String customerId = 'CUSTOMER_ID';
  static const String userProfileKey = 'USER_PROFILE';
  static const String refreshTokenCode = 'REFRESH_TOKEN_CODE';
  static const String localCartIdKey = 'LOCAL_CART_ID';
}
