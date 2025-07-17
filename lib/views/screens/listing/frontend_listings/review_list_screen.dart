import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/frontend_listing_controller.dart';
import '../../../../controllers/listing_review_list_controller.dart';
import '../../../../routes/routes_name.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../home/home_screen.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  void initState() {
    ListingReviewController.to.getReviewList(
        page: ListingReviewController.to.page,
        listingId: ListingReviewController.to.listingId);
    ListingReviewController.to.scrollController = ScrollController()
      ..addListener(ListingReviewController.to.loadMore);
    super.initState();
  }

  @override
  void dispose() {
    ListingReviewController.to.scrollController.dispose();
    ListingReviewController.to.reviewList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ListingReviewController>(builder: (reviewCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Reviews'] ?? "Reviews",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            reviewCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await reviewCtrl.getReviewList(page: 1, listingId: reviewCtrl.listingId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: reviewCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  reviewCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 10, isReverseColor: true)
                      : reviewCtrl.reviewList.isEmpty
                          ? Helpers.notFound(text: "No reviews found")
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviewCtrl.reviewList.length,
                              itemBuilder: (context, i) {
                                var data = reviewCtrl.reviewList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      FrontendListingController.to
                                          .authorUsername = data.reviewerInfo ==
                                              null
                                          ? ""
                                          : data.reviewerInfo!.username ?? "";
                                      FrontendListingController.to
                                          .getAuthorProfile(
                                              userName:
                                                  data.reviewerInfo == null
                                                      ? ""
                                                      : data.reviewerInfo!
                                                              .username ??
                                                          "");
                                      Get.toNamed(
                                          RoutesName.authorProfileScreen);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 15.w),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius: Dimensions.kBorderRadius,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 34.h,
                                                width: 34.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor,
                                                  border: Border.all(
                                                      color:
                                                          AppColors.mainColor,
                                                      width: 2.h),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        data.reviewerInfo ==
                                                                null
                                                            ? ""
                                                            : data.reviewerInfo!
                                                                .image
                                                                .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              HSpace(15.w),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.reviewerInfo == null
                                                          ? ""
                                                          : data.reviewerInfo!
                                                              .username
                                                              .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    Row(
                                                      children: List.generate(
                                                          int.parse(data.rating
                                                              .toString()),
                                                          (i) => Icon(
                                                                Icons.star,
                                                                color: AppColors
                                                                    .starColor,
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
                                          VSpace(12.h),
                                          Text(
                                            data.review.toString(),
                                            style: t.displayMedium?.copyWith(
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.black50),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (reviewCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
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
