import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/controllers/package_controller.dart';
import 'package:listplace/controllers/payment_history_controller.dart';
import 'package:listplace/controllers/pricing_controller.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../data/models/purchase_package_model.dart' as p;
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';
import '../pricing/payment_screen.dart';

class MyPackageScreen extends StatelessWidget {
  const MyPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PackageController>(builder: (packageCtrl) {
      return Scaffold(
        appBar: buildAppBar(storedLanguage, context, t, packageCtrl),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            packageCtrl.purchaseEditingCtrlr.clear();
            packageCtrl.expireEditingCtrlr.clear();
            packageCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await packageCtrl.getPackageList(
                page: 1, name: '', purchase_date: '', expire_date: '');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: packageCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(20),
                  packageCtrl.isLoading
                      ? Helpers.appLoader()
                      : packageCtrl.packageList.isEmpty
                          ? Helpers.notFound(text: "No packages found")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: packageCtrl.packageList.length,
                              itemBuilder: (context, i) {
                                var data = packageCtrl.packageList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 155.h,
                                        width: 110.w,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.h),
                                        decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.darkCardColorDeep
                                                : AppColors.mainColor
                                                    .withValues(alpha: .1),
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left:
                                                        Radius.circular(4.r))),
                                        child: Column(
                                          mainAxisAlignment: data.noOfListing ==
                                                  null
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${data.title.toString()}",
                                              style: t.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            if (data.noOfListing == null)
                                              VSpace(25.h),
                                            data.noOfListing == null
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3.h,
                                                            horizontal: 6.w),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .greenColor
                                                          .withValues(
                                                              alpha: .1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              33.r),
                                                      border: Border.all(
                                                          color: AppColors
                                                              .greenColor,
                                                          width: .5),
                                                    ),
                                                    child: Text(
                                                      storedLanguage[
                                                              'Unlimited'] ??
                                                          "Unlimited",
                                                      style: t.bodySmall
                                                          ?.copyWith(
                                                              fontSize: 13.sp,
                                                              color: AppColors
                                                                  .greenColor),
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        EdgeInsets.all(9.2.h),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${data.noOfListing.toString()}",
                                                        style: t.titleMedium
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .blackColor),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 155.h,
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    right:
                                                        Radius.circular(4.r)),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 15.h,
                                                left: 16.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            storedLanguage[
                                                                    'Validity:'] ??
                                                                "Validity:",
                                                            style: t
                                                                .displayMedium),
                                                        HSpace(8.w),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.h,
                                                                    horizontal:
                                                                        12.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: DateTime.parse(data
                                                                          .expireDate
                                                                          .toString())
                                                                      .isAfter(DateTime
                                                                          .now())
                                                                  ? AppColors
                                                                      .activeColor
                                                                  : AppColors
                                                                      .redColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.r),
                                                            ),
                                                            child: Text(
                                                                "${DateTime.parse(data.expireDate.toString()).isAfter(DateTime.now()) ? "Active" : "Expired"}",
                                                                style: t
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        color: AppColors
                                                                            .whiteColor))),
                                                      ],
                                                    ),
                                                    VSpace(10.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            storedLanguage[
                                                                    'Status:'] ??
                                                                "Status:",
                                                            style: t
                                                                .displayMedium),
                                                        HSpace(16.w),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.h,
                                                                    horizontal:
                                                                        12.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .approvedColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.r),
                                                            ),
                                                            child: Text(
                                                                data.status.toString() ==
                                                                        "0"
                                                                    ? "Pending"
                                                                    : data.status.toString() ==
                                                                            "1"
                                                                        ? "Approved"
                                                                        : "Cancelled",
                                                                style: t
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        color: AppColors
                                                                            .whiteColor))),
                                                      ],
                                                    ),
                                                    VSpace(12.h),
                                                    Text(
                                                      "Purchased Date: ${DateFormat('dd MMM, yyyy').format(DateTime.parse(data.purchaseDate.toString()))}",
                                                      style: t.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 15.sp,
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .black50),
                                                    ),
                                                    VSpace(5.h),
                                                    Text(
                                                      "Expired Date: ${DateFormat('dd MMM, yyyy').format(DateTime.parse(data.expireDate.toString()))}",
                                                      style: t.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 15.sp,
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .black50),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: -32.h,
                                                right: -32.w,
                                                child: buildPopupMenu(
                                                    t, data, storedLanguage),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                  if (packageCtrl.isLoadMore == true)
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
      storedLanguage, BuildContext context, TextTheme t, PackageController packageCtrl) {
    return CustomAppBar(
      title: storedLanguage['My Packages'] ?? "My Packages",
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
                          color: AppThemes.getIconBlackColor(),
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
                          storedLanguage['Search Package'] ?? "Search Package",
                      controller: packageCtrl.packageNameEditingCtrlr,
                    ),
                    VSpace(24.h),
                    InkWell(
                      onTap: () async {
                        /// SHOW DATE PICKER
                        await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    surface: Get.isDarkMode
                                        ? AppColors.blackColor
                                        : AppColors.black70,
                                    onPrimary: AppColors.whiteColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors
                                          .mainColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(DateTime.now().year.toInt() + 1),
                        ).then((value) {
                          if (value != null) {
                            print(value.toUtc());
                            packageCtrl.purchaseEditingCtrlr.text =
                                DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext: storedLanguage['Purchased Date'] ??
                              "Purchased Date",
                          controller: packageCtrl.purchaseEditingCtrlr,
                        ),
                      ),
                    ),
                    VSpace(24.h),
                    InkWell(
                      onTap: () async {
                        /// SHOW DATE PICKER
                        await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    surface: Get.isDarkMode
                                        ? AppColors.blackColor
                                        : AppColors.black70,
                                    onPrimary: AppColors.whiteColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors
                                          .mainColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(DateTime.now().year.toInt() + 1),
                        ).then((value) {
                          if (value != null) {
                            print(value.toUtc());
                            packageCtrl.expireEditingCtrlr.text =
                                DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext:
                              storedLanguage['Expire Date'] ?? "Expired Date",
                          controller: packageCtrl.expireEditingCtrlr,
                        ),
                      ),
                    ),
                    VSpace(28.h),
                    AppButton(
                      text: storedLanguage['Search Now'] ?? "Search Now",
                      onTap: () {
                        Get.back();
                        packageCtrl.resetDataAfterSearching();
                        packageCtrl.getPackageList(
                            page: 1,
                            name: '',
                            purchase_date: '',
                            expire_date: '');
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

  PopupMenuButton<String> buildPopupMenu(
      TextTheme t, p.Datum data, storedLanguage) {
    return PopupMenuButton<String>(
      color: AppThemes.getDarkBgColor(),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (data.price != null)
          PopupMenuItem<String>(
            onTap: () {
              PaymentHistoryController.to.id = data.id.toString();
              PaymentHistoryController.to.resetDataAfterSearching();
              PaymentHistoryController.to.getPaymentHistoryList(
                  page: 1,
                  id: data.id.toString(),
                  transaction_id: '',
                  remark: '',
                  date: '');
              Get.toNamed(RoutesName.paymentHistoryScreen);
            },
            value: 'option1',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "$rootImageDir/bag.png",
                  width: 14.h,
                  height: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(storedLanguage['Payment History'] ?? 'Payment History',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if (data.expireDate != null &&
            data.status.toString() != "0" &&
            data.isRenew.toString() == "1")
          PopupMenuItem<String>(
            onTap: () {
              buildDialog(context, data, storedLanguage);
            },
            value: 'option2',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "$rootImageDir/renew.png",
                  width: 14.h,
                  height: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(storedLanguage['Renew Package'] ?? 'Renew Package',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if ((data.noOfListing == null ||
                int.parse(data.noOfListing.toString()) > 0) &&
            (data.expireDate == null ||
                DateTime.parse(data.expireDate.toString())
                    .isAfter(DateTime.now())) &&
            (data.status == 1))
          PopupMenuItem<String>(
            onTap: () async {
              ManageListingController.to.selectedSinglePackage = data;
              ManageListingController.to.selectedPackageId = data.packageId;
              ManageListingController.to.selectedPurchasePackage =
                  data.packageId;
              if (data.noOfListing != null &&
                  (int.parse(data.noOfListing.toString()) > 0)) {
                Get.back();
                ManageListingController.to.refreshAllValue();
                await Future.delayed(Duration(milliseconds: 300));
                Get.toNamed(RoutesName.addListingScreen);
              } else {
                Helpers.showSnackBar(
                    msg: "You are not eligible for creating listing");
              }
              ManageListingController.to.update();
            },
            value: 'option3',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "$rootImageDir/add_listing.png",
                  width: 14.h,
                  height: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(storedLanguage['Add Listing'] ?? 'Add Listing',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if (data.apiSubscriptionId != null)
          PopupMenuItem<String>(
            value: 'option4',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.close,
                  size: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(
                    storedLanguage['Cancelo Subscription'] ??
                        'Cancel Subscription',
                    style: t.bodyMedium),
              ],
            ),
          ),

        // Add more menu items as needed
      ],
      child: Container(
        height: 90.h,
        width: 90.h,
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColors.darkCardColorDeep
              : AppColors.mainColor.withValues(alpha: .1),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 15.w, top: 15.h),
          child: Icon(
            Icons.more_vert,
            size: 20.h,
          ),
        ),
      ),
    );
  }

  buildDialog(BuildContext context, p.Datum data, storedLanguage) {
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
                    data.expireDate == null
                        ? "Expired"
                        : PackageController.to.getValidityMessage(
                            DateTime.parse(data.expireDate.toString()),
                            DateTime.parse(data.purchaseDate.toString())),
                    style: context.t.displayMedium),
              ],
            ),
            VSpace(28.h),
            AppButton(
              text: storedLanguage['Purchase Now'] ?? "Purchase Now",
              onTap: () async {
                Get.back();
                PricingController.to.getPaymentGateways();
                PricingController.to.pricingPlanPayment(
                    context: context, packageId: data.packageId.toString());
                PricingController.to.amountCtrl.text = data.price.toString();
                PricingController.to.amountValue = data.price.toString();
                PricingController.to.update();
                Get.to(
                    () => PaymentScreen(packageId: data.packageId.toString()));
              },
            ),
          ],
        ));
  }
}
