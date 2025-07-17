import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

Color themeColor = const Color(0xFF43D19E);

class _ThankYouPageState extends State<ThankYouPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.toNamed(RoutesName.bottomNavBar);
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 150.h,
                  padding: EdgeInsets.all(37.h),
                  decoration: BoxDecoration(
                    color: themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/images/card.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Thank You!",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 36.sp,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Payment done Successfully.",
                  style: TextStyle(
                    // color: AppColors.appBlack40,
                    fontWeight: FontWeight.w400,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                InkWell(
                  onTap: () {
                    // Get.offAllNamed(BottomNavBar.routeName);
                  },
                  child: Container(
                    height: 45.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(32)),
                    child: Center(
                        child: Text(
                      "Go Home",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
