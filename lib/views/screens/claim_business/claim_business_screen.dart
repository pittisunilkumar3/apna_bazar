import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/screens/claim_business/claim_business_inbox.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../controllers/claim_business_controller.dart';
import '../../../controllers/frontend_listing_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';

class ClaimBusinessScreen extends StatelessWidget {
  final bool? isFromBottomNavPage;
  const ClaimBusinessScreen({super.key, this.isFromBottomNavPage = true});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ClaimBusinessController>(builder: (claimBusinessCtrl) {
      return Scaffold(
        appBar: buildAppBar(storedLanguage, context, t, claimBusinessCtrl, isFromBottomNavPage),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              OverflowBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      claimBusinessCtrl.pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      claimBusinessCtrl.selectedIndex = 0;
                      claimBusinessCtrl.claimType = "customer";
                      claimBusinessCtrl.resetDataAfterSearching();
                      claimBusinessCtrl.getClaimBusinessList(
                          page: 1,
                          claimType: "customer",
                          from_date: '',
                          to_date: '');
                      claimBusinessCtrl.update();
                    },
                    child: Ink(
                      child: Column(
                        children: [
                          Text(
                              storedLanguage['Customer Claim'] ??
                                  "Customer Claim",
                              style: t.bodyMedium),
                          VSpace(5.h),
                          Container(
                            width: 140.w,
                            height: .6.h,
                            color: claimBusinessCtrl.selectedIndex == 0
                                ? AppThemes.getIconBlackColor()
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      claimBusinessCtrl.pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );

                      claimBusinessCtrl.selectedIndex = 1;
                      claimBusinessCtrl.claimType = "my";
                      claimBusinessCtrl.resetDataAfterSearching();
                      claimBusinessCtrl.getClaimBusinessList(
                          page: 1, claimType: "my", from_date: '', to_date: '');
                      claimBusinessCtrl.update();
                    },
                    child: Ink(
                      child: Column(
                        children: [
                          Text(storedLanguage['My Claim'] ?? "My Claim",
                              style: t.bodyMedium),
                          VSpace(5.h),
                          Container(
                            width: 140.w,
                            height: .6.h,
                            color: claimBusinessCtrl.selectedIndex == 1
                                ? AppThemes.getIconBlackColor()
                                : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              VSpace(30.h),
              if (claimBusinessCtrl.isLoading) Helpers.appLoader(),
              if (!claimBusinessCtrl.isLoading)
                Expanded(
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: claimBusinessCtrl.pageController,
                      onPageChanged: (i) {
                        claimBusinessCtrl.selectedIndex = i;
                        claimBusinessCtrl.update();
                      },
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return RefreshIndicator(
                          color: AppColors.mainColor,
                          onRefresh: () async {
                            claimBusinessCtrl.resetDataAfterSearching(
                                isFromOnRefreshIndicator: true);
                            await claimBusinessCtrl.getClaimBusinessList(
                                page: 1,
                                claimType: claimBusinessCtrl.claimType,
                                from_date: '',
                                to_date: '');
                          },
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: claimBusinessCtrl.scrollController,
                              itemCount: claimBusinessCtrl.claimBusinessList.isEmpty
                                  ? 1
                                  : claimBusinessCtrl.claimBusinessList.length,
                              itemBuilder: (context, i) {
                                if (claimBusinessCtrl.claimBusinessList.isEmpty) {
                                  return Helpers.notFound(
                                      text: "No claims found");
                                }
                                var data = claimBusinessCtrl.claimBusinessList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    onTap: () {
                                      FrontendListingController.to
                                          .getFrontendListingDetailsList(
                                              slug: data.listing == null
                                                  ? ""
                                                  : data.listing!.slug
                                                      .toString());
                                      Get.toNamed(
                                          RoutesName.listingDetailsScreen);
                                    },
                                    child: Ink(
                                      height: 125.h,
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 13.h),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius: Dimensions.kBorderRadius,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: Container(
                                                  height: 40.h,
                                                  width: 40.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.greyColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        data.listingClaimer ==
                                                                null
                                                            ? ""
                                                            : data
                                                                .listingClaimer!
                                                                .image
                                                                .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              HSpace(12.w),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          data.listingClaimer ==
                                                                  null
                                                              ? ""
                                                              : data.listingClaimer!
                                                                      .firstname
                                                                      .toString() +
                                                                  " ${data.listingClaimer!.lastname}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              t.displayMedium),
                                                      Text(
                                                          data.listingClaimer ==
                                                                  null
                                                              ? ""
                                                              : data
                                                                  .listingClaimer!
                                                                  .email
                                                                  .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .black50,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ]),
                                              ),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          data.listing == null
                                                              ? ""
                                                              : data.listing!
                                                                  .title
                                                                  .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodySmall),
                                                      Text(
                                                          data.createdAt == null
                                                              ? ""
                                                              : "${DateFormat("dd MMM yyyy").format(DateTime.parse(data.createdAt.toString()))}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                            fontSize: 12.sp,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .black50,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          VSpace(12.h),
                                          const Divider(
                                              color: AppColors.black10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  data.status == 0
                                                      ? "Pending"
                                                      : data.status == 1
                                                          ? "Approved"
                                                          : "Rejected",
                                                  style:
                                                      t.displayMedium?.copyWith(
                                                    color: data.status == 0
                                                        ? AppColors.pendingColor
                                                        : data.status == 1
                                                            ? AppColors
                                                                .greenColor
                                                            : AppColors
                                                                .redColor,
                                                  )),
                                              if (data.isChatStart == 1)
                                                AppButton(
                                                  buttonWidth: 70.w,
                                                  buttonHeight: 30.h,
                                                  text: 'Reply',
                                                  style: t.bodySmall?.copyWith(
                                                      color:
                                                          AppColors.blackColor),
                                                  onTap: () {
                                                    if (data.uuid != null) {
                                                      Get.put(PushNotificationController())
                                                          .getPushNotificationConfig(
                                                              channelType:
                                                                  "claim_business",
                                                              uuid: data.uuid
                                                                  .toString());
                                                      Get.to(() =>
                                                          ClaimBusinessInboxScreen(
                                                            uuid: data.uuid,
                                                            claim_id: data.id
                                                                .toString(),
                                                            listing_id: data
                                                                .listingId
                                                                .toString(),
                                                          ));
                                                    } else {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Message ID not found");
                                                    }
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                ),
              if (claimBusinessCtrl.isLoadMore == true)
                Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    child: Helpers.appLoader()),
              VSpace(20.h),
            ],
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppBar(storedLanguage, BuildContext context, TextTheme t,
      ClaimBusinessController c, isFromBottomNavPage) {
    return CustomAppBar(
      leading:
          isFromBottomNavPage == true ? SizedBox(width: 1, height: 1) : null,
      title: storedLanguage['Claim Business'] ?? "Claim Business",
      actions: [
        InkWell(
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
                                    endRangeSelectionColor: AppColors.mainColor,
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
                                        c.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(args.value.startDate);
                                        c.toDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd').format(
                                                args.value.endDate ??
                                                    args.value.startDate);
                                        c.textEditingController.text =
                                            c.fromDateEditingCtrlr.text +
                                                " to " +
                                                c.toDateEditingCtrlr.text;
                                      }
                                    },
                                    onSubmit: (Object? value) {
                                      if (value is PickerDateRange) {
                                        c.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(value.startDate!);
                                        c.toDateEditingCtrlr.text =
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
                          controller: c.textEditingController,
                        ),
                      ),
                    ),
                    VSpace(28.h),
                    AppButton(
                      text: storedLanguage['Search Now'] ?? "Search Now",
                      onTap: () async {
                        Get.back();

                        c.resetDataAfterSearching();
                        await c
                            .getClaimBusinessList(
                                page: 1,
                                claimType: c.claimType,
                                from_date: c.fromDateEditingCtrlr.text,
                                to_date: c.toDateEditingCtrlr.text)
                            .then((value) {
                          c.fromDateEditingCtrlr.clear();
                          c.toDateEditingCtrlr.clear();
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
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ),
        HSpace(20.w),
      ],
    );
  }
}
