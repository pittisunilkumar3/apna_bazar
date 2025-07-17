import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../routes/page_index.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/spacing.dart';

final drawerController = ZoomDrawerController();

class MainDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (appCtrl) {
      return ZoomDrawer(
        controller: drawerController,
        mainScreen: BottomNavBar(),
        menuScreen: DrawerScreen(),
        angle: 0,
        slideWidth: 300.w,
        showShadow: true,
        mainScreenTapClose: true,
        androidCloseOnBackTap: true,
        drawerShadowsBackgroundColor: appCtrl.isDarkMode() == true
            ? AppColors.darkCardColor
            : Color(0xffffffff),
        menuBackgroundColor:
            appCtrl.isDarkMode() == true ? AppColors.darkBgColor : Color(0xffFDFFF5),
      );
    });
  }
}

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProfileController>(builder: (profileCtrl) {
      return GetBuilder<AppController>(builder: (appCtrl) {
        return Scaffold(
          backgroundColor: appCtrl.isDarkMode() == true
              ? AppColors.darkBgColor
              : Color(0xffFDFFF5),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15.w),
                      margin: EdgeInsets.only(right: 20.w),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColor,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(32.r)),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity(
                          vertical: -3.2.h,
                        ),
                        onTap: () {},
                        leading: Image.asset(
                          "$rootImageDir/home.png",
                          height: 19.h,
                          width: 19.h,
                          fit: BoxFit.cover,
                          color: Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                        ),
                        title: Text(storedLanguage['Home'] ?? "Home",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp,
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDrawerTile(context,
                              imgSize: 18.h,
                              imgPath: "my_packages",
                              title: storedLanguage['My Packages'] ??
                                  "My Packages", onTap: () {
                            Get.toNamed(RoutesName.myPackageScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 22.h,
                              imgPath: "transaction_history",
                              title: storedLanguage['Transaction'] ??
                                  "Transaction", onTap: () {
                            Get.toNamed(RoutesName.transactionScreen);
                          }),
                          Container(
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            height: 1.h,
                            width: 190.w,
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.darkCardColorDeep
                                : AppColors.sliderInActiveColor,
                          ),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "chart",
                              title: storedLanguage['Analytics'] ?? "Analytics",
                              onTap: () {
                            Get.toNamed(RoutesName.myAnalyticsScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 22.h,
                              imgPath: "claim",
                              title: storedLanguage['My Claim Business'] ??
                                  "Claim Business", onTap: () {
                            Get.to(() => ClaimBusinessScreen(
                                isFromBottomNavPage: false));
                          }),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "product_inquiry",
                              title: storedLanguage['Product Inquiry'] ??
                                  "Product Inquiry", onTap: () {
                            Get.toNamed(RoutesName.productEnquiryScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "my_listings",
                              title: storedLanguage['My Listings'] ??
                                  "My Listings", onTap: () async {
                            Get.toNamed(RoutesName.myListingScreen);
                          }),
                          Container(
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            height: 1.h,
                            width: 190.w,
                            color: appCtrl.isDarkMode() == true
                                ? AppColors.darkCardColorDeep
                                : AppColors.sliderInActiveColor,
                          ),
                          buildDrawerTile(context,
                              imgSize: 22.h,
                              imgPath: "plan",
                              title: storedLanguage['Pricing Plan'] ??
                                  "Pricing Plan", onTap: () {
                            Get.toNamed(RoutesName.pricingScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 18.h,
                              imgPath: "support_ticket",
                              title: storedLanguage['Support Ticket'] ??
                                  "Support Ticket", onTap: () {
                            Get.toNamed(RoutesName.supportTicketListScreen);
                          }),
                          VSpace(50.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  Widget buildDrawerTile(BuildContext context,
      {required String imgPath,
      required String title,
      void Function()? onTap,
      double? imgSize}) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset("$rootSvgDir/$imgPath.svg",
          height: imgSize ?? 17.h,
          width: imgSize ?? 17.h,
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(AppThemes.getIconBlackColor(), BlendMode.srcIn)),
      title: Text(title,
          style: context.t.displayMedium?.copyWith(fontSize: 18.sp)),
    );
  }
}
