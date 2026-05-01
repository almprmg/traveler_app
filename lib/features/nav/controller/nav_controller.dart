import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  PageController? _pageController;

  void attachPageController(PageController controller) {
    _pageController = controller;
  }

  void detachPageController() {
    _pageController = null;
  }

  void changeTab(int index) {
    if (_currentIndex.value == index) return;
    _currentIndex.value = index;
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void onPageSwiped(int index) {
    _currentIndex.value = index;
  }
}
