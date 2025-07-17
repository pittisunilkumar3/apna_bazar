import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/data/models/package_model.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/screens/pricing/payment_screen.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/pricing_controller.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '/data/models/package_model.dart' as p;

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PricingController>(builder: (pricingCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Pricing Plan'] ?? "Pricing Plan",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            await pricingCtrl.getPackageList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  pricingCtrl.isLoading
                      ? Helpers.appLoader()
                      : pricingCtrl.pricingList.isEmpty
                          ? Helpers.notFound(text: "No pricing found")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pricingCtrl.pricingList.length,
                              itemBuilder: (context, i) {
                                var data = pricingCtrl.pricingList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      pricingCtrl.selectedIndex = i;
                                      pricingCtrl.update();
                                      if (data.price != "0") {
                                        buildDialog(
                                            context, data, storedLanguage, pricingCtrl);
                                      } else {
                                        Helpers.showSnackBar(
                                            msg:
                                                "This is a free trial version of this package, so there's no need to purchase it.");
                                      }
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Ink(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h, horizontal: 30.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppThemes
                                                    .getSliderInactiveColor(),
                                                width: pricingCtrl.selectedIndex == i
                                                    ? 0
                                                    : .5),
                                            color: Get.isDarkMode
                                                ? pricingCtrl.selectedIndex == i
                                                    ? AppColors.mainColor
                                                    : AppColors.darkCardColor
                                                : pricingCtrl.selectedIndex == i
                                                    ? AppColors.mainColor
                                                    : AppColors.fillColor2,
                                            borderRadius:
                                                Dimensions.kBorderRadius * 1.5,
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(data.title ?? "",
                                                          style: t.bodyLarge?.copyWith(
                                                              color: pricingCtrl.selectedIndex ==
                                                                      i
                                                                  ? AppColors
                                                                      .blackColor
                                                                  : AppThemes
                                                                      .getIconBlackColor())),
                                                      Text(
                                                          "${HiveHelp.read(Keys.currencySymbol)}${data.price == null ? "0" : data.price.toString()}",
                                                          style: t.titleLarge?.copyWith(
                                                              color: pricingCtrl.selectedIndex ==
                                                                      i
                                                                  ? AppColors
                                                                      .blackColor
                                                                  : AppThemes
                                                                      .getIconBlackColor())),
                                                    ],
                                                  ),
                                                  VSpace(16.h),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      buildWidget(
                                                          context, t, pricingCtrl, i,
                                                          icon: data.expiryTime ==
                                                                  null
                                                              ? null
                                                              : int.parse(data
                                                                          .expiryTime
                                                                          .toString()) >
                                                                      0
                                                                  ? null
                                                                  : Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: AppColors
                                                                          .redColor,
                                                                      size:
                                                                          10.h,
                                                                    ),
                                                          text: data.expiryTime ==
                                                                  null
                                                              ? "Unlimited Package Expiration"
                                                              : "${data.expiryTime.toString()} ${data.expiryTimeType.toString()} Package Expiration"),
                                                      buildWidget(
                                                          context, t, pricingCtrl, i,
                                                          text: data.noOfListing ==
                                                                  null
                                                              ? "Unlimited Listing allowed"
                                                              : "${data.noOfListing.toString()} Listing Allowed"),
                                                      buildWidget(
                                                          context, t, pricingCtrl, i,
                                                          icon: data.isImage ==
                                                                  1
                                                              ? null
                                                              : Icon(
                                                                  Icons.close,
                                                                  color: AppColors
                                                                      .redColor,
                                                                  size: 10.h,
                                                                ),
                                                          text: data.isImage ==
                                                                  0
                                                              ? 'No image Allowed per listing'
                                                              : data.isImage ==
                                                                          1 &&
                                                                      data.noOfImgPerListing ==
                                                                          null
                                                                  ? 'Unlimited image Allowed per listing'
                                                                  : '${data.noOfImgPerListing.toString()} image Allowed per listing'),
                                                      if (pricingCtrl.selectedIndex ==
                                                              i &&
                                                          pricingCtrl.isExpandable ==
                                                              true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.noOfCategoriesPerListing !=
                                                                            null &&
                                                                        data.noOfCategoriesPerListing !=
                                                                            0
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.noOfCategoriesPerListing ==
                                                                            null ||
                                                                        data.noOfCategoriesPerListing ==
                                                                            0
                                                                    ? 'No category allowed per listing'
                                                                    : '${data.noOfCategoriesPerListing.toString()} category allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isProduct !=
                                                                            null &&
                                                                        data.isProduct ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.isProduct ==
                                                                            null ||
                                                                        data.isProduct ==
                                                                            0
                                                                    ? 'No product Allowed per listing'
                                                                    : data.isProduct ==
                                                                                1 &&
                                                                            data.noOfProduct ==
                                                                                null
                                                                        ? 'Unlimited product Allowed per listing'
                                                                        : '${data.noOfProduct.toString()} product Allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isProduct !=
                                                                            null &&
                                                                        data.isProduct ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.isProduct ==
                                                                            null ||
                                                                        data.isProduct ==
                                                                            0
                                                                    ? 'No image Allowed per product'
                                                                    : data.isProduct ==
                                                                                1 &&
                                                                            data.noOfImgPerProduct ==
                                                                                null
                                                                        ? 'Unlimited image Allowed per product'
                                                                        : '${data.noOfImgPerProduct.toString()} image Allowed per product'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isVideo !=
                                                                            null ||
                                                                        data.isVideo ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.isVideo ==
                                                                            null ||
                                                                        data.isVideo ==
                                                                            0
                                                                    ? 'No video Allowed per listing'
                                                                    : 'video Allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isAmenities !=
                                                                            null &&
                                                                        data.isAmenities ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.isAmenities ==
                                                                            null ||
                                                                        data.isAmenities ==
                                                                            0
                                                                    ? 'No amenity Allowed per listing'
                                                                    : data.isAmenities ==
                                                                                1 &&
                                                                            data.noOfAmenitiesPerListing ==
                                                                                null
                                                                        ? 'Unlimited amenity Allowed per listing'
                                                                        : '${data.noOfAmenitiesPerListing.toString()} amenity Allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isBusinessHour !=
                                                                            null &&
                                                                        data.isBusinessHour ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                      ),
                                                                text: data.isBusinessHour ==
                                                                            null ||
                                                                        data.isBusinessHour ==
                                                                            0
                                                                    ? 'No business hour Allowed per listing'
                                                                    : 'business hour Allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.seo !=
                                                                            null &&
                                                                        data.seo ==
                                                                            1
                                                                    ? null
                                                                    : Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              AppColors.redColor,
                                                                          size:
                                                                              10.h,
                                                                        ),
                                                                      ),
                                                                text: data.seo ==
                                                                            null ||
                                                                        data.seo ==
                                                                            0
                                                                    ? 'No SEO Allowed per listing'
                                                                    : 'SEO Allowed per listing'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isMessenger !=
                                                                            null &&
                                                                        data.isMessenger ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                        size: 10
                                                                            .h,
                                                                      ),
                                                                text: data.isMessenger ==
                                                                            null ||
                                                                        data.isMessenger ==
                                                                            0
                                                                    ? 'No Messenger chat SDK Available'
                                                                    : 'Messenger chat SDK Available'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isWhatsapp !=
                                                                            null &&
                                                                        data.isWhatsapp ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                        size: 10
                                                                            .h,
                                                                      ),
                                                                text: data.isWhatsapp ==
                                                                            null ||
                                                                        data.isWhatsapp ==
                                                                            0
                                                                    ? 'No Whatsapp chat SDK Available'
                                                                    : 'Whatsapp chat SDK Available'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.isRenew !=
                                                                            null &&
                                                                        data.isRenew ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                        size: 10
                                                                            .h,
                                                                      ),
                                                                text: data.isRenew ==
                                                                            null ||
                                                                        data.isRenew ==
                                                                            0
                                                                    ? 'No Package Renew Available'
                                                                    : 'Package Renew Available'),
                                                            buildWidget(context,
                                                                t, pricingCtrl, i,
                                                                icon: data.dynamicFrom !=
                                                                            null &&
                                                                        data.dynamicFrom ==
                                                                            1
                                                                    ? null
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: AppColors
                                                                            .redColor,
                                                                        size: 10
                                                                            .h,
                                                                      ),
                                                                text: data.dynamicFrom ==
                                                                            null ||
                                                                        data.dynamicFrom ==
                                                                            0
                                                                    ? 'No Dynamic Form Available'
                                                                    : 'Dynamic Form Available'),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  VSpace(10.h),
                                                ],
                                              ),
                                              Positioned(
                                                  top: 45.h,
                                                  right: 0,
                                                  child: planImage(data, pricingCtrl, i)),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 20.h,
                                                  decoration: BoxDecoration(
                                                    boxShadow:
                                                        pricingCtrl.selectedIndex == i &&
                                                                pricingCtrl.isExpandable ==
                                                                    true
                                                            ? []
                                                            : [
                                                                BoxShadow(
                                                                  color: pricingCtrl.selectedIndex ==
                                                                          i
                                                                      ? AppColors
                                                                          .mainColor
                                                                          .withValues(
                                                                              alpha: .7)
                                                                      : Get.isDarkMode
                                                                          ? AppColors.darkCardColor
                                                                          : AppColors.whiteColor,
                                                                  blurRadius:
                                                                      15.0,
                                                                  spreadRadius:
                                                                      5.0,
                                                                  offset:
                                                                      Offset(
                                                                    0,
                                                                    -12.h,
                                                                  ),
                                                                )
                                                              ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (pricingCtrl.selectedIndex == i)
                                          Positioned(
                                            top: 21.h,
                                            left: -12.w,
                                            child: Container(
                                              width: 26.h,
                                              height: 26.h,
                                              padding: EdgeInsets.all(6.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Get.isDarkMode
                                                        ? const Color.fromARGB(
                                                            255, 237, 213, 5)
                                                        : AppColors.mainColor,
                                                    blurRadius: !Get.isDarkMode
                                                        ? 25.h
                                                        : 8.0,
                                                    spreadRadius:
                                                        !Get.isDarkMode
                                                            ? 5.h
                                                            : .5,
                                                    offset: Offset(
                                                      0,
                                                      0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              child: Image.asset(
                                                "$rootImageDir/check_mark.png",
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          right: 0,
                                          left: 0,
                                          bottom: 8.h,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: GestureDetector(
                                              onTap: () {
                                                pricingCtrl.selectedIndex = i;
                                                pricingCtrl.isExpandable =
                                                    !pricingCtrl.isExpandable;
                                                pricingCtrl.update();
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                padding: EdgeInsets.all(5.h),
                                                child: Ink(
                                                  width: 26.h,
                                                  height: 26.h,
                                                  padding: EdgeInsets.only(
                                                      bottom: pricingCtrl.selectedIndex ==
                                                                  i &&
                                                              pricingCtrl.isExpandable ==
                                                                  true
                                                          ? 0
                                                          : 5.h,
                                                      top: pricingCtrl.selectedIndex ==
                                                                  i &&
                                                              pricingCtrl.isExpandable ==
                                                                  true
                                                          ? 7.h
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: pricingCtrl.selectedIndex == i
                                                        ? AppColors.black80
                                                        : Get.isDarkMode
                                                            ? AppColors
                                                                .darkCardColorDeep
                                                            : AppColors
                                                                .blackColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Transform.rotate(
                                                        angle: pricingCtrl.selectedIndex ==
                                                                    i &&
                                                                pricingCtrl.isExpandable ==
                                                                    true
                                                            ? pi / 2
                                                            : -pi / 2,
                                                        child: Icon(
                                                          Icons.arrow_back_ios,
                                                          color:
                                                              pricingCtrl.selectedIndex ==
                                                                      i
                                                                  ? AppColors
                                                                      .mainColor
                                                                  : AppColors
                                                                      .whiteColor,
                                                          size: 18.h,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  buildDialog(
      BuildContext context, p.Datum data, storedLanguage, PricingController pricingCtrl) {
    return appDialog(
        context: context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.title.toString(), style: context.t.bodyLarge),
            InkResponse(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(7.h),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 14.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VSpace(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(storedLanguage['Price'] ?? "Price",
                    style: context.t.displayMedium),
                Text(
                    "${HiveHelp.read(Keys.currencySymbol)}" +
                        data.price.toString(),
                    style: context.t.displayMedium),
              ],
            ),
            VSpace(12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(storedLanguage['No. of Listing'] ?? "No. Of Listing",
                    style: context.t.displayMedium),
                Text(
                    data.noOfListing == null
                        ? "Unlimited"
                        : data.noOfListing.toString(),
                    style: context.t.displayMedium),
              ],
            ),
            VSpace(12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(storedLanguage['Validity'] ?? "Validity",
                    style: context.t.displayMedium),
                Text(
                    data.expiryTime == null
                        ? "Unlimited"
                        : "${data.expiryTime.toString()} ${data.expiryTimeType.toString()}",
                    style: context.t.displayMedium),
              ],
            ),
            VSpace(28.h),
            AppButton(
              text: storedLanguage['Purchase Now'] ?? "Purchase Now",
              onTap: () async {
                Get.back();
                pricingCtrl.getPaymentGateways();
                pricingCtrl.pricingPlanPayment(
                    context: context, packageId: data.id.toString());
                pricingCtrl.amountCtrl.text = data.price.toString();
                pricingCtrl.amountValue = data.price.toString();
                pricingCtrl.update();
                Get.to(() => PaymentScreen(packageId: data.id.toString()));
              },
            ),
          ],
        ));
  }

  Image planImage(Datum data, PricingController pricingCtrl, int i) {
    return Image.asset(
      data.title.toString().toLowerCase().contains("free")
          ? "$rootImageDir/free.png"
          : data.title.toString().toLowerCase().contains("standard")
              ? "$rootImageDir/standard.png"
              : data.title.toString().toLowerCase().contains("silver") ||
                      data.title.toString().toLowerCase().contains("basic")
                  ? "$rootImageDir/silver.png"
                  : data.title.toString().toLowerCase().contains("premium")
                      ? "$rootImageDir/premium.png"
                      : "$rootImageDir/gold.png",
      height: 48.h,
      width: 48.h,
      color: pricingCtrl.selectedIndex == i
          ? AppColors.blackColor
          : Get.isDarkMode
              ? AppColors.whiteColor
              : AppColors.blackColor,
      fit: BoxFit.cover,
    );
  }

  Widget buildWidget(BuildContext context, t, PricingController pricingCtrl, int i,
      {required String text, Widget? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          Container(
            width: 18.h,
            height: 18.h,
            padding: EdgeInsets.all(4.h),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? pricingCtrl.selectedIndex == i
                      ? AppColors.whiteColor
                      : AppColors.darkCardColorDeep
                  : pricingCtrl.selectedIndex == i
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: icon ??
                Image.asset(
                  "$rootImageDir/check_mark.png",
                  color: Get.isDarkMode
                      ? pricingCtrl.selectedIndex == i
                          ? AppColors.blackColor
                          : AppColors.mainColor
                      : pricingCtrl.selectedIndex == i
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                ),
          ),
          HSpace(8.w),
          Text(
            text,
            style: t.bodySmall?.copyWith(
                color: pricingCtrl.selectedIndex == i
                    ? AppColors.blackColor
                    : AppThemes.getIconBlackColor()),
          ),
        ],
      ),
    );
  }
}
