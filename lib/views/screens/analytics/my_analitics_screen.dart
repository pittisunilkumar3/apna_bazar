import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/controllers/analytics_controller.dart';
import 'package:listplace/controllers/anatytics_details_controller.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../config/styles.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class MyAnalyticsScreen extends StatefulWidget {
  const MyAnalyticsScreen({super.key});

  @override
  State<MyAnalyticsScreen> createState() => _MyAnalyticsScreenState();
}

class _MyAnalyticsScreenState extends State<MyAnalyticsScreen> {
  @override
  void initState() {
    AnalyticController.to.resetDataAfterSearching();
    AnalyticController.to.getAnalyticList(
        page: AnalyticController.to.page,
        listing_name: "",
        from_date: "",
        to_date: "",
        listingId: AnalyticController.to.listingId.isEmpty
            ? null
            : AnalyticController.to.listingId);
    AnalyticController.to.scrollController = ScrollController()
      ..addListener(AnalyticController.to.loadMore);
    super.initState();
  }

  @override
  void dispose() {
    AnalyticController.to.scrollController.dispose();
    AnalyticController.to.isLoading = false;
    AnalyticController.to.analyticList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<AnalyticController>(builder: (analyticCtrl) {
      return Scaffold(
        appBar: buildAppBar(storedLanguage, context, t, analyticCtrl),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            analyticCtrl.textEditingController.clear();
            analyticCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await analyticCtrl.getAnalyticList(
                page: 1,
                listing_name: '',
                from_date: '',
                to_date: '',
                listingId: AnalyticController.to.listingId == "0"
                    ? null
                    : AnalyticController.to.listingId);
          },
          child: SingleChildScrollView(
              controller: analyticCtrl.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  children: [
                    VSpace(30.h),
                    analyticCtrl.isLoading
                        ? Helpers.appLoader()
                        : analyticCtrl.analyticList.isEmpty
                            ? Helpers.notFound(text: "No analytics found")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: analyticCtrl.analyticList.length,
                                itemBuilder: (context, i) {
                                  var data = analyticCtrl.analyticList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12.w,
                                          height: 180.h,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.darkCardColorDeep
                                                : AppColors.mainColor
                                                    .withValues(alpha: .2),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.r),
                                              bottomLeft: Radius.circular(4.r),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 180.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11.w,
                                                vertical: 16.h),
                                            decoration: BoxDecoration(
                                              color: AppThemes.getFillColor(),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(4.r),
                                                bottomRight:
                                                    Radius.circular(4.r),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data.listingTitle
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                    HSpace(20.w),
                                                    InkResponse(
                                                      onTap: () {
                                                        AnalyticDetailsController
                                                                .to.id =
                                                            data.listingId
                                                                .toString();
                                                        AnalyticDetailsController
                                                            .to
                                                            .resetDataAfterSearching();
                                                        AnalyticDetailsController
                                                            .to
                                                            .analyticsDetails(
                                                                page: 1,
                                                                id: data
                                                                    .listingId
                                                                    .toString());
                                                        Get.toNamed(RoutesName
                                                            .myAnalyticsDetailsScreen);
                                                      },
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  7.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .darkCardColorDeep
                                                                : AppColors
                                                                    .black10,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .remove_red_eye_outlined,
                                                            size: 18.h,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                    color: AppThemes
                                                        .getSliderInactiveColor()),
                                                Row(
                                                  children: [
                                                    Text(
                                                      storedLanguage[
                                                              'Country'] ??
                                                          "Country",
                                                      style: t.bodyMedium,
                                                    ),
                                                    HSpace(20.w),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          data.country == null
                                                              ? "N/A"
                                                              : "${data.country.toString()}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .blackColor
                                                                      .withValues(
                                                                          alpha:
                                                                              .5)),
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
                                                              'Total Visit'] ??
                                                          "Total Visit",
                                                      style: t.bodyMedium,
                                                    ),
                                                    HSpace(20.w),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${data.totalVisit.toString()}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .blackColor
                                                                      .withValues(
                                                                          alpha:
                                                                              .5)),
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
                                                              'Last Visited At'] ??
                                                          "Last Visited At",
                                                      style: t.bodyMedium,
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          data.lastVisited ==
                                                                  null
                                                              ? ""
                                                              : "${DateFormat('dd MMM, yyyy hh:mm a').format(DateTime.parse(data.lastVisited.toString()).toLocal())}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .blackColor
                                                                      .withValues(
                                                                          alpha:
                                                                              .5)),
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
                    if (analyticCtrl.isLoadMore == true)
                      Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                          child: Helpers.appLoader()),
                    VSpace(20.h),
                  ],
                ),
              )),
        ),
      );
    });
  }

  CustomAppBar buildAppBar(
      storedLanguage, BuildContext context, TextTheme t, AnalyticController analyticCtrl) {
    return CustomAppBar(
      title: storedLanguage['My Analytics'] ?? "My Analytics",
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
                          storedLanguage['Listing title'] ?? "Listing title",
                      controller: analyticCtrl.listingNameEditingCtrlr,
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
                                        analyticCtrl.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(args.value.startDate);
                                        analyticCtrl.toDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd').format(
                                                args.value.endDate ??
                                                    args.value.startDate);
                                        analyticCtrl.textEditingController.text =
                                            analyticCtrl.fromDateEditingCtrlr.text +
                                                " to " +
                                                analyticCtrl.toDateEditingCtrlr.text;
                                      }
                                    },
                                    onSubmit: (Object? value) {
                                      if (value is PickerDateRange) {
                                        analyticCtrl.fromDateEditingCtrlr.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(value.startDate!);
                                        analyticCtrl.toDateEditingCtrlr.text =
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
                          controller: analyticCtrl.textEditingController,
                        ),
                      ),
                    ),
                    VSpace(28.h),
                    AppButton(
                      text: storedLanguage['Search Now'] ?? "Search Now",
                      onTap: () async {
                        analyticCtrl.resetDataAfterSearching();

                        Get.back();
                        await analyticCtrl
                            .getAnalyticList(
                          page: 1,
                          listing_name: analyticCtrl.listingNameEditingCtrlr.text,
                          from_date: analyticCtrl.fromDateEditingCtrlr.text,
                          to_date: analyticCtrl.toDateEditingCtrlr.text,
                        )
                            .then((value) {
                          analyticCtrl.fromDateEditingCtrlr.clear();
                          analyticCtrl.toDateEditingCtrlr.clear();
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
