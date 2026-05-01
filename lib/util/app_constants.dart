class AppConstants {
  AppConstants._();

  static const String fontFamily = 'Cairo';
  static const String baseUrl =
      'https://2a0c-2001-16a3-f8d-4c00-4626-1090-fc24-d7ea.ngrok-free.app';
  static const String apiUrl = '$baseUrl/api/v1/';
  static const double appVersion = 0.01;

  // Home
  static const String homeUrl = '${apiUrl}home';

  // Auth
  static const String loginUrl = '${apiUrl}auth/login';
  static const String registerUrl = '${apiUrl}auth/register';
  static const String otpVerifyUrl = '${apiUrl}auth/otp/verify';
  static const String otpResendUrl = '${apiUrl}auth/otp/resend';
  static const String forgotPasswordUrl = '${apiUrl}auth/password/forgot';
  static const String resetPasswordUrl = '${apiUrl}auth/password/reset';
  static const String logoutUrl = '${apiUrl}auth/logout';

  // Profile
  static const String profileUrl = '${apiUrl}profile';

  // Tours
  static const String toursUrl = '${apiUrl}tours';
  static String tourDetailUrl(String slug) => '${apiUrl}tours/$slug';

  // Hotels
  static const String hotelsUrl = '${apiUrl}hotels';
  static String hotelDetailUrl(String slug) => '${apiUrl}hotels/$slug';

  // Destinations
  static const String destinationsUrl = '${apiUrl}destinations';
  static String destinationDetailUrl(String slug) =>
      '${apiUrl}destinations/$slug';

  // Activities
  static const String activitiesUrl = '${apiUrl}activities';
  static String activityDetailUrl(String slug) =>
      '${apiUrl}activities/$slug';

  // Packages
  static const String packagesUrl = '${apiUrl}packages';
  static String packageDetailUrl(String slug) => '${apiUrl}packages/$slug';

  // Blogs
  static const String blogsUrl = '${apiUrl}blogs';
  static String blogDetailUrl(String slug) => '${apiUrl}blogs/$slug';
  static String blogCommentsUrl(String id) => '${apiUrl}blogs/$id/comments';

  // Visas
  static const String visasUrl = '${apiUrl}visas';
  static String visaDetailUrl(String slug) => '${apiUrl}visas/$slug';

  // Transports
  static const String transportsUrl = '${apiUrl}transports';
  static String transportDetailUrl(String slug) =>
      '${apiUrl}transports/$slug';

  // Categories
  static const String categoriesUrl = '${apiUrl}categories';

  // Bookings / Reservations
  static const String bookingsUrl = '${apiUrl}bookings';
  static String bookingDetailUrl(String id) => '${apiUrl}bookings/$id';
  static String bookingCancelUrl(String id) => '${apiUrl}bookings/$id/cancel';

  // Payments
  static const String paymentMethodsUrl = '${apiUrl}payments/methods';
  static const String initiatePaymentUrl = '${apiUrl}payments/initiate';

  // Reviews
  static const String reviewsUrl = '${apiUrl}reviews';

  // Wishlist
  static const String wishlistUrl = '${apiUrl}wishlist';
  static String wishlistToggleUrl(String type, String id) =>
      '${apiUrl}wishlist/$type/$id';

  // Wallet
  static const String walletUrl = '${apiUrl}wallet';
  static const String walletTransactionsUrl = '${apiUrl}wallet/transactions';
  static const String walletDepositUrl = '${apiUrl}wallet/deposit';

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
