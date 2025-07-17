import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/page_index.dart';

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find<BottomNavController>();
  bool hasFocus = false;
  int selectedIndex = 2;
  List<Widget> screens = [
    WishListScreen(),
    AllListingScreen(),
    HomeScreen(),
    const ClaimBusinessScreen(),
    const ProfileSettingScreen(),
  ];

  Widget get currentScreen => screens[selectedIndex];

  void changeScreen(int index) {
    selectedIndex = index;
    update();
  }
}
