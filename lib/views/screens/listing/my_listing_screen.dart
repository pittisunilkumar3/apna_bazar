import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/controllers/analytics_controller.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/dynamic_form_controller.dart';
import '../../../controllers/listing_review_list_controller.dart';
import '../../../controllers/my_listing_controller.dart';
import '../../../routes/page_index.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/multi_select_dropdown.dart';
import '../../widgets/spacing.dart';
import '/data/models/my_listing_model.dart' as listing;

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return GetBuilder<MyListingController>(builder: (myListingCtrl) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            manageListingCtrl.refreshAllValue();
            Get.back();
          },
          child: Scaffold(
            appBar: buildAppbar(storedLanguage),
            body: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // add listing, filter listing section
                      buildAddListingWidget(
                          context, storedLanguage, t, manageListingCtrl, myListingCtrl),
                      VSpace(30.h),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.mainColor,
                          onRefresh: () async {
                            myListingCtrl.listingNameEditingCtrlr.clear();
                            ManageListingController.to.selectedCategoryList
                                .clear();
                            ManageListingController.to.selectedCategoryIdList
                                .clear();
                            myListingCtrl.resetDataAfterSearching(
                                isFromOnRefreshIndicator: true);
                            await myListingCtrl.getMyListings(page: 1, listing_name: '');
                          },
                          child: SingleChildScrollView(
                              controller: myListingCtrl.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  myListingCtrl.isLoading
                                      ? Helpers.appLoader()
                                      : myListingCtrl.myListingList.isEmpty
                                          ? Helpers.notFound(
                                              text: "No listings found")
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: myListingCtrl.myListingList.length,
                                              itemBuilder: (context, i) {
                                                var data = myListingCtrl.myListingList[i];
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 16.h),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 12.w,
                                                        height: 240.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .darkCardColorDeep
                                                              : AppColors
                                                                  .mainColor
                                                                  .withValues(
                                                                      alpha:
                                                                          .2),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    4.r),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    4.r),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: 240.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      11.w,
                                                                  vertical:
                                                                      16.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppThemes
                                                                .getFillColor(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      4.r),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          4.r),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      data.categories
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: t
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                  HSpace(20.w),
                                                                  buildPopupMenu(
                                                                      t,
                                                                      data,
                                                                      manageListingCtrl,
                                                                      storedLanguage),
                                                                ],
                                                              ),
                                                              Divider(
                                                                  color: AppThemes
                                                                      .getSliderInactiveColor()),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Package'] ??
                                                                        "Package",
                                                                    style: t
                                                                        .bodyMedium,
                                                                  ),
                                                                  HSpace(20.w),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        data.purchasePackageName
                                                                            .toString(),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: t
                                                                            .bodyMedium
                                                                            ?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor.withValues(alpha: .5)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Listing'] ??
                                                                        "Listing",
                                                                    style: t
                                                                        .bodyMedium,
                                                                  ),
                                                                  HSpace(20.w),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        "${data.listingTitle.toString()}",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: t
                                                                            .bodyMedium
                                                                            ?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor.withValues(alpha: .5)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Location'] ??
                                                                        "Location",
                                                                    style: t
                                                                        .bodyMedium,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        data.address
                                                                            .toString(),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: t
                                                                            .bodyMedium
                                                                            ?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor.withValues(alpha: .5)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Stage'] ??
                                                                        "Stage",
                                                                    style: t
                                                                        .bodyMedium,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                2.h,
                                                                            horizontal: 8.w),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              width: .5,
                                                                              color: data.status.toString() == "0"
                                                                                  ? AppColors.pendingColor
                                                                                  : data.status.toString() == "1"
                                                                                      ? AppColors.approvedColor
                                                                                      : AppColors.redColor),
                                                                          color: data.status.toString() == "0"
                                                                              ? AppColors.pendingColor.withValues(alpha: .1)
                                                                              : data.status.toString() == "1"
                                                                                  ? AppColors.approvedColor.withValues(alpha: .1)
                                                                                  : AppColors.redColor.withValues(alpha: .1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(16.r),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          data.status.toString() == "0"
                                                                              ? "Pending"
                                                                              : data.status.toString() == "1"
                                                                                  ? "Approved"
                                                                                  : "Rejected",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: t.bodyMedium?.copyWith(
                                                                              fontSize: 14.sp,
                                                                              color: data.status.toString() == "0"
                                                                                  ? AppColors.pendingColor
                                                                                  : data.status.toString() == "1"
                                                                                      ? AppColors.approvedColor
                                                                                      : AppColors.redColor),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Status'] ??
                                                                        "Status",
                                                                    style: t
                                                                        .bodyMedium,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                2.h,
                                                                            horizontal: 12.w),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              width: .5,
                                                                              color: data.isActive.toString() == "1" ? AppColors.greenColor : AppColors.redColor),
                                                                          color: data.isActive.toString() == "1"
                                                                              ? AppColors.greenColor.withValues(alpha: .1)
                                                                              : AppColors.redColor.withValues(alpha: .1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(16.r),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          data.isActive.toString() == "1"
                                                                              ? "Active"
                                                                              : "Deactive",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: t.bodyMedium?.copyWith(
                                                                              fontSize: 14.sp,
                                                                              color: data.isActive.toString() == "1" ? AppColors.greenColor : AppColors.redColor),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                ],
                              )),
                        ),
                      ),
                      if (myListingCtrl.isLoadMore == true)
                        Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            child: Helpers.appLoader()),
                      VSpace(20.h),
                    ],
                  ),
                  // if (addListingCtrl.isGettingEdit)
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Row buildAddListingWidget(BuildContext context, storedLanguage, TextTheme t,
      ManageListingController manageListingCtrl, MyListingController listingCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          borderRadius: Dimensions.kBorderRadius,
          onTap: () {
            buildDialog(context, storedLanguage, t, manageListingCtrl);
          },
          child: Container(
            width: 140.w,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.add,
                  size: 22.h,
                  color: AppColors.blackColor,
                ),
                Text(
                  storedLanguage['Add Listing'] ?? "Add Listing",
                  style: context.t.bodyMedium
                      ?.copyWith(color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            buildFilterDialog(context, t, listingCtrl, storedLanguage);
          },
          child: Container(
            width: 90.w,
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "$rootImageDir/filter_2.png",
                  height: 18.h,
                  width: 18.h,
                  color: AppColors.blackColor,
                ),
                Text(
                  storedLanguage['Filter'] ?? "Filter",
                  style: context.t.bodyMedium
                      ?.copyWith(color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildDialog(BuildContext context, storedLanguage, TextTheme t,
      ManageListingController manageListingCtrl) {
    appDialog(
        context: context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(storedLanguage['Select Package'] ?? "Select package",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<ManageListingController>(builder: (_) {
              return Container(
                height: 46.h,
                padding: EdgeInsets.only(left: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppThemes.getSliderInactiveColor()),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: DropdownButton<int>(
                  hint: Text(
                    manageListingCtrl.purchasePackageList.isEmpty
                        ? "No Packages"
                        : storedLanguage['Select Package'] ?? "Select Package",
                    style: context.t.bodySmall
                        ?.copyWith(color: AppColors.textFieldHintColor),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  value: manageListingCtrl.selectedPurchasePackage,
                  onChanged: manageListingCtrl.onChangePackage,
                  items: manageListingCtrl.purchasePackageList
                      .map((e) => DropdownMenuItem<int>(
                            value:
                                e.id == null ? 0 : int.parse(e.id.toString()),
                            child: Text(
                              e.title,
                              style: context.t.displayMedium,
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
            VSpace(24.h),
            Text(
                storedLanguage['Number of availabe listing'] ??
                    "Number of available listing",
                style: t.displayMedium),
            VSpace(10.h),
            IgnorePointer(
              ignoring: true,
              child: CustomTextField(
                hintext: storedLanguage['Number of availabe listing'] ??
                    "Number of available listing",
                controller: manageListingCtrl.availableListingEditingCtrl,
              ),
            ),
            VSpace(28.h),
            AppButton(
              text: storedLanguage['Create'] ?? "Create",
              onTap: () async {
                if (manageListingCtrl
                    .availableListingEditingCtrl.text.isEmpty) {
                  Helpers.showSnackBar(
                      msg: "Please select package to continue");
                } else if (manageListingCtrl.availableListingEditingCtrl.text !=
                        "null" &&
                    (int.parse(manageListingCtrl
                            .availableListingEditingCtrl.text
                            .toString()) >
                        0)) {
                  Get.back();
                  manageListingCtrl.refreshAllValue();
                  Get.toNamed(RoutesName.addListingScreen);
                } else {
                  Helpers.showSnackBar(
                      msg: "You are not eligible for creating listing");
                }
              },
            ),
          ],
        ));
  }

  CustomAppBar buildAppbar(storedLanguage) {
    return CustomAppBar(
      title: storedLanguage['My Listings'] ?? "My Listings",
      onBackPressed: () {
        Get.back();
        ManageListingController.to.refreshAllValue();
      },
    );
  }

  buildFilterDialog(BuildContext context, TextTheme t, MyListingController myListingCtrl,
      dynamic storedLanguage) {
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
              hintext: storedLanguage['Listing title'] ?? "Listing title",
              controller: myListingCtrl.listingNameEditingCtrlr,
            ),
            VSpace(24.h),
            Container(
              height: 46.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppThemes.getSliderInactiveColor()),
                borderRadius: Dimensions.kBorderRadius,
              ),
              child: DropDownMultiSelect(
                onChanged: ManageListingController.to.onChangedCategories,
                options: ManageListingController.to.listingCategoryList
                    .map((e) => e.name.toString())
                    .toList(),
                selectedValues: ManageListingController.to.selectedCategoryList,
                whenEmpty:
                    storedLanguage['Select Categories'] ?? 'Select Categories',
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: AppThemes.getDarkBgColor(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.r),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.r),
                      )),
                ),
              ),
            ),
            VSpace(28.h),
            AppButton(
              text: storedLanguage['Search Now'] ?? "Search Now",
              onTap: () async {
                Get.back();
                myListingCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
                await myListingCtrl.getMyListings(
                    page: 1, listing_name: myListingCtrl.listingNameEditingCtrlr.text);
              },
            ),
          ],
        ));
  }

  PopupMenuButton<String> buildPopupMenu(TextTheme t, listing.Datum data,
      ManageListingController manageListingCtrl, dynamic storedLanguage) {
    return PopupMenuButton<String>(
      color: AppThemes.getDarkBgColor(),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (data.status.toString() != "2")
          PopupMenuItem<String>(
            onTap: () async {
              AnalyticController.to.listingId = data.id.toString();
              await AnalyticController.to
                  .resetDataAfterSearching(isFromOnRefreshIndicator: true);
              Get.toNamed(RoutesName.myAnalyticsScreen);
            },
            value: 'option1',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "$rootImageDir/chart.png",
                  width: 14.h,
                  height: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(storedLanguage['Analytics'] ?? 'Analytics',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if (data.status.toString() != "2")
          PopupMenuItem<String>(
            onTap: () {
              ListingReviewController.to.listingId = data.id.toString();
              Get.toNamed(RoutesName.reviewListScreen);
            },
            value: 'option2',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_outline,
                  color: AppThemes.getIconBlackColor(),
                  size: 18.h,
                ),
                HSpace(10.w),
                Text(storedLanguage['Reviews'] ?? 'Reviews',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if (data.status.toString() != "2")
          PopupMenuItem<String>(
            onTap: () {
              DynamicFormController.to.listingId = data.id.toString();
              Get.toNamed(RoutesName.dynamicFormScreen);
            },
            value: 'option3',
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
                Text(storedLanguage['Form Data'] ?? 'Form Data',
                    style: t.bodyMedium),
              ],
            ),
          ),
        if (data.status.toString() != "2")
          PopupMenuItem<String>(
            onTap: () async {
              manageListingCtrl.listingId = data.id.toString();
              manageListingCtrl.geteditListing(listingId: data.id.toString());
              if (manageListingCtrl.isGettingEdit) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 25.h,
                            width: 25.h,
                            child: CircularProgressIndicator(
                                color: AppColors.mainColor),
                          ),
                          HSpace(12.w),
                          Text("Loading...", style: t.displayMedium),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            value: 'option4',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "$rootImageDir/edit.png",
                  width: 14.h,
                  height: 14.h,
                  color: AppThemes.getIconBlackColor(),
                ),
                HSpace(10.w),
                Text(storedLanguage['Edit'] ?? 'Edit', style: t.bodyMedium),
              ],
            ),
          ),
        PopupMenuItem<String>(
          onTap: () {
            MyListingController.to.deleteListing(listingId: data.id.toString());
          },
          value: 'option5',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "$rootImageDir/delete_account.png",
                width: 14.h,
                height: 14.h,
                color: AppThemes.getIconBlackColor(),
              ),
              HSpace(10.w),
              Text(storedLanguage['Delete'] ?? 'Delete', style: t.bodyMedium),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          Icons.more_vert,
          size: 20.h,
        ),
      ),
    );
  }
}
