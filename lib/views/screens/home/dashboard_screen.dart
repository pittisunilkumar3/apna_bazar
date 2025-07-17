import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/shimmer_card.dart';
import '../../widgets/spacing.dart';
import 'home_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
      return Scaffold(
        appBar: CustomAppBar(title: storedLanguage['Dashboard'] ?? 'Dashboard'),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            dashboardCtrl.getDashboard();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VSpace(40.h),
                  Row(
                    children: [
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Total Listing'] ??
                                  "Total Listing",
                              isIconSmall: true,
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.totalListing.toString(),
                              img: 'active_listing'),
                      HSpace(20.w),
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Active Listing'] ??
                                  "Active Listing",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.activeListing.toString(),
                              img: 'listing'),
                    ],
                  ),
                  VSpace(20.h),
                  Row(
                    children: [
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Pending Listings'] ??
                                  "Pending Listings",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.pendingListing.toString(),
                              img: 'pending_listing'),
                      HSpace(20.w),
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Views'] ?? "Views",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.totalViews.toString(),
                              img: 'views'),
                    ],
                  ),
                  VSpace(20.h),
                  Row(
                    children: [
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Products'] ?? "Products",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.totalProduct.toString(),
                              img: 'products'),
                      HSpace(20.w),
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Unseen Enquiries'] ??
                                  "Unseen Enquiries",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.totalProductQuires.toString(),
                              img: 'enquiries'),
                    ],
                  ),
                  VSpace(20.h),
                  Row(
                    children: [
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Active Package'] ??
                                  "Active Package",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.activePackage.toString(),
                              img: 'delivery1'),
                      HSpace(20.w),
                      dashboardCtrl.isLoading
                          ? Expanded(child: ShimmerCard())
                          : buildDashboardWidget(t, storedLanguage,
                              title: storedLanguage['Pending Package'] ??
                                  "Pending Package",
                              value: dashboardCtrl.data == null
                                  ? "0"
                                  : dashboardCtrl.data!.pendingPackage.toString(),
                              img: 'delivery2'),
                    ],
                  ),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
