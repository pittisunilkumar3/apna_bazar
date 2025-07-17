import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/controllers/frontend_listing_controller.dart';
import 'package:listplace/controllers/wishlist_controller.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../../config/app_colors.dart';
import '../../../../routes/routes_name.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/appDialog.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/google_map_screen.dart';
import '../../../widgets/leaflet_map.dart';
import '../../../widgets/my_listing_tile.dart';
import '../../../widgets/shimmer_card.dart';
import 'package:latlong2/latlong.dart' as latlng;

class AllListingScreen extends StatelessWidget {
  final bool? isFromListingCategoryPage;
  final bool? isFromHomePage;
  final bool? isFromFrontendDemoPage;
  const AllListingScreen(
      {super.key,
      this.isFromListingCategoryPage = false,
      this.isFromFrontendDemoPage = false,
      this.isFromHomePage = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<WishlistController>(builder: (wishlistCtrl) {
      return GetBuilder<FrontendListingController>(builder: (frontendListingCtrl) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (isFromListingCategoryPage == true) {
              FrontendListingController.to.resetDataAfterSearching();
              FrontendListingController.to.selectedCategoryId = "";
              FrontendListingController.to.getFrontendListngList(
                  page: 1, search: '', country_id: '', city_id: '');
              Get.back();
            } else {
              Get.back();
            }
          },
          child: Scaffold(
            appBar: buildAppbar(
                context, t, frontendListingCtrl, storedLanguage, isFromFrontendDemoPage),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFromFrontendDemoPage == false) VSpace(28.h),
                if (isFromFrontendDemoPage == false)
                  Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: filterNow(t, frontendListingCtrl, storedLanguage)),
                if (isFromFrontendDemoPage == false) VSpace(24.h),
                if (isFromFrontendDemoPage == true)
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          if (HiveHelp.read(Keys.isLeafletMap) != null &&
                              HiveHelp.read(Keys.isLeafletMap) == true) {
                            Get.to(() => InteractiveMapScreen(
                                  markers: frontendListingCtrl.leafletmarker,
                                  latLng: frontendListingCtrl.latLngList.isEmpty
                                      ? latlng.LatLng(0, 0)
                                      : latlng.LatLng(frontendListingCtrl.latLngList[0].latitude,
                                          frontendListingCtrl.latLngList[0].longitude),
                                ));
                          } else {
                            Get.to(() => GoogleMapScreen(
                                isUserAuthenticated: false,
                                isFullView: true,
                                latLng: frontendListingCtrl.latLngList.isEmpty
                                    ? LatLng(0, 0)
                                    : frontendListingCtrl.latLngList[0]));
                          }
                        },
                        child: Container(
                          width: 122.w,
                          height: 42.h,
                          margin: EdgeInsets.only(bottom: 6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r)),
                            color: AppColors.mainColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Map",
                                style: t.displayMedium
                                    ?.copyWith(color: AppColors.blackColor),
                              ),
                              HSpace(8.w),
                              Image.asset(
                                "$rootImageDir/location_icon.png",
                                height: 18.h,
                                width: 18.h,
                                fit: BoxFit.cover,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),
                      )),
                frontendListingCtrl.isListSelected == false
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: RefreshIndicator(
                          color: AppColors.mainColor,
                          onRefresh: () async {
                            frontendListingCtrl.searchEditingCtrlr.clear();

                            if (isFromListingCategoryPage == false) {
                              FrontendListingController.to.selectedCategoryId =
                                  "";
                            }
                            ManageListingController.to.selectedCountry = null;
                            ManageListingController.to.selectedCountryId = null;
                            ManageListingController.to.selectedCity = null;
                            ManageListingController.to.selectedCityId = null;
                            frontendListingCtrl.resetDataAfterSearching(
                                isFromOnRefreshIndicator: true);
                            await frontendListingCtrl.getFrontendListngList(
                                page: 1,
                                search: '',
                                country_id: '',
                                city_id: '');
                          },
                          child: Padding(
                            padding: Dimensions.kDefaultPadding,
                            child: SingleChildScrollView(
                              controller: frontendListingCtrl.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: frontendListingCtrl.isLoading
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 12,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.h),
                                          child: ShimmerCard(),
                                        );
                                      })
                                  : frontendListingCtrl.listingList.isEmpty
                                      ? Helpers.notFound(
                                          text: "No listings found")
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: frontendListingCtrl.listingList.length,
                                          itemBuilder: (context, i) {
                                            var data = frontendListingCtrl.listingList[i];
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 12.h),
                                              child: InkWell(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                onTap: () {
                                                  frontendListingCtrl.getFrontendListingDetailsList(
                                                      slug:
                                                          data.slug.toString());
                                                  Get.toNamed(RoutesName
                                                      .listingDetailsScreen);
                                                },
                                                child: Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15.h,
                                                      horizontal: 12.w),
                                                  decoration: BoxDecoration(
                                                    color: AppThemes
                                                        .getFillColor(),
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: 60.h,
                                                          alignment:
                                                              Alignment.topLeft,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      Dimensions
                                                                          .kBorderRadius,
                                                                  image:
                                                                      DecorationImage(
                                                                    image: CachedNetworkImageProvider(data
                                                                        .thumbnail
                                                                        .toString()),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                          child: InkResponse(
                                                            onTap: () async {
                                                              await WishlistController
                                                                  .to
                                                                  .addToWishlist(
                                                                      fields: {
                                                                    "listing_id":
                                                                        data.id
                                                                            .toString(),
                                                                  },
                                                                      listingId:
                                                                          data.id);
                                                            },
                                                            child: Container(
                                                              height: 22.h,
                                                              width: 22.h,
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .mainColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              11.r)),
                                                              child: Icon(
                                                                WishlistController
                                                                        .to
                                                                        .wishListItem
                                                                        .contains(data
                                                                            .id)
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border_outlined,
                                                                size: 13.h,
                                                                color: WishlistController
                                                                        .to
                                                                        .wishListItem
                                                                        .contains(data
                                                                            .id)
                                                                    ? AppColors
                                                                        .black70
                                                                    : AppColors
                                                                        .black60,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      HSpace(12.w),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.title
                                                                  .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: t
                                                                  .displayMedium
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                            ),
                                                            VSpace(11.h),
                                                            Text(
                                                                data.categories
                                                                    .toString(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: t
                                                                    .bodySmall),
                                                          ],
                                                        ),
                                                      ),
                                                      HSpace(7.w),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4.h,
                                                                      horizontal:
                                                                          12.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.r),
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .darkBgColor
                                                                    : AppColors
                                                                        .whiteColor,
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons.star,
                                                                    color: AppColors
                                                                        .starColor,
                                                                    size: 17.h,
                                                                  ),
                                                                  HSpace(3.w),
                                                                  Text(
                                                                    data.averageRating ==
                                                                            null
                                                                        ? "0"
                                                                        : "${double.parse(data.averageRating.toString()).toStringAsFixed(1)}",
                                                                    style: t
                                                                        .bodySmall,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            VSpace(11.h),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                  "$rootImageDir/location.png",
                                                                  height: 14.h,
                                                                  color: AppThemes
                                                                      .getGreyColor(),
                                                                ),
                                                                HSpace(5.w),
                                                                Expanded(
                                                                  child: Text(
                                                                      "${data.address.toString()}",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: t
                                                                          .bodySmall
                                                                          ?.copyWith(
                                                                              color: AppThemes.getGreyColor())),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      VSpace(5.h),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                            ),
                          ),
                        ),
                      ),
                frontendListingCtrl.isGridSelected == false
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: RefreshIndicator(
                          color: AppColors.mainColor,
                          onRefresh: () async {
                            frontendListingCtrl.searchEditingCtrlr.clear();
                            if (isFromListingCategoryPage == false) {
                              FrontendListingController.to.selectedCategoryId =
                                  "";
                            }
                            ManageListingController.to.selectedCountry = null;
                            ManageListingController.to.selectedCountryId = null;
                            ManageListingController.to.selectedCity = null;
                            ManageListingController.to.selectedCityId = null;
                            frontendListingCtrl.resetDataAfterSearching(
                                isFromOnRefreshIndicator: true);
                            await frontendListingCtrl.getFrontendListngList(
                                page: 1,
                                search: '',
                                country_id: '',
                                city_id: '');
                          },
                          child: Padding(
                            padding: Dimensions.kDefaultPadding,
                            child: SingleChildScrollView(
                              controller: frontendListingCtrl.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: frontendListingCtrl.isLoading
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
                                  : frontendListingCtrl.listingList.isEmpty
                                      ? Helpers.notFound(
                                          text: "No listings found")
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
                                          itemCount: frontendListingCtrl.listingList.length,
                                          itemBuilder: (context, i) {
                                            var data = frontendListingCtrl.listingList[i];
                                            return InkWell(
                                              onTap: () {
                                                frontendListingCtrl.getFrontendListingDetailsList(
                                                    slug: data.slug.toString());
                                                Get.toNamed(RoutesName
                                                    .listingDetailsScreen);
                                              },
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              child: MyListTile(
                                                bgColor:
                                                    AppThemes.getFillColor(),
                                                image:
                                                    "${data.thumbnail.toString()}",
                                                title:
                                                    "${data.title.toString()}",
                                                description:
                                                    "Category: ${data.categories.toString()}",
                                                location:
                                                    "${data.address.toString()}",
                                                rating: data.averageRating ==
                                                        null
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
                                                            BorderRadius
                                                                .circular(
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
                            ),
                          ),
                        ),
                      ),
                if (frontendListingCtrl.isLoadMore == true)
                  Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      child: Helpers.appLoader()),
                VSpace(20.h),
              ],
            ),
          ),
        );
      });
    });
  }

  CustomAppBar buildAppbar(
      BuildContext context,
      TextTheme t,
      FrontendListingController frondtendListingCtrl,
      dynamic storedLanguage,
      isFromFrontendDemoPage) {
    return CustomAppBar(
      title: storedLanguage['Listing'] ?? "Listing",
      leading: isFromListingCategoryPage == true ||
              isFromHomePage == true ||
              isFromFrontendDemoPage == true
          ? null
          : SizedBox(),
      onBackPressed: () async {
        if (isFromListingCategoryPage == true) {
          FrontendListingController.to.resetDataAfterSearching();
          FrontendListingController.to.selectedCategoryId = "";
          FrontendListingController.to.getFrontendListngList(
              page: 1, search: '', country_id: '', city_id: '');
          Get.back();
        } else {
          Get.back();
        }
      },
      toolberHeight: isFromListingCategoryPage == true ||
              isFromHomePage == true ||
              isFromFrontendDemoPage == true
          ? 100.h
          : 120.h,
      prefferSized: isFromListingCategoryPage == true ||
              isFromHomePage == true ||
              isFromFrontendDemoPage == true
          ? 70.h
          : 120.h,
      actions: isFromFrontendDemoPage == true
          ? []
          : [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: InkWell(
                  onTap: () {
                    ManageListingController.to.isAllCities = true;
                    ManageListingController.to.getCityList(
                      StateId: "",
                      isAllCities: true,
                    );
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
                            VSpace(24.h),
                            Container(
                              height: 46.h,
                              child: CustomTextField(
                                isBorderColor: false,
                                fillColor: AppThemes.getFillColor(),
                                controller: frondtendListingCtrl.searchEditingCtrlr,
                                hintext: storedLanguage['Listing Title'] ??
                                    "Listing Title",
                              ),
                            ),
                            VSpace(20.h),
                            GetBuilder<ManageListingController>(
                                builder: (addListCtrl) {
                              return Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: AppCustomDropDown(
                                  bgColor: AppThemes.getDarkCardColor(),
                                  height: 46.h,
                                  width: double.infinity,
                                  items: addListCtrl.countryList
                                      .map((e) => e.name.toString())
                                      .toList(),
                                  selectedValue: addListCtrl.selectedCountry,
                                  onChanged: addListCtrl.onChangedCountry,
                                  hint: storedLanguage['Select Country'] ??
                                      "Select Country",
                                  searchEditingCtrl:
                                      addListCtrl.countryEditingCtrlr,
                                  searchHintext:
                                      storedLanguage['Search Country'] ??
                                          "Search Country",
                                  fontSize: 14.sp,
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textFieldHintColor),
                                ),
                              );
                            }),
                            VSpace(20.h),
                            GetBuilder<ManageListingController>(
                                builder: (addListCtrl) {
                              return Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: AppCustomDropDown(
                                  bgColor: AppThemes.getDarkCardColor(),
                                  height: 46.h,
                                  width: double.infinity,
                                  items: addListCtrl.cityList
                                      .map((e) => e.name.toString())
                                      .toList(),
                                  selectedValue: addListCtrl.selectedCity,
                                  onChanged: addListCtrl.onChangedCity,
                                  hint: storedLanguage['Select City'] ??
                                      "Select City",
                                  searchHintext:
                                      storedLanguage['Search City'] ??
                                          "Search City",
                                  searchEditingCtrl:
                                      addListCtrl.cityEditingCtrlr,
                                  fontSize: 14.sp,
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textFieldHintColor),
                                ),
                              );
                            }),
                            VSpace(20.h),
                            VSpace(28.h),
                            AppButton(
                              text:
                                  storedLanguage['Search Now'] ?? "Search Now",
                              onTap: () async {
                                Get.back();
                                frondtendListingCtrl.resetDataAfterSearching();
                                frondtendListingCtrl.getFrontendListngList(
                                    page: 1,
                                    search: frondtendListingCtrl.searchEditingCtrlr.text,
                                    country_id: ManageListingController
                                                .to.selectedCountryId ==
                                            null
                                        ? ""
                                        : ManageListingController
                                            .to.selectedCountryId
                                            .toString(),
                                    city_id: ManageListingController
                                                .to.selectedCityId ==
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
                    width: 34.h,
                    height: 34.h,
                    padding: EdgeInsets.all(9.h),
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Image.asset(
                      "$rootImageDir/filter_2.png",
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                  ),
                ),
              ),
              HSpace(20.w),
            ],
    );
  }

  Widget filterNow(
      TextTheme t, FrontendListingController frontendListingCtrl, dynamic storedLanguage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            frontendListingCtrl.isListSelected == true
                ? storedLanguage['List view'] ?? "List view"
                : storedLanguage['Grid view'] ?? "Grid view",
            style: t.bodyMedium),
        Row(
          children: [
            InkWell(
              onTap: () {
                frontendListingCtrl.isListSelected = true;
                frontendListingCtrl.isGridSelected = false;
                frontendListingCtrl.update();
              },
              child: Container(
                height: 35.h,
                width: 35.h,
                padding: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                  color: frontendListingCtrl.isListSelected == true
                      ? AppColors.mainColor
                      : AppThemes.getDarkCardColor(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.r),
                    bottomLeft: Radius.circular(6.r),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: frontendListingCtrl.isListSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                    top: BorderSide(
                      color: frontendListingCtrl.isListSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                    bottom: BorderSide(
                      color: frontendListingCtrl.isListSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                  ),
                ),
                child: Image.asset("$rootImageDir/list.png",
                    color: frontendListingCtrl.isListSelected == true
                        ? AppColors.blackColor
                        : Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
              ),
            ),
            InkWell(
              onTap: () {
                frontendListingCtrl.isListSelected = false;
                frontendListingCtrl.isGridSelected = true;
                frontendListingCtrl.update();
              },
              child: Container(
                height: 35.h,
                width: 35.h,
                padding: EdgeInsets.all(9.h),
                decoration: BoxDecoration(
                  color: frontendListingCtrl.isGridSelected == true
                      ? AppColors.mainColor
                      : AppThemes.getDarkCardColor(),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: frontendListingCtrl.isGridSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                    top: BorderSide(
                      color: frontendListingCtrl.isGridSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                    bottom: BorderSide(
                      color: frontendListingCtrl.isGridSelected == true
                          ? AppColors.mainColor
                          : AppThemes.getBlack10Color(),
                    ),
                  ),
                ),
                child: Image.asset("$rootImageDir/grid.png",
                    color: frontendListingCtrl.isGridSelected == true
                        ? AppColors.blackColor
                        : Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
