import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/app_controller.dart';
import 'package:listplace/controllers/dashboard_controller.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/views/screens/listing/frontend_listings/listing_categories_screen.dart';
import 'package:listplace/views/widgets/custom_textfield.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/frontend_listing_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/my_listing_tile.dart';
import '../../widgets/shimmer_card.dart';
import '../auth/login_screen.dart';
import '../listing/frontend_listings/all_listing_screen.dart';
import 'drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appCtrl) {
      return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
        return GetBuilder<ProfileController>(builder: (profileCtrl) {
          return GetBuilder<FrontendListingController>(builder: (listingCtrl) {
            return GetBuilder<WishlistController>(builder: (wishlistCtrl) {
              return GetBuilder<ManageListingController>(
                  builder: (manageListingCtrl) {
                return Scaffold(
                  appBar: buildAppBar(storedLanguage),
                  body: RefreshIndicator(
                    color: AppColors.mainColor,
                    onRefresh: () async {
                      if (HiveHelp.read(Keys.token) != null) {
                        ProfileController.to.getProfile();
                        dashboardCtrl.getDashboard();
                      }
                      manageListingCtrl.getListingCategories();
                      listingCtrl.resetDataAfterSearching();

                      // Profile
                      FrontendListingController.to.selectedCategoryId = "";
                      ManageListingController.to.selectedCountry = null;
                      ManageListingController.to.selectedCountryId = '';
                      ManageListingController.to.selectedCity = null;
                      ManageListingController.to.selectedCityId = '';
                      listingCtrl.getFrontendListngList(
                          page: 1, search: '', country_id: '', city_id: '');
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(25.h),
                            Text(
                              'Find the Best Listing',
                              style: t.bodyMedium?.copyWith(
                                  fontSize: 32.sp, fontWeight: FontWeight.w500),
                            ),
                            VSpace(5.h),
                            Row(
                              children: [
                                Image.asset(
                                  "$rootImageDir/home_img.png",
                                  width: 112.h,
                                  height: 42.h,
                                  fit: BoxFit.cover,
                                ),
                                HSpace(12.w),
                                Text(
                                  'For You',
                                  style: t.bodyMedium?.copyWith(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            VSpace(25.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                      height: 46.h,
                                      hintext: 'Search Here',
                                      prefixIcon: 'search',
                                      isBorderColor: false,
                                      fillColor: AppThemes.getFillColor(),
                                      controller: FrontendListingController
                                          .to.searchEditingCtrlr,
                                      onChanged: FrontendListingController
                                          .to.onListingSearch),
                                ),
                                HSpace(12.w),
                                InkWell(
                                  onTap: () {
                                    ManageListingController.to.isAllCities =
                                        true;
                                    ManageListingController.to.getCityList(
                                      StateId: "",
                                      isAllCities: true,
                                    );
                                    appDialog(
                                        context: context,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                storedLanguage['Filter Now'] ??
                                                    "Filter Now",
                                                style: t.bodyMedium),
                                            InkResponse(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(7.h),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppThemes.getFillColor(),
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
                                            VSpace(24.h),
                                            Container(
                                              height: 46.h,
                                              child: CustomTextField(
                                                isBorderColor: false,
                                                fillColor:
                                                    AppThemes.getFillColor(),
                                                controller:
                                                    FrontendListingController
                                                        .to.searchEditingCtrlr,
                                                hintext: storedLanguage[
                                                        'Listing Title'] ??
                                                    "Listing Title",
                                              ),
                                            ),
                                            VSpace(20.h),
                                            GetBuilder<ManageListingController>(
                                                builder: (addListCtrl) {
                                              return Container(
                                                height: 46.h,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppThemes.getFillColor(),
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                ),
                                                child: AppCustomDropDown(
                                                  bgColor: AppThemes
                                                      .getDarkCardColor(),
                                                  height: 46.h,
                                                  width: double.infinity,
                                                  items: addListCtrl.countryList
                                                      .map((e) =>
                                                          e.name.toString())
                                                      .toList(),
                                                  selectedValue: addListCtrl
                                                      .selectedCountry,
                                                  onChanged: addListCtrl
                                                      .onChangedCountry,
                                                  hint: storedLanguage[
                                                          'Select Country'] ??
                                                      "Select Country",
                                                  searchEditingCtrl: addListCtrl
                                                      .countryEditingCtrlr,
                                                  searchHintext: storedLanguage[
                                                          'Search Country'] ??
                                                      "Search Country",
                                                  fontSize: 14.sp,
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .textFieldHintColor),
                                                ),
                                              );
                                            }),
                                            VSpace(20.h),
                                            GetBuilder<ManageListingController>(
                                                builder: (addListCtrl) {
                                              return Container(
                                                height: 46.h,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppThemes.getFillColor(),
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                ),
                                                child: AppCustomDropDown(
                                                  bgColor: AppThemes
                                                      .getDarkCardColor(),
                                                  height: 46.h,
                                                  width: double.infinity,
                                                  items: addListCtrl.cityList
                                                      .map((e) =>
                                                          e.name.toString())
                                                      .toList(),
                                                  selectedValue:
                                                      addListCtrl.selectedCity,
                                                  onChanged:
                                                      addListCtrl.onChangedCity,
                                                  hint: storedLanguage[
                                                          'Select City'] ??
                                                      "Select City",
                                                  searchHintext: storedLanguage[
                                                          'Search City'] ??
                                                      "Search City",
                                                  searchEditingCtrl: addListCtrl
                                                      .cityEditingCtrlr,
                                                  fontSize: 14.sp,
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .textFieldHintColor),
                                                ),
                                              );
                                            }),
                                            VSpace(20.h),
                                            VSpace(28.h),
                                            AppButton(
                                              text: storedLanguage[
                                                      'Search Now'] ??
                                                  "Search Now",
                                              onTap: () async {
                                                Get.back();

                                                FrontendListingController.to
                                                    .resetDataAfterSearching();
                                                FrontendListingController.to.getFrontendListngList(
                                                    page: 1,
                                                    search:
                                                        FrontendListingController
                                                            .to
                                                            .searchEditingCtrlr
                                                            .text,
                                                    country_id: ManageListingController
                                                                .to
                                                                .selectedCountryId ==
                                                            null
                                                        ? ""
                                                        : ManageListingController
                                                            .to
                                                            .selectedCountryId
                                                            .toString(),
                                                    city_id: ManageListingController
                                                                .to
                                                                .selectedCityId ==
                                                            null
                                                        ? ""
                                                        : ManageListingController
                                                            .to.selectedCityId
                                                            .toString());
                                              },
                                            ),
                                          ],
                                        ));
                                  },
                                  child: Container(
                                    width: 46.h,
                                    height: 46.h,
                                    padding: EdgeInsets.all(14.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: Dimensions.kBorderRadius,
                                    ),
                                    child: Image.asset(
                                      "$rootImageDir/filter_2.png",
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(25.h),
                            if (!FrontendListingController.to.isListingSearch)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Top Categories",
                                        style: t.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => ListingCategoryScreen(
                                              isFromHomePage: true));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                Dimensions.kBorderRadius * 2.3,
                                          ),
                                          child: Text(
                                            "See All",
                                            style: t.displayMedium?.copyWith(
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.greyColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VSpace(20.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ...List.generate(
                                            manageListingCtrl
                                                    .topListingCategoryList
                                                    .isEmpty
                                                ? 4
                                                : manageListingCtrl
                                                    .topListingCategoryList
                                                    .length, (index) {
                                          return manageListingCtrl
                                                  .topListingCategoryList
                                                  .isEmpty
                                              ? Container(
                                                  height: 60.h,
                                                  width: 60.h,
                                                  decoration: BoxDecoration(
                                                    color: AppThemes
                                                        .getFillColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.r),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        () => AllListingScreen(
                                                              isFromListingCategoryPage:
                                                                  true,
                                                              isFromFrontendDemoPage:
                                                                  HiveHelp.read(
                                                                              Keys.token) ==
                                                                          null
                                                                      ? true
                                                                      : false,
                                                            ));
                                                    FrontendListingController.to
                                                        .resetDataAfterSearching();
                                                    FrontendListingController.to
                                                            .selectedCategoryId =
                                                        manageListingCtrl
                                                            .topListingCategoryList[
                                                                index]
                                                            .id
                                                            .toString();

                                                    FrontendListingController.to
                                                        .getFrontendListngList(
                                                            page: 1,
                                                            search: "",
                                                            country_id: "",
                                                            city_id: "",
                                                            categoryId:
                                                                manageListingCtrl
                                                                    .topListingCategoryList[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 60.h,
                                                        width: 60.h,
                                                        padding: EdgeInsets.all(
                                                            manageListingCtrl
                                                                        .topListingCategoryList[
                                                                            index]
                                                                        .image !=
                                                                    null
                                                                ? 10.h
                                                                : 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .darkCardColor
                                                              : AppColors
                                                                  .fillColor2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.r),
                                                        ),
                                                        child: manageListingCtrl
                                                                    .topListingCategoryList[
                                                                        index]
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
                                                                  fit: BoxFit
                                                                      .fill,
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
                                                        alignment:
                                                            Alignment.center,
                                                        width: 80.w,
                                                        child: Text(
                                                          manageListingCtrl
                                                              .topListingCategoryList[
                                                                  index]
                                                              .name
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                        }),
                                      ],
                                    ),
                                  ),
                                  VSpace(32.h),
                                  if (HiveHelp.read(Keys.token) != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Dashboard",
                                          style: t.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(
                                                RoutesName.dashboardScreen);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h),
                                            decoration: BoxDecoration(
                                              color: AppThemes.getFillColor(),
                                              borderRadius:
                                                  Dimensions.kBorderRadius *
                                                      2.3,
                                            ),
                                            child: Text(
                                              storedLanguage['See All'] ??
                                                  "See All",
                                              style: t.displayMedium?.copyWith(
                                                  color: Get.isDarkMode
                                                      ? AppColors.whiteColor
                                                      : AppColors.greyColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (HiveHelp.read(Keys.token) != null)
                                    VSpace(20.h),
                                  if (HiveHelp.read(Keys.token) != null)
                                    Row(
                                      children: [
                                        dashboardCtrl.isLoading
                                            ? Expanded(child: ShimmerCard())
                                            : buildDashboardWidget(
                                                t,
                                                storedLanguage,
                                                title: storedLanguage[
                                                        'Total Listing'] ??
                                                    "Total Listing",
                                                isIconSmall: true,
                                                value:
                                                    dashboardCtrl.data == null
                                                        ? "0"
                                                        : dashboardCtrl
                                                            .data!.totalListing
                                                            .toString(),
                                                img: 'active_listing',
                                              ),
                                        HSpace(20.w),
                                        dashboardCtrl.isLoading
                                            ? Expanded(child: ShimmerCard())
                                            : buildDashboardWidget(
                                                t, storedLanguage,
                                                title: storedLanguage[
                                                        'Active Listing'] ??
                                                    "Active Listing",
                                                value:
                                                    dashboardCtrl.data == null
                                                        ? "0"
                                                        : dashboardCtrl
                                                            .data!.activeListing
                                                            .toString(),
                                                img: 'listing'),
                                      ],
                                    ),
                                  if (HiveHelp.read(Keys.token) != null)
                                    VSpace(20.h),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Popular Listing'] ??
                                      "Popular Listing",
                                  style: t.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => AllListingScreen(
                                          isFromHomePage: true,
                                          isFromFrontendDemoPage:
                                              HiveHelp.read(Keys.token) == null
                                                  ? true
                                                  : false,
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getFillColor(),
                                      borderRadius:
                                          Dimensions.kBorderRadius * 2.3,
                                    ),
                                    child: Text(
                                      storedLanguage['See All'] ?? "See All",
                                      style: t.displayMedium?.copyWith(
                                          color: Get.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.greyColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(12.h),
                            listingCtrl.isLoading
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                : listingCtrl.listingList.isEmpty
                                    ? Helpers.notFound(
                                        top: 0, text: "No listings found")
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 3.w / 4.h,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 12.w,
                                                mainAxisSpacing: 10.h),
                                        itemCount: listingCtrl
                                                    .isListingSearch ==
                                                true
                                            ? listingCtrl
                                                .searchedListingList.length
                                            : listingCtrl.listingList.length > 4
                                                ? 4
                                                : listingCtrl
                                                    .listingList.length,
                                        itemBuilder: (context, i) {
                                          var clampedIndex = i.clamp(i,
                                              listingCtrl.listingList.length);
                                          var data = listingCtrl
                                                      .isListingSearch ==
                                                  true
                                              ? listingCtrl
                                                  .searchedListingList[i]
                                              : listingCtrl
                                                  .listingList[clampedIndex];

                                          return InkWell(
                                            onTap: () {
                                              listingCtrl
                                                  .getFrontendListingDetailsList(
                                                      slug:
                                                          data.slug.toString());
                                              Get.toNamed(RoutesName
                                                  .listingDetailsScreen);
                                            },
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            child: MyListTile(
                                              bgColor: AppThemes.getFillColor(),
                                              image:
                                                  "${data.thumbnail.toString()}",
                                              title: "${data.title.toString()}",
                                              description:
                                                  "Category: ${data.categories.toString()}",
                                              location:
                                                  "${data.address.toString()}",
                                              rating: data.averageRating == null
                                                  ? "0"
                                                  : "${double.parse(data.averageRating.toString()).toStringAsFixed(1)}",
                                              save: InkResponse(
                                                onTap: () async {
                                                  await WishlistController.to
                                                      .addToWishlist(fields: {
                                                    "listing_id":
                                                        data.id.toString()
                                                  }, listingId: data.id);
                                                },
                                                child: Container(
                                                  height: 29.h,
                                                  width: 29.h,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14.5.r)),
                                                  child: Icon(
                                                    WishlistController
                                                            .to.wishListItem
                                                            .contains(data.id)
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_outlined,
                                                    size: 16.h,
                                                    color: WishlistController
                                                            .to.wishListItem
                                                            .contains(data.id)
                                                        ? AppColors.black70
                                                        : AppColors.black60,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                            VSpace(30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            });
          });
        });
      });
    });
  }

  CustomAppBar buildAppBar(storedLanguage) {
    return CustomAppBar(
      toolberHeight: 100.h,
      prefferSized: 100.h,
      isTitleMarginTop: true,
      leading: HiveHelp.read(Keys.token) == null
          ? IconButton(
              padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
              onPressed: () {
                Get.toNamed(RoutesName.loginScreen);
              },
              icon: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : AppColors.sliderInActiveColor,
                    width: Get.isDarkMode ? .8 : .9,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 16.h,
                  width: 16.h,
                  color:
                      Get.isDarkMode ? AppColors.whiteColor : AppColors.black70,
                  fit: BoxFit.fitHeight,
                ),
              ))
          : IconButton(
              padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
              onPressed: () {
                drawerController.toggle!();
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(7.h),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Image.asset(
                  "$rootImageDir/menu.png",
                  height: 40.h,
                  width: 40.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fit: BoxFit.fitHeight,
                ),
              )),
      title: storedLanguage['Home'] ?? "Home",
      actions: [
        Stack(
          children: [
            HiveHelp.read(Keys.token) == null
                ? IconButton(
                    padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    icon: Image.asset(
                      "$rootImageDir/exit.png",
                      height: 26.h,
                      width: 26.h,
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black50,
                      fit: BoxFit.cover,
                    ),
                  )
                : IconButton(
                    padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
                    onPressed: () {
                      Get.put(PushNotificationController()).isNotiSeen();
                    },
                    icon: Container(
                      width: 34.h,
                      height: 34.h,
                      padding: EdgeInsets.all(7.h),
                      decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Image.asset(
                        "$rootImageDir/notification.png",
                        color: AppThemes.getIconBlackColor(),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
            Obx(() => Positioned(
                top: Platform.isIOS ? 45.h : 25.h,
                right: 17.w,
                child: InkWell(
                  onTap: () {
                    Get.put(PushNotificationController()).isNotiSeen();
                  },
                  child: CircleAvatar(
                    radius:
                        Get.put(PushNotificationController()).isSeen.value ==
                                false
                            ? 5.r
                            : 0,
                    backgroundColor:
                        Get.put(PushNotificationController()).isSeen.value ==
                                false
                            ? AppColors.redColor
                            : Colors.transparent,
                  ),
                ))),
          ],
        ),
        HSpace(20.w),
      ],
    );
  }
}

Widget buildTransactionLoader(
    {int? itemCount = 8, bool? isReverseColor = false, double? imgSize}) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isReverseColor == true
                ? AppThemes.getFillColor()
                : AppThemes.getDarkCardColor(),
            borderRadius: Dimensions.kBorderRadius,
            border: Border.all(
                color: AppThemes.borderColor(),
                width: Dimensions.appThinBorder),
          ),
          child: Row(
            children: [
              Container(
                width: imgSize ?? 40.h,
                height: imgSize ?? 40.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : isReverseColor == true
                          ? AppColors.whiteColor
                          : AppColors.fillColor,
                ),
              ),
              HSpace(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    VSpace(5.h),
                    Container(
                      height: 10.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

Expanded buildDashboardWidget(TextTheme t, storedLanguage,
    {required String title,
    required String value,
    required String img,
    bool? isIconSmall = false}) {
  return Expanded(
    child: Container(
      height: 95.h,
      padding: EdgeInsets.only(left: 16.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColor2,
        borderRadius: Dimensions.kBorderRadius,
      ),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "$rootImageDir/intersect.png",
                    width: 49.w,
                    height: 51.h,
                    fit: BoxFit.fill,
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : AppColors.black10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.w, top: 13.h),
                    child: Image.asset(
                      "$rootImageDir/$img.png",
                      width: isIconSmall == true ? 18.h : 21.5.h,
                      height: isIconSmall == true ? 18.h : 21.5.h,
                      fit: BoxFit.fill,
                      color: AppThemes.getIconBlackColor(),
                    ),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$value",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleLarge?.copyWith(fontSize: 22.sp),
                ),
                VSpace(5.h),
                Text(title, style: t.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
