import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/controllers/app_controller.dart';
import 'package:listplace/controllers/frontend_listing_controller.dart';
import 'package:listplace/data/models/frontend_listing_details_model.dart'
    as fListingModel;
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/styles.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../../controllers/wishlist_controller.dart';
import '../../../../routes/routes_name.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/appDialog.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/google_map_screen.dart';
import '../../../widgets/leaflet_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import '../../../widgets/view_photos.dart';
import 'product_details_screen.dart';

class ListingDetailsScreen extends StatelessWidget {
  ListingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    c.CarouselSliderController controller = c.CarouselSliderController();
    return GetBuilder<FrontendListingController>(builder: (frontendListingCtrl) {
      return GetBuilder<ManageListingController>(builder: (addlistingCtrl) {
        return GetBuilder<AppController>(builder: (appCtrl) {
          return DefaultTabController(
              length: frontendListingCtrl.categoryList.length,
              child: Scaffold(
                appBar: !frontendListingCtrl.isLoading && frontendListingCtrl.listingDetailsList.isNotEmpty
                    ? null
                    : CustomAppBar(
                        title: storedLanguage['Listing Details'] ??
                            "Listing Details"),
                body: frontendListingCtrl.isLoading
                    ? Helpers.appLoader()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (frontendListingCtrl.listingDetailsList.isEmpty) Text("data"),
                            if (frontendListingCtrl.listingDetailsList.isNotEmpty)
                              Container(
                                height: Dimensions.screenHeight * .4,
                                child: Stack(
                                  children: [
                                    caroselSection(controller, t, frontendListingCtrl),
                                    Padding(
                                      padding: Dimensions.kDefaultPadding,
                                      child: Column(
                                        children: [
                                          VSpace(60.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: AppColors.blackColor,
                                                    size: 20.h,
                                                  ),
                                                ),
                                              ),
                                              InkResponse(
                                                onTap: () async {
                                                  await WishlistController.to
                                                      .addToWishlist(
                                                          fields: {
                                                        "listing_id": frontendListingCtrl
                                                            .listingDetailsList[
                                                                0]
                                                            .id
                                                            .toString()
                                                      },
                                                          listingId: frontendListingCtrl
                                                              .listingDetailsList[
                                                                  0]
                                                              .id);
                                                },
                                                child: Container(
                                                  height: 33.h,
                                                  width: 33.h,
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      shape: BoxShape.circle),
                                                  child: Image.asset(
                                                    WishlistController
                                                            .to.wishListItem
                                                            .contains(frontendListingCtrl
                                                                .listingDetailsList[
                                                                    0]
                                                                .id)
                                                        ? "$rootImageDir/bookmark1.png"
                                                        : "$rootImageDir/bookmark.png",
                                                    height: 15.h,
                                                    color: AppColors.blackColor,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7.h,
                                                    horizontal: 11.w),
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor,
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.visibility_outlined,
                                                      size: 14.h,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                    HSpace(5.w),
                                                    Text(
                                                      '${frontendListingCtrl.listingDetailsList[0].totalListingViews.toString()}',
                                                      style: t.bodySmall
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .blackColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (frontendListingCtrl
                                                      .listingDetailsList[0]
                                                      .listingImages!
                                                      .isNotEmpty &&
                                                  frontendListingCtrl
                                                          .listingDetailsList[0]
                                                          .listingImages!
                                                          .length >
                                                      1)
                                                DotsIndicator(
                                                  dotsCount: frontendListingCtrl
                                                          .listingDetailsList[0]
                                                          .listingImages!
                                                          .isEmpty
                                                      ? 1
                                                      : frontendListingCtrl
                                                          .listingDetailsList[0]
                                                          .listingImages!
                                                          .length,
                                                  position: frontendListingCtrl.carouselIndex,
                                                  decorator: DotsDecorator(
                                                    color: AppColors.whiteColor,
                                                    activeColor:
                                                        AppColors.mainColor,
                                                  ),
                                                ),
                                              InkResponse(
                                                onTap: () async {
                                                  final result =
                                                      await Share.share(frontendListingCtrl
                                                          .listingDetailsList[0]
                                                          .current_url
                                                          .toString());

                                                  if (result.status ==
                                                      ShareResultStatus
                                                          .success) {
                                                    print(
                                                        'Thank you for sharing my website!');
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.share,
                                                    color: AppColors.blackColor,
                                                    size: 18.h,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          VSpace(20.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            VSpace(20.h),
                            if (frontendListingCtrl.listingDetailsList.isNotEmpty)
                              Padding(
                                padding: Dimensions.kDefaultPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${frontendListingCtrl.listingDetailsList[0].title.toString()}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.bodyLarge?.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    VSpace(5.h),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                                '${frontendListingCtrl.listingDetailsList[0].categories.toString()}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodyMedium)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 8.w),
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 14.h,
                                              ),
                                              HSpace(3.w),
                                              Text(
                                                '${double.parse(frontendListingCtrl.listingDetailsList[0].averageRating.toString()).toStringAsFixed(1)}',
                                                style: t.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        HSpace(8.w),
                                        Text(
                                            frontendListingCtrl.listingDetailsList[0]
                                                        .getReviews ==
                                                    null
                                                ? "(0 Reviews)" // ?
                                                : '( ${frontendListingCtrl.listingDetailsList[0].getReviews!.length.toString()} Reviews )',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodySmall),
                                      ],
                                    ),
                                    VSpace(28.h),
                                    InkWell(
                                      onTap: () {
                                        if (frontendListingCtrl.listingDetailsList[0].user !=
                                            null) {
                                          frontendListingCtrl.authorUsername = frontendListingCtrl
                                                  .listingDetailsList[0]
                                                  .user!
                                                  .username ??
                                              "";
                                          frontendListingCtrl.getAuthorProfile(
                                              userName: frontendListingCtrl.listingDetailsList[0]
                                                      .user!.username ??
                                                  "");
                                          Get.toNamed(
                                              RoutesName.authorProfileScreen);
                                        } else {
                                          Helpers.showSnackBar(
                                              msg: "User not found");
                                        }
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 34.h,
                                              width: 34.h,
                                              decoration: BoxDecoration(
                                                color: AppThemes.getFillColor(),
                                                border: Border.all(
                                                    color: AppColors.mainColor,
                                                    width: 2.h),
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: frontendListingCtrl
                                                              .listingDetailsList[
                                                                  0]
                                                              .user ==
                                                          null
                                                      ? ""
                                                      : frontendListingCtrl.listingDetailsList[0]
                                                          .user!.image
                                                          .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            HSpace(15.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  frontendListingCtrl.listingDetailsList[0]
                                                              .user ==
                                                          null
                                                      ? ""
                                                      : frontendListingCtrl.listingDetailsList[0]
                                                              .user!.firstname
                                                              .toString() +
                                                          " " +
                                                          frontendListingCtrl.listingDetailsList[0]
                                                              .user!.lastname
                                                              .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodyMedium?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "Member since ${DateFormat("MMMM yyyy").format(DateTime.parse(frontendListingCtrl.listingDetailsList[0].user!.created_at.toString()))}",
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppColors.black50),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            InkResponse(
                                              onTap: () {
                                                appDialog(
                                                    context: context,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            storedLanguage[
                                                                    'Contact Seller'] ??
                                                                "Contact Seller",
                                                            style:
                                                                t.bodyMedium),
                                                        InkResponse(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    7.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppThemes
                                                                  .getFillColor(),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 14.h,
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .blackColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .call_outlined,
                                                              size: 18.h,
                                                              color: AppThemes
                                                                  .getIconBlackColor(),
                                                            ),
                                                            HSpace(10.w),
                                                            SelectableText(frontendListingCtrl
                                                                        .listingDetailsList[
                                                                            0]
                                                                        .user ==
                                                                    null
                                                                ? ""
                                                                : "${frontendListingCtrl.listingDetailsList[0].user!.phone.toString()}")
                                                          ],
                                                        ),
                                                        VSpace(15.h),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .email_outlined,
                                                              size: 17.h,
                                                              color: AppThemes
                                                                  .getIconBlackColor(),
                                                            ),
                                                            HSpace(10.w),
                                                            SelectableText(frontendListingCtrl
                                                                        .listingDetailsList[
                                                                            0]
                                                                        .user ==
                                                                    null
                                                                ? ""
                                                                : "${frontendListingCtrl.listingDetailsList[0].user!.email.toString()}")
                                                          ],
                                                        ),
                                                        VSpace(15.h),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 18.h,
                                                              color: AppThemes
                                                                  .getIconBlackColor(),
                                                            ),
                                                            HSpace(10.w),
                                                            SelectableText(frontendListingCtrl
                                                                        .listingDetailsList[
                                                                            0]
                                                                        .user ==
                                                                    null
                                                                ? ""
                                                                : "${frontendListingCtrl.listingDetailsList[0].user!.addressOne.toString()}, ${frontendListingCtrl.listingDetailsList[0].user!.addressTwo.toString()}")
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  "$rootImageDir/message.png",
                                                  width: 18.w,
                                                  height: 18.h,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VSpace(32.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius: Dimensions.kBorderRadius,
                                      ),
                                      child: TabBar(
                                        onTap: (index) {
                                          frontendListingCtrl.selectedIndex = index;
                                          frontendListingCtrl.update();
                                        },
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.transparent),
                                        labelPadding: EdgeInsets.only(
                                            right: 24.w, left: 24.w),
                                        indicatorColor: Colors.transparent,
                                        dividerColor: Colors.transparent,
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        tabs: List.generate(
                                            frontendListingCtrl.categoryList.length,
                                            (i) => Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.h),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: frontendListingCtrl.selectedIndex ==
                                                                      i
                                                                  ? AppColors
                                                                      .mainColor
                                                                  : Colors
                                                                      .transparent,
                                                              width: 4.h))),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 4.h),
                                                    child: Text(
                                                        frontendListingCtrl.categoryList[i],
                                                        style: t.bodyMedium?.copyWith(
                                                            color: frontendListingCtrl.selectedIndex == i
                                                                ? AppThemes.getIconBlackColor()
                                                                : Get.isDarkMode
                                                                    ? AppColors.whiteColor
                                                                    : AppColors.black50)),
                                                  ),
                                                )),
                                      ),
                                    ),
                                    Column(children: [
                                      VSpace(35.h),
                                      if (frontendListingCtrl.selectedIndex == 0)
                                        descriptionWidget(
                                            frontendListingCtrl, t, context, storedLanguage),
                                      if (frontendListingCtrl.selectedIndex == 1)
                                        videoWidget(frontendListingCtrl, t, context),
                                      if (frontendListingCtrl.selectedIndex == 2)
                                        amenitiesWidget(frontendListingCtrl, t, storedLanguage),
                                      if (frontendListingCtrl.selectedIndex == 3)
                                        productsWidget(frontendListingCtrl, t, storedLanguage),
                                      if (frontendListingCtrl.selectedIndex == 4)
                                        socialWidget(frontendListingCtrl, t, context, storedLanguage),
                                      if (frontendListingCtrl.selectedIndex == 5)
                                        reviewWidget(frontendListingCtrl, t, context),
                                    ]),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
              ));
        });
      });
    });
  }

  Column reviewWidget(
      FrontendListingController frontendListingCtrl, TextTheme t, BuildContext context) {
    return Column(
      children: [
        if (frontendListingCtrl.listingDetailsList[0].reviewDone == 0 &&
            HiveHelp.read(Keys.userId) !=
                frontendListingCtrl.listingDetailsList[0].user!.id.toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: frontendListingCtrl.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30.h,
                    unratedColor:
                        Get.isDarkMode ? AppColors.black60 : AppColors.black30,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppColors.mainColor,
                      size: 30.h,
                    ),
                    onRatingUpdate: frontendListingCtrl.onRatingUpdate,
                  ),
                  HSpace(15.w),
                  frontendListingCtrl.ratingExpression(),
                ],
              ),
              VSpace(30.h),
              CustomTextField(
                height: 132.h,
                contentPadding:
                    EdgeInsets.only(left: 20.w, bottom: 0.h, top: 10.h),
                alignment: Alignment.topLeft,
                minLines: 3,
                maxLines: 5,
                isPrefixIcon: false,
                controller: frontendListingCtrl.reviewEditingCtrlr,
                hintext: "Wrie Reviews",
              ),
              AppButton(
                text: "Submit Review",
                isLoading: frontendListingCtrl.isReviewSubmitting ? true : false,
                onTap: frontendListingCtrl.isReviewSubmitting
                    ? null
                    : () async {
                        await frontendListingCtrl.onReviwSubmit(fields: {
                          "listing_id": frontendListingCtrl.listingDetailsList[0].id.toString(),
                          "rating": frontendListingCtrl.rating.toString(),
                          "review": frontendListingCtrl.reviewEditingCtrlr.text,
                        });
                      },
              ),
              VSpace(65.h),
            ],
          ),
        if (frontendListingCtrl.listingDetailsList[0].getReviews == null ||
            frontendListingCtrl.listingDetailsList[0].getReviews!.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Helpers.notFound(top: 0, text: "No reviews found"),
                VSpace(20.h),
              ],
            ),
          ),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: frontendListingCtrl.listingDetailsList[0].getReviews!.length,
            itemBuilder: (context, i) {
              var data = frontendListingCtrl.listingDetailsList[0].getReviews![i];
              return Padding(
                padding: EdgeInsets.only(bottom: 45.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(6.r),
                      onTap: () {
                        frontendListingCtrl.authorUsername = data.username ?? "";
                        frontendListingCtrl.getAuthorProfile(userName: data.username ?? "");
                        Get.toNamed(RoutesName.authorProfileScreen);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 34.h,
                            width: 34.h,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              border: Border.all(
                                  color: AppColors.mainColor, width: 2.h),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data.image.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          HSpace(15.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.username.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: List.generate(
                                      5,
                                      (i) => Icon(
                                            Icons.star,
                                            color: i >=
                                                    int.parse(
                                                        data.rating.toString())
                                                ? Get.isDarkMode
                                                    ? AppColors.black60
                                                    : AppColors.black30
                                                : AppColors.starColor,
                                            size: 18.h,
                                          )),
                                ),
                              ],
                            ),
                          ),
                          Text(
                              data.createdAt == null
                                  ? ""
                                  : "${DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(data.createdAt.toString()))}",
                              style: t.bodySmall),
                        ],
                      ),
                    ),
                    VSpace(12.h),
                    ReadMoreText(data.review.toString(),
                        trimLines: 5,
                        colorClickableText: Colors.blue,
                        preDataTextStyle: context.t.bodySmall,
                        postDataTextStyle: context.t.bodySmall,
                        trimMode: TrimMode.Length,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: ' Show less',
                        lessStyle: context.t.displayMedium
                            ?.copyWith(height: 1.5, color: Colors.blue),
                        moreStyle: context.t.displayMedium
                            ?.copyWith(height: 1.5, color: Colors.blue),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: Styles.appFontFamily,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black50)),
                  ],
                ),
              );
            }),
        VSpace(20.h),
      ],
    );
  }

  Column productsWidget(
      FrontendListingController frontendCtrl, TextTheme t, storedLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (frontendCtrl.listingDetailsList[0].getProducts == null ||
            frontendCtrl.listingDetailsList[0].getProducts!.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Helpers.notFound(top: 0, text: "No products found"),
                VSpace(20.h),
              ],
            ),
          ),
        if (frontendCtrl.listingDetailsList[0].getProducts != null &&
            frontendCtrl.listingDetailsList[0].getProducts!.isNotEmpty)
          GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4.h / 4.7.h,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.w,
                  mainAxisSpacing: 20.h),
              itemCount: frontendCtrl.listingDetailsList[0].getProducts!.length,
              itemBuilder: (context, i) {
                var data = frontendCtrl.listingDetailsList[0].getProducts![i];
                return InkWell(
                  borderRadius: Dimensions.kBorderRadius,
                  onTap: () {
                    Get.to(() => ProductDetailsScreen(
                          data: data,
                          listingId: data.id.toString(),
                        ));
                  },
                  child: Container(
                    width: 190.w,
                    height: 300.h,
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                              color: AppColors.greyColor,
                              borderRadius: Dimensions.kBorderRadius,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      data.productThumbnail.toString()),
                                  fit: BoxFit.cover)),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 10.w),
                                margin: EdgeInsets.only(left: 10.w, top: 10.h),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: Text(
                                  "${HiveHelp.read(Keys.currencySymbol) ?? "\$"}${data.productPrice.toString()}",
                                  style: t.bodySmall?.copyWith(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VSpace(10.h),
                        Text(
                          "${data.productTitle.toString()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        VSpace(4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              storedLanguage['View Details'] ?? "View Details",
                              style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppThemes.getIconBlackColor()),
                            ),
                            HSpace(5.w),
                            Icon(
                              Icons.arrow_forward,
                              size: 20.h,
                              color: AppThemes.getIconBlackColor(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        VSpace(50.h),
      ],
    );
  }

  Column amenitiesWidget(
      FrontendListingController frontendCtrl, TextTheme t, storedLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (frontendCtrl.listingDetailsList[0].listingAmenities == null ||
            frontendCtrl.listingDetailsList[0].listingAmenities!.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Helpers.notFound(top: 0, text: "No amenities found"),
                VSpace(20.h),
              ],
            ),
          ),
        if (frontendCtrl.listingDetailsList[0].listingAmenities != null &&
            frontendCtrl.listingDetailsList[0].listingAmenities!.isNotEmpty)
          Wrap(
            runSpacing: 15.h,
            children: [
              ...List.generate(frontendCtrl.listingDetailsList[0].listingAmenities!.length,
                  (i) {
                var data = frontendCtrl.listingDetailsList[0].listingAmenities![i];
                return data.title == null
                    ? SizedBox()
                    : Row(
                        children: [
                          Image.asset(
                            '$rootImageDir/amenities.png',
                            height: 22.h,
                            width: 22.h,
                            color: AppThemes.getIconBlackColor(),
                          ),
                          HSpace(10.w),
                          Text("${data.title.toString()}",
                              style: t.displayMedium)
                        ],
                      );
              }),
            ],
          ),
      ],
    );
  }

  Column descriptionWidget(FrontendListingController frontendCtrl, TextTheme t,
      BuildContext context, storedLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              "$rootImageDir/location.png",
              height: 14.h,
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
            ),
            HSpace(12.w),
            Expanded(
              child: Text(
                "${frontendCtrl.listingDetailsList[0].address.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: t.bodyMedium?.copyWith(
                    color: Get.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black50),
              ),
            )
          ],
        ),
        if (frontendCtrl.listingDetailsList[0].user!.website != null &&
            frontendCtrl.listingDetailsList[0].user!.website.toString().isNotEmpty)
          VSpace(12.h),
        if (frontendCtrl.listingDetailsList[0].user!.website != null &&
            frontendCtrl.listingDetailsList[0].user!.website.toString().isNotEmpty)
          Row(
            children: [
              Image.asset(
                "$rootImageDir/world.png",
                height: 14.h,
                color:
                    Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
              ),
              HSpace(12.w),
              Expanded(
                child: Text(
                  frontendCtrl.listingDetailsList[0].user == null
                      ? ""
                      : "${frontendCtrl.listingDetailsList[0].user!.website.toString()}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: t.bodyMedium?.copyWith(
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black50),
                ),
              ),
            ],
          ),
        // Email contact information (listing's direct email)
        if (frontendCtrl.listingDetailsList[0].email != null &&
            frontendCtrl.listingDetailsList[0].email.toString().isNotEmpty)
          VSpace(12.h),
        if (frontendCtrl.listingDetailsList[0].email != null &&
            frontendCtrl.listingDetailsList[0].email.toString().isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14.h,
                color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
              ),
              HSpace(12.w),
              Expanded(
                child: SelectableText(
                  "${frontendCtrl.listingDetailsList[0].email.toString()}",
                  style: t.bodyMedium?.copyWith(
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black50),
                ),
              ),
            ],
          ),
        // Phone contact information (listing's direct phone)
        if (frontendCtrl.listingDetailsList[0].phone != null &&
            frontendCtrl.listingDetailsList[0].phone.toString().isNotEmpty)
          VSpace(12.h),
        if (frontendCtrl.listingDetailsList[0].phone != null &&
            frontendCtrl.listingDetailsList[0].phone.toString().isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.call_outlined,
                size: 14.h,
                color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
              ),
              HSpace(12.w),
              Expanded(
                child: SelectableText(
                  "${frontendCtrl.listingDetailsList[0].phone.toString()}",
                  style: t.bodyMedium?.copyWith(
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black50),
                ),
              ),
            ],
          ),
        // WhatsApp contact information (from listing data)
        if (frontendCtrl.listingDetailsList[0].whatsappNumber != null &&
            frontendCtrl.listingDetailsList[0].whatsappNumber.toString().isNotEmpty)
          VSpace(12.h),
        if (frontendCtrl.listingDetailsList[0].whatsappNumber != null &&
            frontendCtrl.listingDetailsList[0].whatsappNumber.toString().isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.chat_outlined,
                size: 14.h,
                color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
              ),
              HSpace(12.w),
              Expanded(
                child: SelectableText(
                  "${frontendCtrl.listingDetailsList[0].whatsappNumber.toString()}",
                  style: t.bodyMedium?.copyWith(
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black50),
                ),
              ),
            ],
          ),
        VSpace(24.h),
        ReadMoreText(frontendCtrl.listingDetailsList[0].description.toString(),
            trimLines: 5,
            colorClickableText: AppColors.mainColor,
            preDataTextStyle: context.t.bodySmall,
            postDataTextStyle: context.t.bodySmall,
            trimMode: TrimMode.Length,
            trimCollapsedText: 'Show more',
            trimExpandedText: ' Show less',
            lessStyle: context.t.displayMedium
                ?.copyWith(height: 1.5, color: Colors.blue),
            moreStyle: context.t.displayMedium
                ?.copyWith(height: 1.5, color: Colors.blue),
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: Styles.appFontFamily,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color:
                    Get.isDarkMode ? AppColors.whiteColor : AppColors.black50)),
        VSpace(24.h),
        if (frontendCtrl.dynamicFormList.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemes.getFillColor(),
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: frontendCtrl.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (frontendCtrl.dynamicFormList.isNotEmpty) ...[
                        Text(
                            frontendCtrl.formName == "null"
                                ? "Data Collection Form"
                                : frontendCtrl.formName,
                            style: t.bodyLarge),
                        if (frontendCtrl.formName != "null") VSpace(20.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: frontendCtrl.dynamicFormList.length,
                          itemBuilder: (context, index) {
                            final dynamicField = frontendCtrl.dynamicFormList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dynamicField.type == "file")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldName,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        height: 45.5,
                                        width: double.maxFinite,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          border: Border.all(
                                              color: frontendCtrl.fileColorOfDField ==
                                                      AppColors.redColor
                                                  ? frontendCtrl.fileColorOfDField
                                                  : AppThemes
                                                      .getSliderInactiveColor(),
                                              width: 1),
                                        ),
                                        child: Row(
                                          children: [
                                            HSpace(12.w),
                                            Text(
                                              frontendCtrl.imagePickerResults[
                                                          dynamicField.key] !=
                                                      null
                                                  ? storedLanguage[
                                                          '1 File selected'] ??
                                                      "1 File selected"
                                                  : storedLanguage[
                                                          'No File selected'] ??
                                                      "No File selected",
                                              style: context.t.bodySmall?.copyWith(
                                                  color: frontendCtrl.imagePickerResults[
                                                              dynamicField
                                                                  .fieldName] !=
                                                          null
                                                      ? AppColors.greenColor
                                                      : AppColors.black60),
                                            ),
                                            const Spacer(),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  Helpers.hideKeyboard();

                                                  await frontendCtrl.pickFile(
                                                      dynamicField.key);
                                                },
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                child: Ink(
                                                  width: 113.w,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius: Dimensions
                                                            .kBorderRadius /
                                                        1.7,
                                                    border: Border.all(
                                                        color:
                                                            AppColors.mainColor,
                                                        width: .2),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                          storedLanguage[
                                                                  'Choose File'] ??
                                                              'Choose File',
                                                          style: context
                                                              .t.bodySmall
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .whiteColor))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "text")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldName,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          frontendCtrl
                                              .textEditingControllerMap[
                                                  dynamicField.key]!
                                              .text = v;
                                        },
                                        controller: frontendCtrl.textEditingControllerMap[
                                            dynamicField.key],
                                        keyboardType: dynamicField.fieldName
                                                .toString()
                                                .toLowerCase()
                                                .contains("number")
                                            ? TextInputType.number
                                            : TextInputType.text,
                                        inputFormatters: dynamicField.fieldName
                                                .toString()
                                                .toLowerCase()
                                                .contains("number")
                                            ? <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ]
                                            : [],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),

                                          fillColor: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppThemes
                                                  .getSliderInactiveColor(),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "number")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldName,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          frontendCtrl
                                              .textEditingControllerMap[
                                                  dynamicField.key]!
                                              .text = v;
                                        },
                                        controller: frontendCtrl.textEditingControllerMap[
                                            dynamicField.key],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          fillColor: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),

                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppThemes
                                                  .getSliderInactiveColor(),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "date")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldName,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          /// SHOW DATE PICKER
                                          await showDatePicker(
                                            context: context,
                                            builder: (context, child) {
                                              return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.dark(
                                                      surface: Get.isDarkMode
                                                          ? AppColors
                                                              .darkCardColor
                                                          : AppColors
                                                              .paragraphColor,
                                                      onPrimary:
                                                          AppColors.whiteColor,
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor: AppColors
                                                            .mainColor, // button text color
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!);
                                            },
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(
                                                DateTime.now().year.toInt() +
                                                    1),
                                          ).then((value) {
                                            if (value != null) {
                                              frontendCtrl
                                                      .textEditingControllerMap[
                                                          dynamicField.key]!
                                                      .text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(value);
                                            }
                                          });
                                        },
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            controller:
                                                frontendCtrl.textEditingControllerMap[
                                                    dynamicField.key],
                                            decoration: InputDecoration(
                                              fillColor: Get.isDarkMode
                                                  ? AppColors.darkCardColorDeep
                                                  : AppColors.whiteColor,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == 'textarea')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldName,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        controller: frontendCtrl.textEditingControllerMap[
                                            dynamicField.key],
                                        minLines: 6,
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          fillColor: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 16),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppThemes
                                                  .getSliderInactiveColor(),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: frontendCtrl.dropdownList.length,
                          itemBuilder: (context, index) {
                            final dynamicField = frontendCtrl.dropdownList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dynamicField.type == "select")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dynamicField.fieldName,
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        height: 46.h,
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.whiteColor,
                                          border: Border.all(
                                              color: AppThemes
                                                  .getSliderInactiveColor()),
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                        ),
                                        child: AppCustomDropDown(
                                          bgColor: AppThemes.getDarkCardColor(),
                                          height: 46.h,
                                          width: double.infinity,
                                          items: dynamicField.optionList == null
                                              ? []
                                              : dynamicField.optionList!
                                                  .map((e) => e)
                                                  .toList(),
                                          selectedValue: frontendCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.key]!
                                                  .text
                                                  .isEmpty
                                              ? null
                                              : frontendCtrl
                                                  .textEditingControllerMap[
                                                      dynamicField.key]!
                                                  .text,
                                          onChanged: (v) {
                                            frontendCtrl
                                                .textEditingControllerMap[
                                                    dynamicField.key]
                                                ?.text = v;
                                            frontendCtrl.update();
                                          },
                                          hint: "Select " +
                                              dynamicField.fieldName,
                                          fontSize: 14.sp,
                                          hintStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color:
                                                  AppColors.textFieldHintColor),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  )
                              ],
                            );
                          },
                        ),
                      ],
                      VSpace(20.h),
                      Material(
                        color: Colors.transparent,
                        child: AppButton(
                            isLoading: frontendCtrl.isSubmittingDynamicForm,
                            text: frontendCtrl.formButtonName == "null"
                                ? "Submit"
                                : '${frontendCtrl.formButtonName}',
                            onTap: frontendCtrl.isSubmittingDynamicForm
                                ? null
                                : () async {
                                    Helpers.hideKeyboard();
                                    if (frontendCtrl.formKey.currentState!.validate() &&
                                        frontendCtrl.requiredFile.isEmpty) {
                                      frontendCtrl.fileColorOfDField = AppColors.mainColor;
                                      frontendCtrl.update();
                                      await frontendCtrl.renderDynamicFieldData();

                                      Map<String, String> stringMap = {};
                                      frontendCtrl.dynamicData.forEach((key, value) {
                                        if (value is String) {
                                          stringMap[key] = value;
                                        }
                                      });

                                      await Future.delayed(
                                          Duration(milliseconds: 300));

                                      Map<String, String> body = {
                                        "dynamic_forms_id": frontendCtrl.formId,
                                        "listing_id": frontendCtrl.listingDetailsList[0].id
                                            .toString(),
                                      };
                                      body.addAll(stringMap);

                                      await frontendCtrl
                                          .submitListingFormData(
                                              fields: body,
                                              fileList: frontendCtrl.fileMap.entries
                                                  .map((e) => e.value)
                                                  .toList(),
                                              context: context)
                                          .then((value) {});
                                    } else {
                                      frontendCtrl.fileColorOfDField = AppColors.redColor;
                                      frontendCtrl.update();
                                      print(
                                          "required type file list===========================: ${frontendCtrl.requiredFile}");
                                      Helpers.showSnackBar(
                                          msg:
                                              "Please fill in all required fields.");
                                    }
                                  }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        VSpace(24.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppThemes.getFillColor(),
            borderRadius: Dimensions.kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storedLanguage['Opening Hours'] ?? "Opening Hours",
                style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              VSpace(16.h),
              ...List.generate(
                  frontendCtrl.listingDetailsList[0].getBusinessHour!.length,
                  (i) => Padding(
                        padding: EdgeInsets.only(bottom: i == 5 ? 0 : 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (frontendCtrl.listingDetailsList[0].getBusinessHour![i]
                                .workingDay
                                .toString()
                                .isNotEmpty)
                              Text(
                                "${frontendCtrl.listingDetailsList[0].getBusinessHour![i].workingDay}",
                                style: t.displayMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.black80),
                              ),
                            if (frontendCtrl.listingDetailsList[0].getBusinessHour![i]
                                        .startTime
                                        .toString() !=
                                    "00:00:00" &&
                                frontendCtrl.listingDetailsList[0].getBusinessHour![i]
                                        .endTime
                                        .toString() !=
                                    "00:00:00")
                              Text(
                                "${DateFormat("h:mm a").format(DateFormat("HH:mm:ss").parse(frontendCtrl.listingDetailsList[0].getBusinessHour![i].startTime.toString()))} - ${DateFormat("h:mm a").format(DateFormat("HH:mm:ss").parse(frontendCtrl.listingDetailsList[0].getBusinessHour![i].endTime.toString()))}",
                                style: t.bodySmall?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.black80),
                              ),
                          ],
                        ),
                      )),
            ],
          ),
        ),
        VSpace(24.h),
        if (ProfileController.to.isLeafLetMap != true)
          Container(
              width: double.maxFinite,
              height: 226.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                border: Border.all(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : AppColors.fillColor,
                    width: 5.h),
              ),
              child: GoogleMapScreen(
                  isFromListingDetailsPage: true,
                  latLng: LatLng(
                      double.parse(frontendCtrl.listingDetailsList[0].lat.toString()),
                      double.parse(frontendCtrl.listingDetailsList[0].long.toString())))),
        if (ProfileController.to.isLeafLetMap == true)
          Container(
              width: double.maxFinite,
              height: 226.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                border: Border.all(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : AppColors.fillColor,
                    width: 5.h),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  InteractiveMapScreen(
                    isFromListingDetailsPage: true,
                    latLng: latlng.LatLng(
                        double.parse(frontendCtrl.listingDetailsList[0].lat.toString()),
                        double.parse(frontendCtrl.listingDetailsList[0].long.toString())),
                  ),
               
                ],
              )),
        VSpace(24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            color: AppThemes.getFillColor(),
            borderRadius: Dimensions.kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 190.w,
                    height: 110.h,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 0,
                            bottom: 0,
                            top: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Listplac",
                                  style:
                                      t.titleLarge?.copyWith(fontSize: 20.sp),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Image.asset(
                                        "$rootImageDir/app_icon_main.png",
                                        width: 62.w,
                                        height: 32.h,
                                      ),
                                    ),
                                    Positioned(
                                      top: 7.h,
                                      left: 14.w,
                                      bottom: 0,
                                      right: 0,
                                      child: Text(
                                        "e",
                                        style: t.titleLarge?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                Styles.appOtherFontFamily),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            storedLanguage['Claim This Business'] ??
                                "Claim This Business",
                            style: t.displayMedium),
                        VSpace(15.h),
                        Material(
                          color: Colors.transparent,
                          child: AppButton(
                            buttonHeight: 35.h,
                            style: t.displayMedium
                                ?.copyWith(color: AppColors.blackColor),
                            onTap: () {
                              appDialog(
                                  context: context,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          storedLanguage['Claim Business'] ??
                                              "Claim Business",
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
                                      Text(
                                        "Do you really want to make this claim? If you can't prove it, you should face a fine.",
                                        style: t.displayMedium,
                                      ),
                                      VSpace(12.h),
                                      CustomTextField(
                                        controller:
                                            frontendCtrl.claimBusinessFullNameEditingCtrl,
                                        contentPadding:
                                            EdgeInsets.only(left: 20.w),
                                        hintext: storedLanguage['Full Name'] ??
                                            "Full Name",
                                        isPrefixIcon: false,
                                      ),
                                      VSpace(25.h),
                                      CustomTextField(
                                        height: 132.h,
                                        contentPadding: EdgeInsets.only(
                                            left: 20.w, bottom: 0.h, top: 10.h),
                                        alignment: Alignment.topLeft,
                                        minLines: 6,
                                        maxLines: 10,
                                        isPrefixIcon: false,
                                        controller:
                                            frontendCtrl.claimBusinessMsgEditingCtrl,
                                        hintext:
                                            storedLanguage['Enter Message'] ??
                                                "Enter Message",
                                      ),
                                      VSpace(28.h),
                                      GetBuilder<FrontendListingController>(
                                          builder: (frontendCtrl) {
                                        return AppButton(
                                          isLoading: frontendCtrl.isCaliming,
                                          text: storedLanguage['Claim Now'] ??
                                              "Claim Now",
                                          style: t.bodyMedium?.copyWith(
                                              color: AppColors.blackColor),
                                          onTap: frontendCtrl.isCaliming
                                              ? null
                                              : () async {
                                                  await frontendCtrl.onClaimBusinessSubmit(
                                                      context: context,
                                                      listingId: frontendCtrl
                                                          .listingDetailsList[0]
                                                          .id
                                                          .toString());
                                                },
                                        );
                                      }),
                                    ],
                                  ));
                            },
                            text: storedLanguage['Claim Now'] ?? "Claim Now",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        VSpace(24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppThemes.getFillColor(),
            borderRadius: Dimensions.kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                fillColor: Get.isDarkMode
                    ? AppColors.darkCardColorDeep
                    : AppColors.whiteColor,
                controller: frontendCtrl.sendMsgFullNameEditingCtrl,
                contentPadding: EdgeInsets.only(left: 20.w),
                hintext: storedLanguage['Fulll Name'] ?? "Full Name",
                isPrefixIcon: false,
              ),
              VSpace(25.h),
              CustomTextField(
                height: 132.h,
                contentPadding:
                    EdgeInsets.only(left: 20.w, bottom: 0.h, top: 10.h),
                alignment: Alignment.topLeft,
                minLines: 6,
                maxLines: 10,
                fillColor: Get.isDarkMode
                    ? AppColors.darkCardColorDeep
                    : AppColors.whiteColor,
                isPrefixIcon: false,
                controller: frontendCtrl.sendMsgMessageEditingCtrl,
                hintext: storedLanguage['Enter Message'] ?? "Enter Message",
              ),
              VSpace(28.h),
              Material(
                color: Colors.transparent,
                child: AppButton(
                  isLoading: frontendCtrl.isSubmittingListingMsg,
                  text:
                      storedLanguage['Send Message Now'] ?? "Send Message Now",
                  onTap: frontendCtrl.isSubmittingListingMsg
                      ? null
                      : () async {
                          await frontendCtrl.onlistingMsgSubmit(
                              context: context,
                              listingId: frontendCtrl.listingDetailsList[0].id.toString());
                        },
                ),
              ),
            ],
          ),
        ),
        VSpace(50.h),
      ],
    );
  }

  Column videoWidget(FrontendListingController frontendCtrl, TextTheme t, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (frontendCtrl.listingDetailsList[0].youtubeVideoId == null ||
            frontendCtrl.listingDetailsList[0].youtubeVideoId.toString().isEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Helpers.notFound(top: 0, text: "No video found"),
                VSpace(20.h),
              ],
            ),
          ),
        if (frontendCtrl.listingDetailsList[0].youtubeVideoId != null &&
            frontendCtrl.listingDetailsList[0].youtubeVideoId.toString().isNotEmpty)
          Container(
            padding: EdgeInsets.all(12.h),
            width: double.maxFinite,
            height: 210.h,
            decoration: BoxDecoration(
              color: AppThemes.getFillColor(),
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: Dimensions.kBorderRadius,
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId:
                          frontendCtrl.listingDetailsList[0].youtubeVideoId.toString(),
                      flags: YoutubePlayerFlags(autoPlay: false),
                    ),
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: AppColors.mainColor,
                    progressColors: ProgressBarColors(
                      playedColor: AppColors.mainColor,
                      handleColor: AppColors.mainColor,
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: frontendCtrl.isCopiedVideId
                          ? null
                          : () async {
                              frontendCtrl.isCopiedVideId = true;
                              frontendCtrl.update();
                              Clipboard.setData(ClipboardData(
                                  text:
                                      "https://youtu.be/${frontendCtrl.listingDetailsList[0].youtubeVideoId.toString()}"));

                              Helpers.showSnackBar(
                                  title: "Success",
                                  msg: "Copied Successfully",
                                  bgColor: AppColors.greenColor);
                              await Future.delayed(Duration(seconds: 4));
                              frontendCtrl.isCopiedVideId = false;
                              frontendCtrl.update();
                            },
                      child: Tooltip(
                        message: "Copy link",
                        child: Container(
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            frontendCtrl.isCopiedVideId ? Icons.done : Icons.copy,
                            color: frontendCtrl.isCopiedVideId
                                ? AppColors.greenColor
                                : AppColors.black70,
                            size: 24.h,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
      ],
    );
  }

  Column socialWidget(FrontendListingController frontendCtrl, TextTheme t,
      BuildContext context, storedLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (frontendCtrl.listingDetailsList[0].getSocialInfo == null ||
            frontendCtrl.listingDetailsList[0].getSocialInfo!.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Helpers.notFound(top: 0, text: storedLanguage['No social media links found'] ?? "No social media links found"),
                VSpace(20.h),
              ],
            ),
          ),
        if (frontendCtrl.listingDetailsList[0].getSocialInfo != null &&
            frontendCtrl.listingDetailsList[0].getSocialInfo!.isNotEmpty)
          Container(
            padding: EdgeInsets.all(20.w),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppThemes.getFillColor(),
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storedLanguage['Social Media Links'] ?? "Social Media Links",
                  style: t.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
                VSpace(16.h),
                ...frontendCtrl.listingDetailsList[0].getSocialInfo!.map((socialInfo) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: InkWell(
                      onTap: () async {
                        if (socialInfo.socialUrl != null &&
                            socialInfo.socialUrl.toString().isNotEmpty) {
                          final Uri url = Uri.parse(socialInfo.socialUrl.toString());
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            Helpers.showSnackBar(
                              title: 'Error',
                              msg: 'Could not launch ${socialInfo.socialUrl}',
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Get.isDarkMode ? AppColors.black30 : AppColors.black10,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                _getSocialIcon(socialInfo.socialIcon.toString()),
                                size: 20.h,
                                color: AppColors.mainColor,
                              ),
                            ),
                            HSpace(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getSocialPlatformName(socialInfo.socialIcon.toString()),
                                    style: t.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                    ),
                                  ),
                                  VSpace(2.h),
                                  Text(
                                    socialInfo.socialUrl.toString(),
                                    style: t.bodySmall?.copyWith(
                                      color: Get.isDarkMode ? AppColors.black30 : AppColors.black50,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              size: 16.h,
                              color: Get.isDarkMode ? AppColors.black30 : AppColors.black50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        VSpace(50.h),
      ],
    );
  }

  c.CarouselSlider caroselSection(c.CarouselSliderController controller,
      TextTheme t, FrontendListingController frontendCtrl) {
    return c.CarouselSlider(
        carouselController: controller,
        items: frontendCtrl.listingDetailsList[0].listingImages!.isEmpty
            ? [
                buildCaroselWidget(fListingModel.ListingImage(), frontendCtrl, t, 0,
                    isThumbnail: true,
                    thumbnail: frontendCtrl.listingDetailsList[0].thumbnail.toString())
              ]
            : frontendCtrl.listingDetailsList[0].listingImages!
                .map(
                  (e) => buildCaroselWidget(e, frontendCtrl, t,
                      frontendCtrl.listingDetailsList[0].listingImages!.indexOf(e),
                      isThumbnail: false,
                      listingImages: frontendCtrl.listingDetailsList[0].listingImages),
                )
                .toList(),
        options: c.CarouselOptions(
          height: Dimensions.screenHeight * .4,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          onPageChanged: (index, c) {
            frontendCtrl.carouselIndex = index;
            frontendCtrl.update();
          },
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget buildCaroselWidget(fListingModel.ListingImage e,
      FrontendListingController _, TextTheme t, int imgIndex,
      {bool? isThumbnail = false,
      String? thumbnail,
      List<fListingModel.ListingImage>? listingImages}) {
    return InkWell(
      onTap: () {
        if (isThumbnail == false) {
          Get.to(() => ViewPhotos(
                imageIndex: imgIndex,
                imageList: listingImages!,
              ));
        } else {
          Get.to(() => Scaffold(
              appBar: const CustomAppBar(title: "PhotoView"),
              body: PhotoView(
                imageProvider: NetworkImage(thumbnail ?? ""),
              )));
        }
      },
      child: Container(
        height: Dimensions.screenHeight * .3,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppThemes.getFillColor(),
          image: DecorationImage(
            image: CachedNetworkImageProvider(isThumbnail == true
                ? thumbnail.toString()
                : e.listingImage ?? ""),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16.r)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12.withValues(alpha: .8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 0.4, 0.4, 0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get social media icon based on icon name
  IconData _getSocialIcon(String iconName) {
    final iconNameLower = iconName.toLowerCase();

    if (iconNameLower.contains('facebook')) {
      return FontAwesomeIcons.facebook;
    } else if (iconNameLower.contains('twitter') || iconNameLower.contains('x')) {
      return FontAwesomeIcons.twitter;
    } else if (iconNameLower.contains('instagram')) {
      return FontAwesomeIcons.instagram;
    } else if (iconNameLower.contains('linkedin')) {
      return FontAwesomeIcons.linkedin;
    } else if (iconNameLower.contains('youtube')) {
      return FontAwesomeIcons.youtube;
    } else if (iconNameLower.contains('whatsapp')) {
      return FontAwesomeIcons.whatsapp;
    } else if (iconNameLower.contains('telegram')) {
      return FontAwesomeIcons.telegram;
    } else if (iconNameLower.contains('google')) {
      return FontAwesomeIcons.google;
    } else if (iconNameLower.contains('discord')) {
      return FontAwesomeIcons.discord;
    } else if (iconNameLower.contains('globe') || iconNameLower.contains('website')) {
      return FontAwesomeIcons.globe;
    } else {
      return FontAwesomeIcons.link; // Default icon for unknown platforms
    }
  }

  // Helper function to get social media platform name
  String _getSocialPlatformName(String iconName) {
    final iconNameLower = iconName.toLowerCase();

    if (iconNameLower.contains('facebook')) {
      return 'Facebook';
    } else if (iconNameLower.contains('twitter') || iconNameLower.contains('x')) {
      return 'Twitter/X';
    } else if (iconNameLower.contains('instagram')) {
      return 'Instagram';
    } else if (iconNameLower.contains('linkedin')) {
      return 'LinkedIn';
    } else if (iconNameLower.contains('youtube')) {
      return 'YouTube';
    } else if (iconNameLower.contains('whatsapp')) {
      return 'WhatsApp';
    } else if (iconNameLower.contains('telegram')) {
      return 'Telegram';
    } else if (iconNameLower.contains('google')) {
      return 'Google';
    } else if (iconNameLower.contains('discord')) {
      return 'Discord';
    } else if (iconNameLower.contains('globe') || iconNameLower.contains('website')) {
      return 'Website';
    } else {
      return 'Social Link'; // Default name for unknown platforms
    }
  }
}
