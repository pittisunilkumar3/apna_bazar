import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/controllers/app_controller.dart';
import 'package:listplace/controllers/frontend_listing_controller.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/styles.dart';
import '../../../../data/models/frontend_listing_details_model.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';

class ProductDetailsScreen extends StatelessWidget {
  final GetProduct? data;
  final String? listingId;
  ProductDetailsScreen({super.key, this.data, this.listingId = ""});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    c.CarouselSliderController controller = c.CarouselSliderController();
    return GetBuilder<FrontendListingController>(builder: (frontendCtrl) {
      return GetBuilder<ManageListingController>(builder: (managelistingCtrl) {
        return GetBuilder<AppController>(builder: (appCtrl) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data != null)
                  Container(
                    height: Dimensions.screenHeight * .35,
                    child: Stack(
                      children: [
                        caroselSection(controller, t, frontendCtrl),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 24.w, right: 24.w, top: 15.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkResponse(
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
                                ),
                                if (data!.productImage != null &&
                                    data!.productImage!.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DotsIndicator(
                                        dotsCount: data!.productImage!.length,
                                        position: frontendCtrl.carouselIndex,
                                        decorator: DotsDecorator(
                                          color: AppColors.whiteColor,
                                          activeColor: AppColors.mainColor,
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
                  ),
                VSpace(20.h),
                if (data != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${data?.productTitle.toString()}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                HSpace(20.w),
                                Text(
                                  '${HiveHelp.read(Keys.currencySymbol)}${data?.productPrice.toString()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodyLarge?.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            VSpace(28.h),
                            ReadMoreText(data!.productDescription.toString(),
                                trimLines: 5,
                                colorClickableText: AppColors.mainColor,
                                preDataTextStyle: context.t.bodySmall,
                                postDataTextStyle: context.t.bodySmall,
                                trimMode: TrimMode.Length,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: ' Show less',
                                lessStyle: context.t.displayMedium?.copyWith(
                                    height: 1.5, color: AppColors.mainColor),
                                moreStyle: context.t.displayMedium?.copyWith(
                                    height: 1.5, color: AppColors.mainColor),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: Styles.appFontFamily,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Get.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.black50)),
                            VSpace(28.h),
                            Container(
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
                                  Text("Make Query", style: t.displayMedium),
                                  VSpace(20.h),
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
                                    controller: frontendCtrl.queryMessageEditingCtrl,
                                    hintext: storedLanguage['Enter Message'] ??
                                        "Enter Message",
                                  ),
                                  VSpace(28.h),
                                  Material(
                                    color: Colors.transparent,
                                    child: AppButton(
                                      isLoading: frontendCtrl.isLoading,
                                      text:
                                          storedLanguage['Submit'] ?? "Submit",
                                      onTap: frontendCtrl.isLoading
                                          ? null
                                          : () async {
                                              Helpers.hideKeyboard();
                                              if (frontendCtrl.queryMessageEditingCtrl.text
                                                  .isEmpty) {
                                                Helpers.showSnackBar(
                                                    msg:
                                                        "Message field is required");
                                              } else {
                                                await frontendCtrl.querySubmit(
                                                  fields: {
                                                    "listing_id":
                                                        this.listingId,
                                                    "product_id": data == null
                                                        ? ""
                                                        : data?.id.toString(),
                                                    "message": frontendCtrl
                                                        .queryMessageEditingCtrl
                                                        .text,
                                                  },
                                                );
                                              }
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VSpace(58.h),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
      });
    });
  }

  c.CarouselSlider caroselSection(c.CarouselSliderController controller,
      TextTheme t, FrontendListingController frontendCtrl) {
    return c.CarouselSlider(
        carouselController: controller,
        items: data!.productImage == null || data!.productImage!.isEmpty
            ? [
                InkWell(
                  onTap: () {
                    Get.to(() => Scaffold(
                        appBar: const CustomAppBar(title: "PhotoView"),
                        body: PhotoView(
                          imageProvider:
                              NetworkImage(data!.productThumbnail.toString()),
                        )));
                  },
                  child: Container(
                    height: Dimensions.screenHeight * .3,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            data!.productThumbnail.toString()),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(18.r)),
                    ),
                  ),
                )
              ]
            : data!.productImage!
                .map(
                  (e) => InkWell(
                    onTap: () {
                      Get.to(() => Scaffold(
                          appBar: const CustomAppBar(title: "PhotoView"),
                          body: PhotoView(
                            imageProvider: NetworkImage(e.productImage ?? ""),
                          )));
                    },
                    child: Container(
                      height: Dimensions.screenHeight * .3,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(e.productImage ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(18.r)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16.r)),
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
                  ),
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
}
