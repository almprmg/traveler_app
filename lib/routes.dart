import 'package:get/get.dart';
import 'package:traveler_app/features/auth/screens/forgot_password_screen.dart';
import 'package:traveler_app/features/auth/screens/login_screen.dart';
import 'package:traveler_app/features/auth/screens/otp_screen.dart';
import 'package:traveler_app/features/auth/screens/register_screen.dart';
import 'package:traveler_app/features/auth/screens/reset_password_screen.dart';
import 'package:traveler_app/features/explore/screen.dart';
import 'package:traveler_app/features/home/screen.dart';
import 'package:traveler_app/features/hotels/screen.dart';
import 'package:traveler_app/features/hotels/screens/hotel_detail_screen.dart';
import 'package:traveler_app/features/nav/screen.dart';
import 'package:traveler_app/features/profile/screen.dart';
import 'package:traveler_app/features/profile/screens/edit_profile_screen.dart';
import 'package:traveler_app/features/reservations/screen.dart';
import 'package:traveler_app/features/reservations/screens/reservation_detail_screen.dart';
import 'package:traveler_app/features/tours/screen.dart';
import 'package:traveler_app/features/tours/screens/tour_detail_screen.dart';
import 'package:traveler_app/features/wishlist/screen.dart';
import 'package:traveler_app/features/wallet/screen.dart';
import 'package:traveler_app/features/activities/screen.dart';
import 'package:traveler_app/features/activities/screens/activity_detail_screen.dart';
import 'package:traveler_app/features/visas/screen.dart';
import 'package:traveler_app/features/visas/screens/visa_detail_screen.dart';
import 'package:traveler_app/features/transports/screen.dart';
import 'package:traveler_app/features/transports/screens/transport_detail_screen.dart';
import 'package:traveler_app/features/packages/screen.dart';
import 'package:traveler_app/features/packages/screens/package_detail_screen.dart';
import 'package:traveler_app/features/blogs/screen.dart';
import 'package:traveler_app/features/blogs/screens/blog_detail_screen.dart';
import 'package:traveler_app/features/destinations/screen.dart';
import 'package:traveler_app/features/destinations/screens/destination_detail_screen.dart';
import 'package:traveler_app/features/categories/screen.dart';
import 'package:traveler_app/features/reservations/screens/booking_create_screen.dart';
import 'package:traveler_app/features/payments/screens/payment_webview_screen.dart';
import 'package:traveler_app/features/esim/screens/esim_browse_screen.dart';
import 'package:traveler_app/features/esim/screens/esim_packages_screen.dart';
import 'package:traveler_app/features/esim/screens/esim_orders_screen.dart';
import 'package:traveler_app/features/esim/screens/esim_profiles_screen.dart';

// Nav
const String navRoute = '/';
const String homeRoute = '/home';
const String reservationsRoute = '/reservations';
const String profileRoute = '/profile';

// Auth
const String loginRoute = '/login';
const String registerRoute = '/register';
const String otpRoute = '/otp';
const String forgotPasswordRoute = '/forgot-password';
const String resetPasswordRoute = '/reset-password';

// Tours
const String toursRoute = '/tours';
const String tourDetailRoute = '/tours/detail';

// Hotels
const String hotelsRoute = '/hotels';
const String hotelDetailRoute = '/hotels/detail';

// Activities (Phase 2)
const String activitiesRoute = '/activities';
const String activityDetailRoute = '/activities/detail';

// Visas (Phase 2)
const String visasRoute = '/visas';
const String visaDetailRoute = '/visas/detail';

// Transports (Phase 2)
const String transportsRoute = '/transports';
const String transportDetailRoute = '/transports/detail';

// Packages (Phase 2)
const String packagesRoute = '/packages';
const String packageDetailRoute = '/packages/detail';

// Blogs (Phase 2)
const String blogsRoute = '/blogs';
const String blogDetailRoute = '/blogs/detail';

// Destinations (Phase 2)
const String destinationsRoute = '/destinations';
const String destinationDetailRoute = '/destinations/detail';

