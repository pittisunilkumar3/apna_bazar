import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/app_button.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/frontend_listing_controller.dart';
import '../../../../routes/routes_name.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';

class AuthorProfileScreen extends StatelessWidget {
  const AuthorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<FrontendListingController>(builder: (frontendListingCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
            title: storedLanguage['Author Profile'] ?? "Author Profile"),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            frontendListingCtrl.getAuthorProfile(userName: frontendListingCtrl.authorUsername);
          },
          child: SingleChildScrollView(
            child: frontendListingCtrl.isLoading
                ? SizedBox(
                    height: Dimensions.screenHeight,
                    width: Dimensions.screenWidth,
                    child: Helpers.appLoader(),
                  )
                : frontendListingCtrl.authorProfileList.isEmpty
                    ? SizedBox()
                    : Column(
                        children: [
                          // HEADER PORTION
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => Scaffold(
                                        appBar: const CustomAppBar(
                                            title: "PhotoView"),
                                        body: PhotoView(
                                            imageProvider:
                                                CachedNetworkImageProvider(frontendListingCtrl
                                                    .authorProfileList[0]
                                                    .coverImage
                                                    .toString())),
                                      ));
                                },
                                child: Container(
                                  height: 180.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppThemes.getFillColor(),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(frontendListingCtrl
                                            .authorProfileList[0].coverImage
                                            .toString()),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              Positioned(
                                bottom: -55.h,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => Scaffold(
                                          appBar: const CustomAppBar(
                                              title: "PhotoView"),
                                          body: PhotoView(
                                              imageProvider:
                                                  CachedNetworkImageProvider(frontendListingCtrl
                                                      .authorProfileList[0]
                                                      .image
                                                      .toString())),
                                        ));
                                  },
                                  child: Container(
                                    width: 116.h,
                                    height: 116.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppThemes.getFillColor(),
                                          width: 4.h,
                                        )),
                                    child: ClipOval(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                frontendListingCtrl.authorProfileList[0].image
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fitHeight,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          VSpace(60.h),
                          Padding(
                            padding: Dimensions.kDefaultPadding,
                            child: Column(
                              children: [
                                AppButton(
                                  buttonWidth: 180.w,
                                  buttonHeight: 35.h,
                                  onTap: frontendListingCtrl.isFollow
                                      ? null
                                      : () async {
                                          await frontendListingCtrl.followToAuthor(
                                              context: context,
                                              authorId: frontendListingCtrl
                                                  .authorProfileList[0].id
                                                  .toString());
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        frontendListingCtrl.isFollowingToAuthor
                                            ? Icons.remove
                                            : Icons.add,
                                        color: AppColors.blackColor,
                                        size: 24.h,
                                      ),
                                      HSpace(3.w),
                                      Text(
                                        frontendListingCtrl.isFollowingToAuthor
                                            ? "Unfollow"
                                            : "Follow",
                                        style: t.displayMedium?.copyWith(
                                            color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                VSpace(12.h),
                                Text(
                                    "${frontendListingCtrl.authorProfileList[0].firstname.toString()} ${frontendListingCtrl.authorProfileList[0].lastname.toString()}",
                                    style: t.displayMedium?.copyWith(
                                        fontWeight: FontWeight.w500)),
                                if (frontendListingCtrl.authorProfileList[0].bio != null)
                                  VSpace(12.h),
                                if (frontendListingCtrl.authorProfileList[0].bio != null)
                                  Text(
                                      "${frontendListingCtrl.authorProfileList[0].bio.toString()}",
                                      style: t.displayMedium?.copyWith(
                                          fontWeight: FontWeight.w500)),
                                if (frontendListingCtrl.authorProfileList[0].email != null)
                                  VSpace(12.h),
                                if (frontendListingCtrl.authorProfileList[0].email != null)
                                  Text(
                                      "${frontendListingCtrl.authorProfileList[0].email.toString()}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.displayMedium),
                                if (frontendListingCtrl.authorProfileList[0].website.toString() !=
                                    "null")
                                  VSpace(12.h),
                                if (frontendListingCtrl.authorProfileList[0].website.toString() !=
                                    "null")
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "$rootImageDir/world.png",
                                        height: 15.h,
                                        width: 15.h,
                                        color: AppThemes.getIconBlackColor(),
                                      ),
                                      HSpace(8.w),
                                      Text(
                                          "${frontendListingCtrl.authorProfileList[0].website.toString()}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.displayMedium),
                                    ],
                                  ),
                                if (frontendListingCtrl.authorProfileList[0].address != null &&
                                    frontendListingCtrl.authorProfileList[0].address
                                        .toString()
                                        .isNotEmpty)
                                  VSpace(12.h),
                                if (frontendListingCtrl.authorProfileList[0].address != null &&
                                    frontendListingCtrl.authorProfileList[0].address
                                        .toString()
                                        .isNotEmpty)
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: 165.w, maxWidth: 200.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "$rootImageDir/gps.png",
                                          height: 15.h,
                                          width: 15.h,
                                          color: AppThemes.getIconBlackColor(),
                                        ),
                                        HSpace(8.w),
                                        Expanded(
                                          child: Text(
                                              "${frontendListingCtrl.authorProfileList[0].address.toString()}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.displayMedium),
                                        ),
                                      ],
                                    ),
                                  ),
                                VSpace(12.h),
                                Text(
                                    "Joined ${DateFormat('dd, MMM, yyyy').format(DateTime.parse(frontendListingCtrl.authorProfileList[0].createdAt.toString()))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.displayMedium),
                              ],
                            ),
                          ),
                          VSpace(10.h),
                          Container(
                            color: AppThemes.getSliderInactiveColor(),
                            height: .5,
                            width: double.infinity,
                          ),
                          VSpace(20.h),
                          Padding(
                            padding: Dimensions.kDefaultPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Column(
                                  children: [
                                    Text("Listing",
                                        style: t.displayMedium?.copyWith(
                                            color:
                                                AppThemes.getParagraphColor())),
                                    Text(
                                        frontendListingCtrl.authorProfileList[0].totalListing
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyMedium),
                                  ],
                                )),
                                Flexible(
                                    child: Column(
                                  children: [
                                    Text("Total Views",
                                        style: t.displayMedium?.copyWith(
                                            color:
                                                AppThemes.getParagraphColor())),
                                    Text(
                                        frontendListingCtrl.authorProfileList[0].totalViews
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyMedium),
                                  ],
                                )),
                                Flexible(
                                    child: Column(
                                  children: [
                                    Text("Follower",
                                        style: t.displayMedium?.copyWith(
                                            color:
                                                AppThemes.getParagraphColor())),
                                    Text(
                                        frontendListingCtrl.authorProfileList[0].totalFollower
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyMedium),
                                  ],
                                )),
                                Flexible(
                                    child: Column(
                                  children: [
                                    Text("Following",
                                        style: t.displayMedium?.copyWith(
                                            color:
                                                AppThemes.getParagraphColor())),
                                    Text(
                                        frontendListingCtrl.authorProfileList[0].totalFollowing
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyMedium),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          VSpace(20.h),
                          Padding(
                            padding: Dimensions.kDefaultPadding,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 18.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                borderRadius: Dimensions.kBorderRadius,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Contact Creator", style: t.bodyMedium),
                                  VSpace(12.h),
                                  CustomTextField(
                                    fillColor: Get.isDarkMode
                                        ? AppColors.darkCardColorDeep
                                        : AppColors.whiteColor,
                                    controller:
                                        frontendListingCtrl.authorSendMsgFullNameEditingCtrl,
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                    hintext: storedLanguage['Fulll Name'] ??
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
                                    fillColor: Get.isDarkMode
                                        ? AppColors.darkCardColorDeep
                                        : AppColors.whiteColor,
                                    isPrefixIcon: false,
                                    controller:
                                        frontendListingCtrl.authorSendMsgMessageEditingCtrl,
                                    hintext: storedLanguage['Enter Message'] ??
                                        "Enter Message",
                                  ),
                                  VSpace(28.h),
                                  Material(
                                    color: Colors.transparent,
                                    child: AppButton(
                                      isLoading: frontendListingCtrl.isSubmittingMsgToAuthor,
                                      text:
                                          storedLanguage['Send Message Now'] ??
                                              "Send Message Now",
                                      onTap: frontendListingCtrl.isSubmittingListingMsg
                                          ? null
                                          : () async {
                                              await frontendListingCtrl.onMsgToListingAuthor(
                                                  context: context,
                                                  authorId: frontendListingCtrl
                                                      .authorProfileList[0].id
                                                      .toString());
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (frontendListingCtrl.authorProfileList[0].followerInfo != null)
                            VSpace(20.h),
                          if (frontendListingCtrl.authorProfileList[0].followerInfo != null)
                            Padding(
                              padding: Dimensions.kDefaultPadding,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 18.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Followers", style: t.bodyMedium),
                                    VSpace(10.h),
                                    if (frontendListingCtrl.authorProfileList[0].followerInfo!
                                        .isEmpty)
                                      Text(
                                        "No followers found",
                                        style: t.bodySmall?.copyWith(
                                            color:
                                                AppThemes.getIconBlackColor()),
                                      ),
                                    if (frontendListingCtrl.authorProfileList[0].followerInfo!
                                        .isNotEmpty)
                                      Wrap(
                                        children: [
                                          ...List.generate(
                                            frontendListingCtrl.authorProfileList[0].followerInfo!
                                                .length,
                                            (i) => Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10.w, bottom: 10.h),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                onTap: () {
                                                  frontendListingCtrl.authorUsername = frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followerInfo![i]
                                                          .username ??
                                                      "";
                                                  frontendListingCtrl.getAuthorProfile(
                                                      userName: frontendListingCtrl
                                                              .authorProfileList[
                                                                  0]
                                                              .followerInfo![i]
                                                              .username ??
                                                          "");
                                                  Get.toNamed(RoutesName
                                                      .authorProfileScreen);
                                                },
                                                child: Tooltip(
                                                  message: frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followerInfo![i]
                                                          .firstname
                                                          .toString() +
                                                      " " +
                                                      frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followerInfo![i]
                                                          .lastname
                                                          .toString(),
                                                  child: Container(
                                                    height: 55.h,
                                                    width: 55.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .darkCardColorDeep
                                                            : AppColors
                                                                .whiteColor,
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(frontendListingCtrl
                                                              .authorProfileList[
                                                                  0]
                                                              .followerInfo![i]
                                                              .image
                                                              .toString()),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (frontendListingCtrl.authorProfileList[0].followingInfo != null)
                            VSpace(20.h),
                          if (frontendListingCtrl.authorProfileList[0].followingInfo != null)
                            Padding(
                              padding: Dimensions.kDefaultPadding,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 18.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Following", style: t.bodyMedium),
                                    VSpace(10.h),
                                    if (frontendListingCtrl.authorProfileList[0].followingInfo!
                                        .isEmpty)
                                      Text(
                                        "No followings found",
                                        style: t.bodySmall?.copyWith(
                                            color:
                                                AppThemes.getIconBlackColor()),
                                      ),
                                    if (frontendListingCtrl.authorProfileList[0].followingInfo!
                                        .isNotEmpty)
                                      Wrap(
                                        children: [
                                          ...List.generate(
                                            frontendListingCtrl.authorProfileList[0]
                                                .followingInfo!.length,
                                            (i) => Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10.w, bottom: 10.h),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                onTap: () {
                                                  frontendListingCtrl.authorUsername = frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followingInfo![i]
                                                          .username ??
                                                      "";
                                                  frontendListingCtrl.getAuthorProfile(
                                                      userName: frontendListingCtrl
                                                              .authorProfileList[
                                                                  0]
                                                              .followingInfo![i]
                                                              .username ??
                                                          "");
                                                  Get.toNamed(RoutesName
                                                      .authorProfileScreen);
                                                },
                                                child: Tooltip(
                                                  message: frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followingInfo![i]
                                                          .firstname
                                                          .toString() +
                                                      " " +
                                                      frontendListingCtrl
                                                          .authorProfileList[0]
                                                          .followingInfo![i]
                                                          .lastname
                                                          .toString(),
                                                  child: Container(
                                                    height: 55.h,
                                                    width: 55.h,
                                                    decoration: BoxDecoration(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .darkCardColorDeep
                                                            : AppColors
                                                                .whiteColor,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(frontendListingCtrl
                                                              .authorProfileList[
                                                                  0]
                                                              .followingInfo![i]
                                                              .image
                                                              .toString()),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          VSpace(50.h),
                        ],
                      ),
          ),
        ),
      );
    });
  }
}
