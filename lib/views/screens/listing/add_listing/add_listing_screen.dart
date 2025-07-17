import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import '../../../../config/app_colors.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';

class AddListingScreen extends StatelessWidget {
  final bool? isFromEditListing;
  const AddListingScreen({super.key, this.isFromEditListing = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return DefaultTabController(
        length: manageListingCtrl.categoryDemoList().length,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            manageListingCtrl.refreshAllValue();
            Get.back();
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: isFromEditListing == true
                  ? storedLanguage['Edit Listing'] ?? "Edit Listing"
                  : storedLanguage['Add Listing'] ?? "Add Listing",
              onBackPressed: () {
                Get.back();
                if (isFromEditListing == false) {
                  manageListingCtrl.refreshAllValue();
                }
              },
            ),
            body: Builder(builder: (context) {
              manageListingCtrl.tabControllFunc(context);
              manageListingCtrl.tabControllFunc(context).addListener(() {
                if (manageListingCtrl.tabControllFunc(context).indexIsChanging ||
                    manageListingCtrl.tabControllFunc(context).index != manageListingCtrl.selectedTabIndex) {
                  manageListingCtrl.selectedTabIndex = manageListingCtrl.tabControllFunc(context).index;
                  manageListingCtrl.update();
                }
              });

              return Column(
                children: [
                  Padding(
                    padding: Dimensions.kDefaultPadding,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        borderRadius: Dimensions.kBorderRadius / 1.2,
                      ),
                      child: TabBar(
                        controller: manageListingCtrl.tabControllFunc(context),
                        onTap: (index) {
                          manageListingCtrl.selectedTabIndex = index;
                          manageListingCtrl.update();
                        },
                        splashBorderRadius: Dimensions.kBorderRadius,
                        labelPadding: EdgeInsets.only(right: 24.w, left: 24.w),
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: List.generate(
                          manageListingCtrl.categoryDemoList().length,
                          (i) => Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: manageListingCtrl.selectedTabIndex == i
                                            ? AppColors.mainColor
                                            : Colors.transparent,
                                        width: 4.h))),
                            child: Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Text(
                                manageListingCtrl.categoryDemoList()[i],
                                style: t.bodyMedium?.copyWith(
                                  color: manageListingCtrl.selectedTabIndex == i
                                      ? AppThemes.getIconBlackColor()
                                      : Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: manageListingCtrl.categoryTabViewList(isFromEditListing),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
