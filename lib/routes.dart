import 'package:get/get.dart';
import 'package:traveler_app/features/home/screen.dart';
import 'package:traveler_app/features/nav/screen.dart';
import 'package:traveler_app/features/profile/screen.dart';
import 'package:traveler_app/features/reservations/screen.dart';

const String navRoute = '/';
const String homeRoute = '/home';
const String reservationsRoute = '/reservations';
const String profileRoute = '/profile';

final List<GetPage> routes = [
  GetPage(name: navRoute, page: () => const NavScreen()),
  GetPage(name: homeRoute, page: () => const HomeScreen()),
  GetPage(name: reservationsRoute, page: () => const ReservationsScreen()),
  GetPage(name: profileRoute, page: () => const ProfileScreen()),
];
