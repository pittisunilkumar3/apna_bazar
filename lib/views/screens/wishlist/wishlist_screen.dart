import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/wishlist_controller.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/views/widgets/appDialog.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../controllers/frontend_listing_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../home/home_screen.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<WishlistController>(builder: (wishlistCtrl) {
      return Scaffold(
        appBar: buildAppBar(storedLanguage, context, t, wishlistCtrl),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            wishlistCtrl.textEditingController.clear();
            wishlistCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await wishlistCtrl.getwishlist(
                page: 1, listing_name: '', from_date: '', to_date: '');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: wishlistCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  wishlistCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 10, isReverseColor: true)
                      : wishlistCtrl.wishList.isEmpty
                          ? Helpers.notFound(text: "No wishlist found")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: wishlistCtrl.wishList.length,
                              itemBuilder: (context, i) {
                                var data = wishlistCtrl.wishList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      FrontendListingController.to
                                          .getFrontendListingDetailsList(
                                              slug: data.listingSlug == null
                                                  ? ""
                                                  : data.listingSlug
                                                      .toString());
                                      Get.toNamed(
                                          RoutesName.listingDetailsScreen);
                                    },
                                    child: Container(
                                      height: 92.h,
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius:
                                            Dimensions.kBorderRadius / 2,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 60.h,
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                color: AppThemes.getFillColor(),
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      data.thumbnail.toString(),
                                                    ),
                                                    fit: BoxFit.cover)),
                                          ),
                                          HSpace(16.w),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${data.listingTitle.toString()}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodyLarge),
                                              VSpace(3.h),
                                              Text("${data.categories.toString()}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: t.displayMedium
                                                      ?.copyWith(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .blackColor
                                                                  .withValues(
                                                                      alpha:
                                                                          .8))),
                                              VSpace(3.h),
                                            ],
                                          )),
                                          HSpace(10.w),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                borderRadius:
                                                    Dimensions.kBorderRadius /
                                                        2,
                                                onTap: () async {
                                                  await wishlistCtrl
                                                      .addToWishlist(fields: {
                                                    "listing_id": data.listingId
                                                        .toString()
                                                  }, listingId: data.listingId);
                                                  if (wishlistCtrl.wishListItem
                                                      .contains(data.id)) {
                                                    wishlistCtrl.wishListItem
                                                        .remove(data.id);
                                                  } else {
                                                    wishlistCtrl.wishListItem
                                                        .add(data.listingId);
                                                  }
                                                  wishlistCtrl.update();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color: Get.isDarkMode
                                                        ? AppColors
                                                            .darkCardColorDeep
                                                        : AppColors.black10,
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),
                                                  child: Image.asset(
                                                      "$rootImageDir/delete_icon.png",
                                                      height: 20.h,
                                                      width: 20.h,
                                                      color: AppThemes
                                                          .getParagraphColor()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (wishlistCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppBar(
      storedLanguage, BuildContext context, TextTheme t, WishlistController wishlistCtrl) {
    return CustomAppBar(
      isTitleMarginTop: true,
      toolberHeight: 110.h,
      prefferSized: 110.h,
      title: storedLanguage['Wishlist'] ?? "Wishlist",
      leading: const SizedBox(),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
          child: InkWell(
            onTap: () {
              appDialog(
                  context: context,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(storedLanguage['Filter Now'] ?? "Filter Now",
                          style: t.bodyMedium),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintext:
                            storedLanguage['Listing name'] ?? "Listing name",
                        controller: wishlistCtrl.listingNameEditingCtrlr,
                      ),
                      VSpace(24.h),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Container(
                                  width: Dimensions.screenWidth - 20.w,
                                  height: 400.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: SfDateRangePicker(
                                      headerHeight: 55.h,
                                      headerStyle: DateRangePickerHeaderStyle(
                                        textStyle: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontFamily: Styles.appFontFamily),
                                        backgroundColor: Get.isDarkMode
                                            ? AppColors.darkCardColorDeep
                                            : AppColors.mainColor,
                                      ),
                                      backgroundColor:
                                          AppThemes.getDarkCardColor(),
                                      rangeSelectionColor: Get.isDarkMode
                                          ? AppColors.mainColor
                                              .withValues(alpha: .1)
                                          : AppColors.mainColor
                                              .withValues(alpha: .2),
                                      todayHighlightColor: AppColors.mainColor,
                                      selectionColor: AppColors.whiteColor,
                                      startRangeSelectionColor:
                                          AppColors.mainColor,
                                      endRangeSelectionColor:
                                          AppColors.mainColor,
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                      selectionTextStyle: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontFamily: Styles.appFontFamily),
                                      rangeTextStyle: TextStyle(
                                          color: AppColors.mainColor,
                                          fontFamily: Styles.appFontFamily),
                                      monthCellStyle:
                                          DateRangePickerMonthCellStyle(
                                        todayTextStyle: TextStyle(
                                            fontFamily: Styles.appFontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.mainColor),
                                      ),
                                      showActionButtons: true,
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        if (args.value is PickerDateRange) {
                                          wishlistCtrl.fromDateEditingCtrlr.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(args.value.startDate);
                                          wishlistCtrl.toDateEditingCtrlr.text =
                                              DateFormat('yyyy-MM-dd').format(
                                                  args.value.endDate ??
                                                      args.value.startDate);
                                          wishlistCtrl.textEditingController.text =
                                              wishlistCtrl.fromDateEditingCtrlr.text +
                                                  " to " +
                                                  wishlistCtrl.toDateEditingCtrlr.text;
                                        }
                                      },
                                      onSubmit: (Object? value) {
                                        if (value is PickerDateRange) {
                                          wishlistCtrl.fromDateEditingCtrlr.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(value.startDate!);
                                          wishlistCtrl.toDateEditingCtrlr.text =
                                              DateFormat('yyyy-MM-dd').format(
                                                  value.endDate ??
                                                      value.startDate!);
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: CustomTextField(
                            hintext: storedLanguage['Date'] ?? "Date",
                            controller: wishlistCtrl.textEditingController,
                          ),
                        ),
                      ),
                      VSpace(28.h),
                      AppButton(
                        text: storedLanguage['Search Now'] ?? "Search Now",
                        onTap: () async {
                          wishlistCtrl.resetDataAfterSearching();

                          Get.back();
                          await wishlistCtrl
                              .getwishlist(
                            page: 1,
                            listing_name: wishlistCtrl.listingNameEditingCtrlr.text,
                            from_date: wishlistCtrl.fromDateEditingCtrlr.text,
                            to_date: wishlistCtrl.toDateEditingCtrlr.text,
                          )
                              .then((value) {
                            wishlistCtrl.fromDateEditingCtrlr.clear();
                            wishlistCtrl.toDateEditingCtrlr.clear();
                          });
                        },
                      ),
                    ],
                  ));
            },
            child: Container(
              width: 34.h,
              height: 34.h,
              padding: EdgeInsets.all(9.h),
              decoration: BoxDecoration(
                color: AppThemes.getFillColor(),
                borderRadius: Dimensions.kBorderRadius,
              ),
              child: Image.asset(
                "$rootImageDir/filter_2.png",
                color: Get.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
          ),
        ),
        HSpace(20.w),
      ],
    );
  }
}
