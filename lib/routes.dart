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

// Explore
const String exploreRoute = '/explore';

// Profile extras
const String editProfileRoute = '/profile/edit';
const String wishlistRoute = '/wishlist';
const String walletRoute = '/wallet';

// Reservations extras
const String reservationDetailRoute = '/reservations/detail';

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
];
