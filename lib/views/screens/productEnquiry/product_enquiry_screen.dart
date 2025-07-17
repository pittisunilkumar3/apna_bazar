import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/product_enquiry_controller.dart';
import 'package:listplace/controllers/product_enquiry_conv_controller.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../controllers/frontend_listing_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import 'product_enquiry_inbox_screen.dart';

class ProductEnquiryScreen extends StatelessWidget {
  const ProductEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProductEnquiryConvController>(builder: (convCtrl) {
      return GetBuilder<ProductEnquiryController>(builder: (productEnquiryCtrl) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Get.put(PushNotificationController()).getPushNotificationConfig();
            Get.back();
          },
          child: Scaffold(
            appBar: buildAppBar(storedLanguage, context, t, productEnquiryCtrl),
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
                          productEnquiryCtrl.pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          productEnquiryCtrl.selectedIndex = 0;
                          productEnquiryCtrl.enquiryType = "customer";
                          productEnquiryCtrl.resetDataAfterSearching();
                          productEnquiryCtrl.getCustomerEnquiryList(
                              page: 1,
                              enquiryType: "customer",
                              name: '',
                              from_date: '',
                              to_date: '');
                          productEnquiryCtrl.update();
                        },
                        child: Ink(
                          child: Column(
                            children: [
                              Text("Customer Enquiry", style: t.bodyMedium),
                              VSpace(5.h),
                              Container(
                                width: 140.w,
                                height: .6.h,
                                color: productEnquiryCtrl.selectedIndex == 0
                                    ? AppThemes.getIconBlackColor()
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          productEnquiryCtrl.pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );

                          productEnquiryCtrl.selectedIndex = 1;
                          productEnquiryCtrl.enquiryType = "my";
                          productEnquiryCtrl.resetDataAfterSearching();
                          productEnquiryCtrl.getCustomerEnquiryList(
                              page: 1,
                              enquiryType: "my",
                              name: '',
                              from_date: '',
                              to_date: '');
                          productEnquiryCtrl.update();
                        },
                        child: Ink(
                          child: Column(
                            children: [
                              Text("My Enquiry", style: t.bodyMedium),
                              VSpace(5.h),
                              Container(
                                width: 140.w,
                                height: .6.h,
                                color: productEnquiryCtrl.selectedIndex == 1
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
                  if (productEnquiryCtrl.isLoading) Helpers.appLoader(),
                  if (!productEnquiryCtrl.isLoading)
                    Expanded(
                      child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: productEnquiryCtrl.pageController,
                          onPageChanged: (i) {
                            productEnquiryCtrl.selectedIndex = i;
                            productEnquiryCtrl.update();
                          },
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return RefreshIndicator(
                              color: AppColors.mainColor,
                              onRefresh: () async {
                                productEnquiryCtrl.resetDataAfterSearching(
                                    isFromOnRefreshIndicator: true);
                                await productEnquiryCtrl.getCustomerEnquiryList(
                                    page: 1,
                                    enquiryType: productEnquiryCtrl.enquiryType,
                                    name: '',
                                    from_date: '',
                                    to_date: '');
                              },
                              child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: productEnquiryCtrl.scrollController,
                                  itemCount: productEnquiryCtrl.productEnquiryList.isEmpty
                                      ? 1
                                      : productEnquiryCtrl.productEnquiryList.length,
                                  itemBuilder: (context, i) {
                                    if (productEnquiryCtrl.productEnquiryList.isEmpty) {
                                      return Helpers.notFound(
                                          text: "No enquires found");
                                    }
                                    var data = productEnquiryCtrl.productEnquiryList[i];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: InkWell(
                                        borderRadius: Dimensions.kBorderRadius,
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
                                          height: 138.h,
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 13.h),
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
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
                                                        color:
                                                            AppColors.greyColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            data.listingClient ==
                                                                    null
                                                                ? ""
                                                                : data
                                                                    .listingClient!
                                                                    .imgPath
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
                                                              data.listingClient ==
                                                                      null
                                                                  ? ""
                                                                  : data.listingClient!
                                                                          .firstname
                                                                          .toString() +
                                                                      " ${data.listingClient!.lastname}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: t
                                                                  .displayMedium),
                                                          Text(
                                                              data.listingClient ==
                                                                      null
                                                                  ? ""
                                                                  : data
                                                                      .listingClient!
                                                                      .email
                                                                      .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
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
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                        ]),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              data.listing ==
                                                                      null
                                                                  ? ""
                                                                  : data
                                                                      .listing!
                                                                      .title
                                                                      .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  t.bodySmall),
                                                          Text(
                                                              data.createdAt ==
                                                                      null
                                                                  ? ""
                                                                  : "${DateFormat("dd MMM yyyy").format(DateTime.parse(data.createdAt.toString()))}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
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
                                                                    FontWeight
                                                                        .w400,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkResponse(
                                                    onTap: () {
                                                      ProductEnquiryConvController
                                                              .to
                                                              .selectedEnquiryId =
                                                          data.id.toString();
                                                      convCtrl
                                                          .getProductEnquiryConvList(
                                                              id: data.id
                                                                  .toString());

                                                      Get.to(() =>
                                                          ProductEnquiryInboxScreen(
                                                            productQueryId: data
                                                                .id
                                                                .toString(),
                                                            clientId: data
                                                                .clientId
                                                                .toString(),
                                                          ));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8.h),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.black10,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                        "$rootImageDir/message.png",
                                                        height: 15.h,
                                                        fit: BoxFit.cover,
                                                        color: AppThemes
                                                            .getParagraphColor(),
                                                      ),
                                                    ),
                                                  ),
                                                  PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onSelected: (value) async {
                                                      if (value == "option1") {
                                                        ProductEnquiryConvController
                                                                .to
                                                                .selectedEnquiryId =
                                                            data.id.toString();
                                                        convCtrl
                                                            .getProductEnquiryConvList(
                                                                id: data.id
                                                                    .toString());

                                                        Get.to(() =>
                                                            ProductEnquiryInboxScreen(
                                                              productQueryId: data
                                                                  .id
                                                                  .toString(),
                                                              clientId: data
                                                                  .clientId
                                                                  .toString(),
                                                            ));
                                                      }
                                                      if (value == "option2") {
                                                        await convCtrl
                                                            .deleteProductEnqu(
                                                                id: data.id
                                                                    .toString());
                                                      }
                                                    },
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <PopupMenuEntry<
                                                            String>>[
                                                      PopupMenuItem<String>(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        value: 'option1',
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            HSpace(20.w),
                                                            Text('Send Reply',
                                                                style: t
                                                                    .bodyMedium),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        value: 'option2',
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            HSpace(20.w),
                                                            Text('Delete',
                                                                style: t
                                                                    .bodyMedium),
                                                          ],
                                                        ),
                                                      ),

                                                      // Add more menu items as needed
                                                    ],
                                                    child: Image.asset(
                                                      "$rootImageDir/option.png",
                                                      height: 20.h,
                                                      width: 20.h,
                                                      color: AppThemes
                                                          .getParagraphColor(),
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
                            );
                          }),
                    ),
                  if (productEnquiryCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  CustomAppBar buildAppBar(storedLanguage, BuildContext context, TextTheme t,
      ProductEnquiryController productEnquiryCtrl) {
    return CustomAppBar(
      title: storedLanguage['Product Enquiry'] ?? "Product Enquiry",
      onBackPressed: () {
        Get.put(PushNotificationController()).getPushNotificationConfig();
        Get.back();
      },
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
                    CustomTextField(
                      hintext:
                          storedLanguage['Listing Title'] ?? "Listing Title",
                      controller: productEnquiryCtrl.listingNameEditingCtrlr,
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
                                        productEnquiryCtrl.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(args.value.startDate);
                                        productEnquiryCtrl.toDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd').format(
                                                args.value.endDate ??
                                                    args.value.startDate);
                                        productEnquiryCtrl.textEditingController.text =
                                            productEnquiryCtrl.fromDateEditingCtrlr.text +
                                                " to " +
                                                productEnquiryCtrl.toDateEditingCtrlr.text;
                                      }
                                    },
                                    onSubmit: (Object? value) {
                                      if (value is PickerDateRange) {
                                        productEnquiryCtrl.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(value.startDate!);
                                        productEnquiryCtrl.toDateEditingCtrlr.text =
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
                          controller: productEnquiryCtrl.textEditingController,
                        ),
                      ),
                    ),
                    VSpace(28.h),
                    AppButton(
                      text: storedLanguage['Search Now'] ?? "Search Now",
                      onTap: () async {
                        Get.back();

                        productEnquiryCtrl.resetDataAfterSearching();
                        await productEnquiryCtrl
                            .getCustomerEnquiryList(
                                page: 1,
                                enquiryType: productEnquiryCtrl.enquiryType,
                                name: productEnquiryCtrl.listingNameEditingCtrlr.text,
                                from_date: productEnquiryCtrl.fromDateEditingCtrlr.text,
                                to_date: productEnquiryCtrl.toDateEditingCtrlr.text)
                            .then((value) {
                          productEnquiryCtrl.fromDateEditingCtrlr.clear();
                          productEnquiryCtrl.toDateEditingCtrlr.clear();
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