// Categories (Phase 2)
const String categoriesRoute = '/categories';

// Explore
const String exploreRoute = '/explore';

// Profile extras
const String editProfileRoute = '/profile/edit';
const String wishlistRoute = '/wishlist';
const String walletRoute = '/wallet';

// Reservations extras
const String reservationDetailRoute = '/reservations/detail';
const String bookingCreateRoute = '/bookings/create';

// Payment
const String paymentWebViewRoute = '/payments/webview';

// eSIM
const String esimRoute = '/esim';
const String esimPackagesRoute = '/esim/packages';
const String esimOrdersRoute = '/esim/orders';
const String esimProfilesRoute = '/esim/profiles';

final List<GetPage> routes = [
  GetPage(name: navRoute, page: () => const NavScreen()),
  GetPage(name: homeRoute, page: () => const HomeScreen()),
  GetPage(name: reservationsRoute, page: () => const ReservationsScreen()),
  GetPage(name: profileRoute, page: () => const ProfileScreen()),
  // Auth
  GetPage(name: loginRoute, page: () => const LoginScreen()),
  GetPage(name: registerRoute, page: () => const RegisterScreen()),
  GetPage(name: otpRoute, page: () => const OtpScreen()),
  GetPage(name: forgotPasswordRoute, page: () => const ForgotPasswordScreen()),
  GetPage(name: resetPasswordRoute, page: () => const ResetPasswordScreen()),
  // Tours
  GetPage(name: toursRoute, page: () => const ToursScreen()),
  GetPage(name: tourDetailRoute, page: () => const TourDetailScreen()),
  // Hotels
  GetPage(name: hotelsRoute, page: () => const HotelsScreen()),
  GetPage(name: hotelDetailRoute, page: () => const HotelDetailScreen()),
  // Activities
  GetPage(name: activitiesRoute, page: () => const ActivitiesScreen()),
  GetPage(name: activityDetailRoute, page: () => const ActivityDetailScreen()),
  // Visas
  GetPage(name: visasRoute, page: () => const VisasScreen()),
  GetPage(name: visaDetailRoute, page: () => const VisaDetailScreen()),
  // Transports
  GetPage(name: transportsRoute, page: () => const TransportsScreen()),
  GetPage(
    name: transportDetailRoute,
    page: () => const TransportDetailScreen(),
  ),
  // Packages
  GetPage(name: packagesRoute, page: () => const PackagesScreen()),
  GetPage(name: packageDetailRoute, page: () => const PackageDetailScreen()),
  // Blogs
  GetPage(name: blogsRoute, page: () => const BlogsScreen()),
  GetPage(name: blogDetailRoute, page: () => const BlogDetailScreen()),
  // Destinations
  GetPage(name: destinationsRoute, page: () => const DestinationsScreen()),
  GetPage(
    name: destinationDetailRoute,
    page: () => const DestinationDetailScreen(),
  ),
  // Categories
  GetPage(name: categoriesRoute, page: () => const CategoriesScreen()),
  // Explore
  GetPage(name: exploreRoute, page: () => const ExploreScreen()),
  // Profile extras
  GetPage(name: editProfileRoute, page: () => const EditProfileScreen()),
  GetPage(name: wishlistRoute, page: () => const WishlistScreen()),
  GetPage(name: walletRoute, page: () => const WalletScreen()),
  // Reservations extras
  GetPage(
    name: reservationDetailRoute,
    page: () => const ReservationDetailScreen(),
  ),
  GetPage(
    name: bookingCreateRoute,
    page: () => const BookingCreateScreen(),
  ),
  // Payment WebView
  GetPage(
    name: paymentWebViewRoute,
    page: () => const PaymentWebViewScreen(),
  ),
  // eSIM
  GetPage(name: esimRoute, page: () => const EsimBrowseScreen()),
  GetPage(name: esimPackagesRoute, page: () => const EsimPackagesScreen()),
  GetPage(name: esimOrdersRoute, page: () => const EsimOrdersScreen()),
  GetPage(name: esimProfilesRoute, page: () => const EsimProfilesScreen()),
];
