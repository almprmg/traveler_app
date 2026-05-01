import '../models/lang_model.dart';

class AppConstants {
  AppConstants._();

  static const String fontFamily = 'Cairo';
  static const String baseUrl = 'https://kafaratplus.com';
  static const String apiUrl = '$baseUrl/api/';
  static const double appVersion = 5.1;
  static const String clarityProjectId = 'v7jnoo2p6w';

  // ── Feature flags ──────────────────────────────────────────────────────
  // Flip back to `true` to restore the wallet recharge flow (the "Add
  // balance" button + the charge-wallet bottom sheet). When `false`, the
  // button shows a "coming soon" toast and the sheet doesn't open.
  static const bool chargeWalletEnabled = false;

  // Customer endpoints
  static const String customer = '${apiUrl}customer/';
  static const String profileUrl = '${customer}profile/';
  static const String userAddressesUrl = '${customer}address';
  static const String loginUrl = '${customer}signupSendOtp';
  static const String notificationsUrl = '${customer}profile/notification';
  static const String productQuotationUrl = '${customer}product/quotation';
  static const String productNotifyUrl = '${customer}product/notify';
  // auth
  static const String verifyOtpUrl = '${apiUrl}customer/auth/';
  static const String signupUrl = '${verifyOtpUrl}signup';
  static const String loginWithPhoneUrl = '${verifyOtpUrl}signupSendOtp';
  static const String verifyOtpPoint = '${verifyOtpUrl}verify-mobile';
  // General endpoints
  static const String generalUrl = '${apiUrl}general/lookup/';
  static const String generalStorageUrl = '${apiUrl}general/storage/';
  static const String uploadFileUri =
      '${generalStorageUrl}file/fullUrl/customer';
  static const String coordinatesToLookupUrl =
      '${generalUrl}coordinatesToLookup';
  static const String splashUrl = '${generalUrl}appConfig/Customer';
  static const String bannerUrl = '${generalUrl}banner';
  static const String seenUrl =
      '${apiUrl}general/notification-register/seenNotification';
  // Product endpoints
  static const String productUrl = '${customer}product/';
  static const String categoryUrl = '${productUrl}category/';
  static const String customerProductUrl = '${apiUrl}customer/product';
  static const String customerProductByCodeUrl = '$customerProductUrl/search';
  static const String brandsByCategoryCodeUrl =
      '$customerProductUrl/manufacturersByCode';
  static const String mainCategoryProductsUrl =
      '$customerProductUrl/mainCategoryproducts';
  static const String productByCategoryCodeUrl =
      '$customerProductUrl/productByCode/';
  static const String offersUrl = '$customerProductUrl/offers';
  static const String offersDetilsUrl = '$customerProductUrl/offer';
  static const String offerProductsUrl = '$customerProductUrl/offer/products';
  static const String searchProductsValueUrl =
      '$customerProductUrl/values/product';

  // Tickets
  static String generalChatRoom = '${apiUrl}general/chat-room/';
  static String ticketsUrl = '${generalChatRoom}chat-rooms';
  static String openTicketUrl = '${generalChatRoom}v3/openTicket';
  static String closeTicketUrl = '${generalChatRoom}close/customer';
  static String sendTicketMessageUrl =
      '${apiUrl}general/chat-room-message/customer';
  static String ticketUrl = '${generalChatRoom}customer';
  // Lookup endpoints
  static const String generalLookupUrl = '${apiUrl}general/lookup/';
  static const String customerCouponsUrl = '${generalLookupUrl}customerCoupons';
  static const String serviceAccountLookupUrl =
      '${apiUrl}service/account/lookup/';
  static const String manufacturersUrl = '${generalLookupUrl}manufacturer';
  static const String manufacturersLookupUrl =
      '${serviceAccountLookupUrl}manufacturer';
  static const String manufacturersByCodeUrl =
      '${generalLookupUrl}manufacturersByCode';
  static const String productFitForUrl = '${generalLookupUrl}product/fitFor';

