import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/explore/screen.dart';
import 'package:traveler_app/features/home/screen.dart';
import 'package:traveler_app/features/nav/controller/nav_controller.dart';
import 'package:traveler_app/features/nav/widgets/bottom_nav_bar.dart';
import 'package:traveler_app/features/profile/screen.dart';
import 'package:traveler_app/features/reservations/screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late final PageController _pageController;
  final NavController _nav = Get.find();
  DateTime? _lastBackPress;

  static const _pages = [
    HomeScreen(),
    ExploreScreen(),
    ReservationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _nav.currentIndex);
    _nav.attachPageController(_pageController);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _nav.detachPageController();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_nav.currentIndex != 0) {
      _nav.changeTab(0);
      return false;
    }
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _nav.onPageSwiped,
              children: _pages,
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
