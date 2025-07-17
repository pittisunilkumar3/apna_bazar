import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listplace/controllers/bindings/controller_index.dart';
import 'package:listplace/routes/page_index.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/screens/listing/frontend_listings/listing_categories_screen.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:slide_action/slide_action.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/my_listing_tile.dart';
import '../../../widgets/shimmer_card.dart';
import '../../../widgets/spacing.dart';

class FrontendListingDemoScreen extends StatelessWidget {
  const FrontendListingDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return GetBuilder<FrontendListingController>(builder: (frontendCtrl) {
        return Scaffold(
          appBar: CustomAppBar(
            onBackPressed: () {
              Get.to(() => LoginScreen());
            },
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                icon: Image.asset(
                  "$rootImageDir/exit.png",
                  height: 26.h,
                  width: 26.h,
                  color:
                      Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              await manageListingCtrl.getListingCategories();
              await manageListingCtrl.getCountryList();
            },
            child: SingleChildScrollView(
              controller: manageListingCtrl.scrollController,
              child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        VSpace(20.h),
                        CustomTextField(
                            height: 46.h,
                            borderRadius: Dimensions.kBorderRadius,
                            isBorderColor: true,
                            hintext: "What are you are looking for?",
                            prefixIcon: 'search',
                            prefixPadding:
                                EdgeInsets.only(left: 15.w, right: 8.w),
                            prefixSize: 14.h,
                            minPrefixSize: 14.h,
                            controller: FrontendListingController
                                .to.searchEditingCtrlr),
                        VSpace(24.h),
                        Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppThemes.getSliderInactiveColor()),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: AppCustomDropDown(
                            bgColor: AppThemes.getDarkCardColor(),
                            height: 46.h,
                            width: double.infinity,
                            items: manageListingCtrl.listingCategoryFrontendList
                                .map((e) => e.name.toString())
                                .toList(),
                            selectedValue: manageListingCtrl.selectedCategory,
                            onChanged: (v) {
                              manageListingCtrl.selectedCategory = v;
                              manageListingCtrl.selectedCategoryId = manageListingCtrl
                                  .listingCategoryFrontendList
                                  .firstWhere(
                                      (e) => e.name.toString() == v.toString())
                                  .id
                                  .toString();
                              manageListingCtrl.update();
                            },
                            hint: storedLanguage['Select Category'] ??
                                "Select Category",
                            searchEditingCtrl: manageListingCtrl.categoryEditingCtrl,
                            searchHintext: storedLanguage['Search Category'] ??
                                "Search Category",
                            fontSize: 14.sp,
                            hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textFieldHintColor),
                          ),
                        ),
                        VSpace(24.h),
                        Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppThemes.getSliderInactiveColor()),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: AppCustomDropDown(
                            bgColor: AppThemes.getDarkCardColor(),
                            height: 46.h,
                            width: double.infinity,
                            items: manageListingCtrl.countryList
                                .map((e) => e.name.toString())
                                .toList(),
                            selectedValue: manageListingCtrl.selectedCountry,
                            onChanged: manageListingCtrl.onChangedCountry,
                            hint: storedLanguage['Select Country'] ??
                                "Select Country",
                            searchEditingCtrl: manageListingCtrl.countryEditingCtrlr,
                            searchHintext: storedLanguage['Search Country'] ??
                                "Search Country",
                            fontSize: 14.sp,
                            hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textFieldHintColor),
                          ),
                        ),
                        VSpace(24.h),
                        Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppThemes.getSliderInactiveColor()),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: AppCustomDropDown(
                            bgColor: AppThemes.getDarkCardColor(),
                            height: 46.h,
                            width: double.infinity,
                            items: manageListingCtrl.cityList
                                .map((e) => e.name.toString())
                                .toList(),
                            selectedValue: manageListingCtrl.selectedCity,
                            onChanged: manageListingCtrl.onChangedCity,
                            hint:
                                storedLanguage['Select City'] ?? "Select City",
                            searchHintext:
                                storedLanguage['Search City'] ?? "Search City",
                            searchEditingCtrl: manageListingCtrl.cityEditingCtrlr,
                            fontSize: 14.sp,
                            hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textFieldHintColor),
                          ),
                        ),
                        VSpace(24.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SlideAction(
                                trackHeight: 55.h,
                                actionSnapThreshold: 1,
                                stretchThumb: true,
                                trackBuilder: (context, state) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                          color: AppThemes
                                              .getSliderInactiveColor()),
                                    ),
                                    child: Center(
                                      child: state.isPerformingAction
                                          ? Helpers.appLoader()
                                          : Text("Slide to search",
                                              style: t.bodyMedium),
                                    ),
                                  );
                                },
                                thumbBuilder: (context, state) {
                                  return Container(
                                    margin: EdgeInsets.all(6.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                                action: () async {
                                  FrontendListingController.to
                                      .resetDataAfterSearching();
                                  FrontendListingController.to
                                      .getFrontendListngList(
                                          page: 1,
                                          search: FrontendListingController
                                              .to.searchEditingCtrlr.text,
                                          country_id: manageListingCtrl.selectedCountryId ==
                                                  null
                                              ? ""
                                              : manageListingCtrl.selectedCountryId.toString(),
                                          city_id: manageListingCtrl.selectedCityId == null
                                              ? ""
                                              : manageListingCtrl.selectedCityId.toString(),
                                          categoryId: manageListingCtrl.selectedCategoryId);

                                  FrontendListingController.to.isGridSelected =
                                      true;
                                  FrontendListingController.to.isListSelected =
                                      false;
                                  FrontendListingController.to.update();
                                  Get.to(() => AllListingScreen(
                                      isFromFrontendDemoPage: true));
                                },
                              ),
                            ),
                            HSpace(10.w),
                            Expanded(
                              flex: 1,
                              child: AppButton(
                                onTap: () {
                                  manageListingCtrl.resetFrontendSearchData();
                                },
                                text: 'Reset',
                                borderRadius: BorderRadius.circular(32),
                                style: t.bodyMedium
                                    ?.copyWith(color: AppColors.blackColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    VSpace(16.h),
                    Container(
                      height: 202.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkCardColor(),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          VSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Categories",
                                style: t.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => ListingCategoryScreen(
                                      isFromFrontendDemoPage: true));
                                },
                                child: Text(
                                  "See All",
                                  style: t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.greyColor),
                                ),
                              ),
                            ],
                          ),
                          VSpace(20.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...List.generate(
                                    manageListingCtrl.topListingCategoryList.isEmpty
                                        ? 4
                                        : manageListingCtrl.topListingCategoryList.length,
                                    (index) {
                                  return manageListingCtrl.topListingCategoryList.isEmpty
                                      ? Container(
                                          height: 46.h,
                                          width: 46.h,
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            FrontendListingController
                                                .to.isGridSelected = true;
                                            FrontendListingController
                                                .to.isListSelected = false;
                                            FrontendListingController.to
                                                .update();
                                            Get.to(() => AllListingScreen(
                                                isFromFrontendDemoPage: true));
                                            FrontendListingController.to
                                                .resetDataAfterSearching();
                                            FrontendListingController
                                                    .to.selectedCategoryId =
                                                manageListingCtrl.topListingCategoryList[index]
                                                    .id
                                                    .toString();

                                            FrontendListingController.to
                                                .getFrontendListngList(
                                                    page: 1,
                                                    search: "",
                                                    country_id: "",
                                                    city_id: "",
                                                    categoryId: manageListingCtrl
                                                        .topListingCategoryList[
                                                            index]
                                                        .id
                                                        .toString());
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 46.h,
                                                width: 46.h,
                                                padding: EdgeInsets.all(
                                                    manageListingCtrl.topListingCategoryList[index]
                                                                .image !=
                                                            null
                                                        ? 10.h
                                                        : 0),
                                                decoration: BoxDecoration(
                                                  color: Get.isDarkMode
                                                      ? AppColors.darkCardColor
                                                      : AppColors.fillColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.r),
                                                ),
                                                child:
                                                    manageListingCtrl.topListingCategoryList[index]
                                                                .image !=
                                                            null
                                                        ? ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: manageListingCtrl
                                                                  .topListingCategoryList[
                                                                      index]
                                                                  .image
                                                                  .toString(),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          )
                                                        : Icon(
                                                            Icons.category,
                                                            color: AppColors
                                                                .mainColor,
                                                          ),
                                              ),
                                              VSpace(8.h),
                                              Container(
                                                alignment: Alignment.center,
                                                width: 80.w,
                                                child: Text(
                                                  manageListingCtrl
                                                      .topListingCategoryList[
                                                          index]
                                                      .name
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    VSpace(16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storedLanguage['Popular Listing'] ??
                              "Popular Listing",
                          style: t.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                                () => AllListingScreen(isFromHomePage: true));
                          },
                          child: Text(
                            storedLanguage['See All'] ?? "See All",
                            style: t.displayMedium?.copyWith(
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.greyColor),
                          ),
                        ),
                      ],
                    ),
                    VSpace(12.h),
                    frontendCtrl.isLoading
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3.w / 4.h,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 10.h),
                            itemCount: 8,
                            itemBuilder: (context, i) {
                              return ShimmerCard(
                                height: 200.h,
                                width: 200.h,
                              );
                            })
                        : frontendCtrl.listingList.isEmpty
                            ? Helpers.notFound(
                                top: 0, text: "No listings found")
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3.w / 4.h,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.w,
                                        mainAxisSpacing: 10.h),
                                itemCount: frontendCtrl.listingList.length > 4
                                    ? 4
                                    : frontendCtrl.listingList.length,
                                itemBuilder: (context, i) {
                                  var clampedIndex = i.clamp(
                                      i, frontendCtrl.listingList.length);
                                  var data =
                                      frontendCtrl.listingList[clampedIndex];

                                  return InkWell(
                                    onTap: () {
                                      frontendCtrl
                                          .getFrontendListingDetailsList(
                                              slug: data.slug.toString());
                                      Get.toNamed(
                                          RoutesName.listingDetailsScreen);
                                    },
                                    borderRadius: Dimensions.kBorderRadius,
                                    child: MyListTile(
                                      bgColor: AppThemes.getFillColor(),
                                      image: "${data.thumbnail.toString()}",
                                      title: "${data.title.toString()}",
                                      description:
                                          "Category: ${data.categories.toString()}",
                                      location: "${data.address.toString()}",
                                      rating: data.averageRating == null
                                          ? "0"
                                          : "${double.parse(data.averageRating.toString()).toStringAsFixed(1)}",
                                      save: InkResponse(
                                        onTap: () async {
                                          await WishlistController.to
                                              .addToWishlist(fields: {
                                            "listing_id": data.id.toString()
                                          }, listingId: data.id);
                                        },
                                        child: Container(
                                          height: 29.h,
                                          width: 29.h,
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      14.5.r)),
                                          child: Icon(
                                            WishlistController.to.wishListItem
                                                    .contains(data.id)
                                                ? Icons.favorite
                                                : Icons
                                                    .favorite_border_outlined,
                                            size: 16.h,
                                            color: AppColors.black60,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                    VSpace(50.h),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
