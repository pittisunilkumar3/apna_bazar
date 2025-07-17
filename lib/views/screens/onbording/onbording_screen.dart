import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/app_colors.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/views/screens/onbording/onbording_data.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: onBordingDataList.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, i) {
                  if (i != 2) {
                    return Stack(
                      children: [
                        if (i == 1)
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 40.h,
                                left: 24.w,
                                right: 24.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "$rootImageDir/star.png",
                                    color: AppColors.mainColor,
                                    height: 32.h,
                                    width: 32.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    "$rootImageDir/location_onbording.png",
                                    color: AppColors.mainColor,
                                    height: 40.h,
                                    width: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (i == 0)
                              Container(
                                width: double.maxFinite,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      onBordingDataList[i].imagePath,
                                      height: 344.h,
                                      width: 341.w,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.h),
                                          child: Image.asset(
                                            '$rootImageDir/onbording_1.1.png',
                                            height: 300.h,
                                            width: 123.w,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (i == 1)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 100.h,
                                  left: 24.w,
                                  right: 24.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 56.w,
                                      height: 197.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: Color(0xffEAEAEA),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          "$rootImageDir/location_onbording.png",
                                          width: 54.w,
                                          height: 87.h,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        VSpace(23.h),
                                        Container(
                                          width: 56.w,
                                          height: 104.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            color: Color(0xffEAEAEA),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 56.w,
                                      height: 153.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: Color(0xffEAEAEA),
                                      ),
                                    ),
                                    Container(
                                      width: 56.w,
                                      height: 243.h,
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                        top: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: AppColors.mainColor,
                                      ),
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                        "$rootImageDir/arrow_onbording.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 56.w,
                                      height: 197.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: Color(0xffEAEAEA),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            VSpace(100.h),
                            Center(
                              child: Text(
                                onBordingDataList[i].title,
                                style: t.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28.sp,
                                ),
                              ),
                            ),
                            VSpace(12.h),
                            Center(
                              child: Text(
                                onBordingDataList[i].description,
                                textAlign: TextAlign.center,
                                style: t.displayMedium
                                    ?.copyWith(height: 1.5, fontSize: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return SafeArea(
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(50.h),
                            Text(
                              "Find the best",
                              style: t.titleLarge?.copyWith(
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Place For you",
                              style: t.titleLarge?.copyWith(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "$rootImageDir/onboarding_3.1.png",
                                  width: 109.w,
                                  height: 480.h,
                                  fit: BoxFit.fitHeight,
                                ),
                                Image.asset(
                                  "$rootImageDir/onboarding_3.2.png",
                                  width: 109.w,
                                  height: 376.h,
                                  fit: BoxFit.fitHeight,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HiveHelp.write(Keys.isNewUser, false);
                                    Get.offAllNamed(
                                        RoutesName.mainDrawerScreen);
                                  },
                                  child: Image.asset(
                                    "$rootImageDir/onboarding_3.3.png",
                                    width: 109.w,
                                    height: 269.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 40.h),
          padding: Dimensions.kDefaultPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentIndex == onBordingDataList.length - 1
                  ? const SizedBox(
                      height: 1,
                      width: 1,
                    )
                  : InkWell(
                      onTap: () {
                        Get.offAllNamed(RoutesName.mainDrawerScreen);
                        HiveHelp.write(Keys.isNewUser, false);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          "Skip",
                          style: t.displayMedium?.copyWith(
                            color: AppColors.greyColor,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
              currentIndex == onBordingDataList.length - 1
                  ? const SizedBox(
                      height: 1,
                      width: 1,
                    )
                  : InkWell(
                      borderRadius: Dimensions.kBorderRadius,
                      onTap: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOutQuint);
                      },
                      child: Ink(
                        width: (currentIndex == (onBordingDataList.length - 1))
                            ? 218.w
                            : 157.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (currentIndex == (onBordingDataList.length - 1))
                                  ? "Get Started"
                                  : "Next",
                              style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor),
                            ),
                            HSpace(12.w),
                            Image.asset(
                              "$rootImageDir/big_arrow.png",
                              width: 36.w,
                              color: AppColors.blackColor,
                              fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}
