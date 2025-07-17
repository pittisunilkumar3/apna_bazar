import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listplace/config/app_colors.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/bindings/controller_index.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../../routes/page_index.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class ListingCategoryScreen extends StatelessWidget {
  final bool? isFromHomePage;
  final bool? isFromFrontendDemoPage;
  ListingCategoryScreen(
      {super.key,
      this.isFromHomePage = false,
      this.isFromFrontendDemoPage = false});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
            title:
                storedLanguage['Listing Categories'] ?? 'Listing Categories'),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(25.h),
              CustomTextField(
                  height: 46.h,
                  hintext: 'Search Here',
                  prefixIcon: 'search',
                  isBorderColor: false,
                  fillColor: AppThemes.getFillColor(),
                  controller: manageListingCtrl.searchCategoryEditingCtrlr,
                  onChanged: manageListingCtrl.onSearchChanged),
              VSpace(40.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.mainColor,
                  onRefresh: () async {
                    manageListingCtrl.getListingCategories();
                  },
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: manageListingCtrl.isCategorySearching
                          ? manageListingCtrl.searchListingCategoryList.length
                          : manageListingCtrl.listingCategoryList.length,
                      itemBuilder: (context, i) {
                        var data = manageListingCtrl.isCategorySearching
                            ? manageListingCtrl.searchListingCategoryList[i]
                            : manageListingCtrl.listingCategoryList[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: InkWell(
                            borderRadius: Dimensions.kBorderRadius,
                            onTap: () {
                              Get.to(() => AllListingScreen(
                                  isFromListingCategoryPage: true));
                              FrontendListingController.to.searchEditingCtrlr
                                  .clear();
                              FrontendListingController.to
                                  .resetDataAfterSearching();
                              FrontendListingController.to.selectedCategoryId =
                                  data.id.toString();

                              FrontendListingController.to
                                  .getFrontendListngList(
                                      page: 1,
                                      search: "",
                                      country_id: "",
                                      city_id: "",
                                      categoryId: data.id.toString());
                              FrontendListingController.to.update();
                            },
                            child: Ink(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40.h,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.mainColor,
                                            ),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        data.image
                                                            .toString()))),
                                      ),
                                      HSpace(16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: context.t.bodyMedium
                                                  ?.copyWith(
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                            VSpace(5.h),
                                            Text(
                                                data.total_listing.toString() +
                                                    " Location",
                                                style: context.t.displayMedium),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 38.h,
                                        height: 38.h,
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColor
                                              : AppColors.fillColor2,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          "$rootImageDir/rotate_arrow.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VSpace(15.h),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: AppThemes.getSliderInactiveColor(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
