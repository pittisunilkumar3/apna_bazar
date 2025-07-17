import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/utils/app_constants.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      HiveHelp.read(Keys.token) != null
          ? Get.offAllNamed(RoutesName.mainDrawerScreen)
          : HiveHelp.read(Keys.isNewUser) != null
              ? Get.offAllNamed(RoutesName.mainDrawerScreen)
              : Get.offAllNamed(RoutesName.onbordingScreen);
      //  HiveHelp.read(Keys.token) != null
      //   ? Get.offAllNamed(RoutesName.mainDrawerScreen)
      //   : HiveHelp.read(Keys.isNewUser) != null
      //       ? Get.offAllNamed(RoutesName.frontendListingDemoScreen)
      //       : Get.offAllNamed(RoutesName.onbordingScreen);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$rootImageDir/splash_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 164.h,
                height: 164.h,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor.withValues(alpha: .2),
                    border: Border.all(
                      color: AppColors.mainColor,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "$rootImageDir/app_icon.png",
                      ),
                    )),
              ),
            ),
            Positioned(
                bottom: 70.h,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Apna Bazar",
                    style: t.titleLarge?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
