import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/controllers/anatytics_details_controller.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/spacing.dart';

class MyAnalyticsDetailsScreen extends StatelessWidget {
  const MyAnalyticsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AnalyticDetailsController>(builder: (analyticDetailsCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
            title: storedLanguage['My Analytics Details'] ??
                "My Analytics Details"),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            analyticDetailsCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await analyticDetailsCtrl.analyticsDetails(page: 1, id: analyticDetailsCtrl.id);
          },
          child: SingleChildScrollView(
              controller: analyticDetailsCtrl.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  children: [
                    VSpace(30.h),
                    analyticDetailsCtrl.isLoading
                        ? Helpers.appLoader()
                        : analyticDetailsCtrl.analyticDetailsList.isEmpty
                            ? Helpers.notFound(text: "No details found")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: analyticDetailsCtrl.analyticDetailsList.length,
                                itemBuilder: (context, i) {
                                  var data = analyticDetailsCtrl.analyticDetailsList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12.w,
                                          height: 170.h,
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
                                            height: 170.h,
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
                                                        storedLanguage[
                                                                'Operating System'] ??
                                                            "Operating System",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                    HSpace(20.w),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          data.osPlatform
                                                              .toString(),
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
                                                              'Browser'] ??
                                                          "Browser",
                                                      style: t.bodyMedium,
                                                    ),
                                                    HSpace(20.w),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${data.browser.toString()}",
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
                                                              'Date and Time'] ??
                                                          "Date and Time",
                                                      style: t.bodyMedium,
                                                    ),
                                                    HSpace(20.w),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          data.createdAt == null
                                                              ? ""
                                                              : "${DateFormat('dd MMM, yyyy hh:mm a').format(DateTime.parse(data.createdAt.toString()).toLocal())}",
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
                    if (analyticDetailsCtrl.isLoadMore == true)
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
}
