import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/controllers/bottomNav_controller.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/manage_listing_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../../utils/services/pop_app.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  Future getData() async {
    if (HiveHelp.read(Keys.token) != null) {
      DashboardController.to.getDashboard();
      await Get.put(ProfileController()).getProfile();
      await Get.put(ProfileController()).getLanguageList();
    }
    ManageListingController.to.getListingCategories();
  }

  @override
  void initState() {
    _connectivity.onConnectivityChanged
        .listen(Get.find<AppController>().updateConnectionStatus);
    if (HiveHelp.read(Keys.token) != null) {
      Get.put(PushNotificationController()).getPushNotificationConfig();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (appCtrl) {
      return GetBuilder<BottomNavController>(builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            return PopApp.onWillPop();
          },
          child: Scaffold(
            body: controller.currentScreen,
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
                child: Ink(
                  height: 52.h,
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: appCtrl.isDarkMode() == true
                        ? AppColors.darkCardColor
                        : AppColors.fillColor,
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkResponse(
                        onTap: () {
                          if (HiveHelp.read(Keys.token) != null) {
                            controller.changeScreen(0);
                          } else {
                            Get.toNamed(RoutesName.loginScreen);
                            Helpers.showSnackBar(
                                title: 'Alert!',
                                bgColor: Colors.yellow.shade800,
                                msg:
                                    'Log in to continue exploring and access more features.');
                          }
                        },
                        child: Container(
                          width: 45.h,
                          height: 45.h,
                          padding: EdgeInsets.all(10.h),
                          child: Image.asset(
                            controller.selectedIndex == 0
                                ? "$rootImageDir/bookmark1.png"
                                : "$rootImageDir/bookmark.png",
                            height: controller.selectedIndex == 0 ? 28.h : 24.h,
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.black10
                                : controller.selectedIndex == 0
                                    ? AppColors.blackColor
                                    : AppColors.paragraphColor,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          if (HiveHelp.read(Keys.token) != null) {
                            controller.changeScreen(1);
                          } else {
                            Get.toNamed(RoutesName.loginScreen);
                            Helpers.showSnackBar(
                                title: 'Alert!',
                                bgColor: Colors.yellow.shade800,
                                msg:
                                    'Log in to continue exploring and access more features.');
                          }
                        },
                        child: Container(
                          width: 45.h,
                          height: 45.h,
                          padding: EdgeInsets.all(10.h),
                          child: Image.asset(
                            controller.selectedIndex == 1
                                ? "$rootImageDir/all_listing1.png"
                                : "$rootImageDir/all_listing.png",
                            height: 24.h,
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.black10
                                : controller.selectedIndex == 1
                                    ? AppColors.blackColor
                                    : AppColors.paragraphColor,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(2);
                        },
                        child: Container(
                          width: 45.h,
                          height: 45.h,
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            controller.selectedIndex == 2
                                ? "$rootImageDir/home1.png"
                                : "$rootImageDir/home.png",
                            height: 24.h,
                            color: AppColors.blackColor,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          if (HiveHelp.read(Keys.token) != null) {
                            controller.changeScreen(3);
                          } else {
                            Get.toNamed(RoutesName.loginScreen);
                            Helpers.showSnackBar(
                                title: 'Alert!',
                                bgColor: Colors.yellow.shade800,
                                msg:
                                    'Log in to continue exploring and access more features.');
                          }
                        },
                        child: Container(
                          width: 45.h,
                          height: 45.h,
                          padding: EdgeInsets.all(10.h),
                          child: Image.asset(
                            controller.selectedIndex == 3
                                ? "$rootImageDir/message_bottomnav1.png"
                                : "$rootImageDir/message_bottomnav.png",
                            height: 24.h,
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.black10
                                : controller.selectedIndex == 3
                                    ? AppColors.blackColor
                                    : AppColors.paragraphColor,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          if (HiveHelp.read(Keys.token) != null) {
                            controller.changeScreen(4);
                          } else {
                            Get.toNamed(RoutesName.loginScreen);
                            Helpers.showSnackBar(
                                title: 'Alert!',
                                bgColor: Colors.yellow.shade800,
                                msg:
                                    'Log in to continue exploring and access more features.');
                          }
                        },
                        child: Container(
                          width: 45.h,
                          height: 45.h,
                          padding: EdgeInsets.all(10.h),
                          child: Image.asset(
                            controller.selectedIndex == 4
                                ? "$rootImageDir/person2.png"
                                : "$rootImageDir/person.png",
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.black10
                                : controller.selectedIndex == 4
                                    ? AppColors.blackColor
                                    : AppColors.paragraphColor,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