  // Retail/Order endpoints
  static const String appRetailUrl = '${apiUrl}app/retail';
  static const String cartUrl = '$appRetailUrl/order/cart';
  static const String createOrderUrl = '$appRetailUrl/order/v2/order';
  static const String tamaraUrl = '$appRetailUrl/order/tamara';
  static const String orderStatusUrl = '$appRetailUrl/order/status';
  static const String orderAgainUrl = '$appRetailUrl/order/orderAgain/';
  static const String generateCheckoutUrlBase =
      '$appRetailUrl/order/generateCheckoutUrl/';
  static const String addItemsUrl = '$cartUrl/addItems';

  // Category
  static const String categoriesUrl = '${apiUrl}customer/category/';

  // Notification endpoints
  static const String generalNotificationUrl =
      '${apiUrl}general/notification-register/';
  static const String fmcTokenUrl = '${generalNotificationUrl}customer';

  // Qitaf
  static const String qitafOtpUrl =
      '${apiUrl}app/retail/order/qitaf/redemption/otp';
  static const String qitafRedeemUrl =
      '${apiUrl}app/retail/order/qitaf/redemption/redeem';
  static const String qitafReverseUrl =
      '${apiUrl}app/retail/order/qitaf/redemption/reverse';
  // Loyalty Points
  static const String pointPriceUrl =
      '${customerProfileUrl}consts/by-key/pointPriceInSAR';
  static const String pointsRedeemUrl = '$appRetailUrl/order/points/check';
  static const String pointsUncheckUrl = '$appRetailUrl/order/points/uncheck';

  // Profile
  static const String customerProfileUrl = '${apiUrl}customer/profile/';
  static const String userDataUrl = '${customerProfileUrl}mine';
  static const String rewardsUrl = '$userDataUrl/rewards';

  static const String updateProfileUrl = '${customerProfileUrl}mine';
  static const String updateGenderUrl = '${customerProfileUrl}mine/gender';
  static const String deleteAccountUrl =
      '${customerProfileUrl}mine/deleteAccount';
  static const String wishListUrl = '${customerProfileUrl}wishList';
  static const String addressUrl = '${customerProfileUrl}address';
  static const String vehicleUrl = '${customerProfileUrl}vehicle';
  static const String vehicleBrandUrl = '${generalUrl}vehicle-brand';
  static const String vehicleModelUrl = '${generalUrl}vehicle-model';
  static const String vehicleTypeUrl = '${generalUrl}vehicle-type';
  static const String vehicleSetupUrl = '${customerProfileUrl}vehicle';
  // Charge Wallet
  static const String chargeWalletUrl =
      '${customerProfileUrl}chargeWallet/payTabs';
  static const String chargeWalletHistoryUrl =
      '${customerProfileUrl}chargeWallet/history';
  static const String walletChargeSuccessUrl = '$baseUrl/wallet/charge/success';
  static const String walletChargeFailureUrl = '$baseUrl/wallet/charge/failure';
  static const String walletChargeDefaultUrl = '$baseUrl/wallet/charge/default';
  static const String pendingChargeIdKey = 'PENDING_CHARGE_ID';

  // Orders
  static const String customerOrdersUrl = '${apiUrl}customer/order/';
  static const String orderHistoryUrl = '${customerOrdersUrl}orders/history';
  // Payment URLs (production)
  static String paymentSuccessUrl = '$baseUrl/payment/paymentSuccess';
  static String paymentFailureUrl = '$baseUrl/payment/paymentFailure';
  static String paymentCancelUrl = '$baseUrl/payment/paymentCancel';
  static String paymentDefaultUrl =
      '$baseUrl/orders-history/view-order/Default';

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

  // Supported languages
  static final List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: '',
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      imageUrl: '',
      languageName: 'عربي',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}
